import BigWorld
import Event
from constants import AUTH_REALM
from gui.app_loader.loader import g_appLoader
from gui.app_loader.settings import APP_NAME_SPACE
from gui.Scaleform.daapi.view.meta.MessengerBarMeta import MessengerBarMeta
from gui.Scaleform.framework import g_entitiesFactories, ViewSettings, GroupedViewSettings, ViewTypes, ScopeTemplates
from gui.Scaleform.framework.entities.View import View
from gui.Scaleform.framework.entities.abstract.AbstractPopOverView import AbstractPopOverView
from gui.shared import events, g_eventBus, EVENT_BUS_SCOPE

__all__ = ('g_modsListApi')

class ModsListApiController(object):

	def __init__(self):
		
		self.__mods = dict()
		self.isLobby = False
		
		self.tooltipText = '{BODY}Список модификаций: удобный запуск, настройка и оповещение{/BODY}' if AUTH_REALM in ['RU', 'CT'] else '{BODY}Modifications list: comfortable run, setup and alert{BODY}'
		self.titleText = 'Список модификаций' if AUTH_REALM in ['RU', 'CT'] else 'Modifications list'
		
		self.onButtonBlinking = Event.Event()
		self.onListUpdated = Event.Event()
		self.handleCompareBasketVisibility = Event.Event()
		
		MessengerBarButtonVisibleS = MessengerBarMeta.as_setVehicleCompareCartButtonVisibleS
		MessengerBarMeta.as_setVehicleCompareCartButtonVisibleS = lambda baseClass, value: self.__hooked_compareBasketButtonVisibility(baseClass, MessengerBarButtonVisibleS, value)
		g_eventBus.addListener(events.AppLifeCycleEvent.INITIALIZED, self.__onAppInitialized, scope=EVENT_BUS_SCOPE.GLOBAL)
		
	def __onAppInitialized(self, event):
		if event.ns == APP_NAME_SPACE.SF_LOBBY:
			app = g_appLoader.getApp(event.ns)
			if app is not None:
				BigWorld.callback(0.0, lambda: app.loadView('modsListButton'))
	
	def __hooked_compareBasketButtonVisibility(self, baseClass, baseFunc, isVisible):
		baseFunc(baseClass, isVisible)
		if not isVisible:
			self.handleCompareBasketVisibility()
	
	def addMod(self, id, name = None, description = None, icon = None, enabled = None, login = None, lobby = None, callback = None):
		if id in self.__mods.keys(): 
			self.updateMod(id, name, description, icon, enabled, login, lobby, callback)
			return
		if name is None or description is None or enabled is None or login is None or lobby is None or callback is None:
			return
		self.__mods[id] = {'id': id, 'name': name, 'icon': icon, 'description': description, 'enabled': enabled, 'login': login, 'lobby': lobby, 'callback': callback, 'alert': False}
		self.onListUpdated()
		
	def updateMod(self, id, name = None, description = None, icon = None, enabled = None, login = None, lobby = None, callback = None):
		if id not in self.__mods.keys(): 
			return
		old = dict(self.__mods[id])
		self.__mods[id] = {
			'id': id, 
			'name': name if name is not None else old['name'], 
			'description': description if description is not None else old['description'], 
			'icon': icon if icon is not None else old['icon'], 
			'enabled': enabled if enabled is not None else old['enabled'], 
			'login': login if login is not None else old['login'], 
			'lobby': lobby if lobby is not None else old['lobby'], 
			'callback': callback if callback is not None else old['callback'],
			'alert': old['alert']
		}
		self.onListUpdated() 

	def alertMod(self, id):
		if id not in self.__mods.keys(): 
			return
		self.__mods[id]['alert'] = True
		self.onListUpdated()
		self.onButtonBlinking() 

	def clearAlert(self, id):
		if id not in self.__mods.keys(): 
			return
		self.__mods[id]['alert'] = False
		self.onListUpdated()
		
	def getModsList(self):
		result = list()
		for item in self.__mods.values():
			if self.isLobby and item['lobby']: 
				result.append(item)
			elif not self.isLobby and item['login']: 
				result.append(item)
		return sorted(result, key=lambda x: x['name'])
		
	def callMod(self, id):
		if id not in self.__mods.keys(): 
			return
		callback = self.__mods[id]['callback']
		if callback:
			callback()
	
class ModsListButton(View):
	
	def _populate(self):
		super(ModsListButton, self)._populate()
		g_modsListApi.handleCompareBasketVisibility += self.__handleCompareBasketVisibility
		g_modsListApi.onButtonBlinking += self.__handleButtonBlinking
		self.flashObject.as_setTooltipText(g_modsListApi.tooltipText)
	
	def _dispose(self):
		g_modsListApi.onButtonBlinking -= self.__handleButtonBlinking
		g_modsListApi.handleCompareBasketVisibility -= self.__handleCompareBasketVisibility
		super(ModsListButton, self)._dispose()	   
	
	def onButtonClickS(self, isLobby):
		g_modsListApi.isLobby = isLobby
		g_appLoader.getDefLobbyApp().loadView('modsListPopover')
	
	def __handleButtonBlinking(self):
		if self._isDAAPIInited():
			return self.flashObject.as_ButtonBlinking()
	
	def __handleCompareBasketVisibility(self):
		if self._isDAAPIInited():
			# BigWorld.callback for process CompareButton visibility in next frame
			BigWorld.callback(0, self.flashObject.as_handleCompareBasketVisibility)
			
	def onFocusIn(self, *args):
		if self._isDAAPIInited():
			return False	

class ModsListPopover(AbstractPopOverView):
	
	def _populate(self):
		super(ModsListPopover, self)._populate()
		g_modsListApi.onListUpdated += self.__collectModsData				   
		if self._isDAAPIInited():
			self.flashObject.as_setTitleText(g_modsListApi.titleText)
	
	def _dispose(self):
		g_modsListApi.onListUpdated -= self.__collectModsData  
		super(ModsListPopover, self)._dispose()	   
		
	def __collectModsData(self):
		mods = g_modsListApi.getModsList()
		self.as_setDataS(mods)
		
	def clearAlertS(self, id):
		g_modsListApi.clearAlert(id)
		
	def getModsListS(self):
		self.__collectModsData()  
		
	def callModS(self, id):
		g_modsListApi.callMod(id)
		
	def as_handleModAlertS(self, id):
		if self._isDAAPIInited():
			return self.flashObject.as_handleModAlert(id)
		
	def as_setDataS(self, data):
		if self._isDAAPIInited():
			return self.flashObject.as_setData(data)

g_modsListApi = ModsListApiController()

g_entitiesFactories.addSettings(ViewSettings('modsListButton', ModsListButton, 'modsListButton.swf', ViewTypes.WINDOW, None, ScopeTemplates.GLOBAL_SCOPE))
g_entitiesFactories.addSettings(GroupedViewSettings('modsListPopover', ModsListPopover, 'modsListPopover.swf', ViewTypes.WINDOW, 'modsListPopover', 'modsListPopover', ScopeTemplates.DEFAULT_SCOPE))
