
import BigWorld
import Event
from constants import AUTH_REALM
from gui.Scaleform.framework import g_entitiesFactories, ViewSettings, GroupedViewSettings, ViewTypes, ScopeTemplates
from gui.Scaleform.framework.entities.View import View
from gui.Scaleform.framework.entities.abstract.AbstractPopOverView import AbstractPopOverView
from gui.app_loader.loader import g_appLoader
from gui.app_loader.settings import APP_NAME_SPACE
from gui.shared import events, g_eventBus, EVENT_BUS_SCOPE

from gui.Scaleform.daapi.view.login.LoginView import LoginView
from gui.Scaleform.daapi.view.lobby.LobbyView import LobbyView

__all__ = ("g_modsListApi")

class ModsListApiController(object):

	def __init__(self):
		
		self.__mods = dict()
		
		self.tooltipText = 'Список модификаций: удобный запуск, настройка и оповещение.' if AUTH_REALM in ['RU', 'CT'] else 'Modifications list: comfortable run, setup and alert.'
		self.titleText = 'Список модификаций' if AUTH_REALM in ['RU', 'CT'] else 'Modifications list'
		
		self.isLobby = False
		
		self.onChangeScreenResolution = Event.Event()
		self.onButtonBlinking = Event.Event()
		self.onListUpdated = Event.Event()
		self.onScopeChanged = Event.Event()
		
		loginPopulate = LoginView._populate
		lobbyPopulate = LobbyView._populate
		LoginView._populate = lambda baseClass: self.__hooked_loginPopulate(baseClass, loginPopulate)
		LobbyView._populate = lambda baseClass: self.__hooked_lobbyPopulate(baseClass, lobbyPopulate)
		
		g_eventBus.addListener(events.AppLifeCycleEvent.INITIALIZED, self.__onAppInitialized, scope=EVENT_BUS_SCOPE.GLOBAL)
		g_eventBus.addListener(events.GameEvent.CHANGE_APP_RESOLUTION, self.__onAppResolutionChanged, scope=EVENT_BUS_SCOPE.GLOBAL)
		
	def __onAppInitialized(self, event):
		if event.ns == APP_NAME_SPACE.SF_LOBBY:
			app = g_appLoader.getApp(event.ns)
			if app is not None:
				BigWorld.callback(0.0, lambda: app.loadView('modsListButton'))
		
	def __onAppResolutionChanged(self, event):
		if event.ctx is not None and not self.isLobby:
			self.onChangeScreenResolution(event.ctx['width'], event.ctx['height'])
			
	def __hooked_loginPopulate(self, baseClass, baseFunc):
		baseFunc(baseClass)
		self.isLobby = False
		self.onScopeChanged()
	
	def __hooked_lobbyPopulate(self, baseClass, baseFunc):
		baseFunc(baseClass)
		self.isLobby = True
		self.onScopeChanged()
	
	def addMod(self, id, name = None, description = None, icon = None, enabled = None, login = None, lobby = None, callback = None):
		if id in self.__mods.keys(): 
			self.updateMod(id, name, description, icon, enabled, login, lobby, callback)
			return
		if name is None or description is None or icon is None or enabled is None or login is None or lobby is None or callback is None:
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
			if self.isLobby and item['lobby']: result.append(item)
			elif not self.isLobby and item['login']: result.append(item)
		return result
		
	def callMod(self, id):
		if id not in self.__mods.keys(): 
			return
		func = self.__mods[id]['callback']
		func()

class ModsListButton(View):
	
	def _populate(self):
		super(ModsListButton, self)._populate()
		g_modsListApi.onButtonBlinking += self.__handleButtonBlinking
		g_modsListApi.onChangeScreenResolution += self.processScreenResolution
		g_modsListApi.onScopeChanged += self.processPopulate
		if self._isDAAPIInited():
			self.flashObject.as_setTooltipText(g_modsListApi.tooltipText)
		self.processPopulate()
	
	def _dispose(self):
		g_modsListApi.onButtonBlinking -= self.__handleButtonBlinking  
		g_modsListApi.onChangeScreenResolution -= self.processScreenResolution
		g_modsListApi.onScopeChanged -= self.processPopulate
		super(ModsListButton, self)._dispose()	   
	
	def onButtonClickS(self):
		g_appLoader.getDefLobbyApp().loadView('modsListPopover')
	
	def processPopulate(self):
		if self._isDAAPIInited():
			if g_modsListApi.isLobby:
				self.flashObject.as_populateLobby()
			else:
				self.flashObject.as_populateLogin()
	
	def logS(self, *args):
		print '[INFO] modsListApi BUTTON ' + ' '.join([str(arg) for arg in args])
	
	def debugLogS(self, *args):
		print '[DEBUG] modsListApi BUTTON ' + ' '.join([str(arg) for arg in args])
	
	def processScreenResolution(self, width, height):
		if self._isDAAPIInited():
			# fixed https://youtu.be/mYuOQ-LMKNU
			return BigWorld.callback(0.0, lambda: self.flashObject.as_handleChangeScreenResolution(width, height))
	
	def __handleButtonBlinking(self):
		if self._isDAAPIInited():
			return self.flashObject.as_handleButtonBlinking()
	
	def onFocusIn(self, *args):
		if self._isDAAPIInited():
			return False	

class ModsListPopover(AbstractPopOverView):
	
	def _populate(self):
		super(ModsListPopover, self)._populate()
		g_modsListApi.onListUpdated += self.__handleListUpdate				   
		if self._isDAAPIInited():
			self.flashObject.as_setTitleText(g_modsListApi.titleText)
	
	def _dispose(self):
		g_modsListApi.onListUpdated -= self.__handleListUpdate  
		super(ModsListPopover, self)._dispose()	   
		
	def __collectModsData(self):
		mods = g_modsListApi.getModsList()
		self.as_setDataS(mods)
		
	def __handleListUpdate(self):
		self.__collectModsData()
		
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

g_entitiesFactories.addSettings(ViewSettings('modsListButton', ModsListButton, '../../scripts/client/gui/mods/modsListApi/modsListButton.swf', ViewTypes.WINDOW, None, ScopeTemplates.GLOBAL_SCOPE))
g_entitiesFactories.addSettings(GroupedViewSettings('modsListPopover', ModsListPopover, '../../scripts/client/gui/mods/modsListApi/modsListPopover.swf', ViewTypes.WINDOW, 'modsListPopover', 'modsListPopover', ScopeTemplates.DEFAULT_SCOPE))

print "[NOTE] package loaded: mod_modsListAPI"
