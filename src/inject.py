# coding: utf8

"""
	Код вашей модификации
"""

import BigWorld
try: 
	BigWorld.ModsLauncher.isInited()
except: 
	import Event
	from constants import AUTH_REALM
	from gui.Scaleform.framework import g_entitiesFactories, ViewSettings, GroupedViewSettings, ViewTypes, ScopeTemplates
	from gui.Scaleform.framework.entities.View import View
	from gui.app_loader.loader import g_appLoader
	from gui.shared import events, g_eventBus
	from gui.Scaleform.framework.entities.abstract.AbstractViewMeta import AbstractViewMeta
	from gui.Scaleform.framework.entities.abstract.AbstractPopOverView import AbstractPopOverView
	
	MODS_BUTTON_ALIAS = 'ModsListButton'
	MODS_LIST_ALIAS = 'ModsListPopover'

	class ModsLauncherController(object):
		
		def __init__(self):
			self.mods = dict()
			self.isLobby = False
			self.onUpdateMod = Event.Event()
			if AUTH_REALM in ['RU', 'CT']:
				self.tooltipText = 'Список модификаций: удобный запуск, настройка и оповещение.'
				self.titleText = 'Список модификаций'
			else:
				self.tooltipText = 'Modifications list: comfortable run, setup and alert.'
				self.titleText = 'Modifications list'
		
		def isInited(self):
			return True

		def addMod(self, id, name, description, icon, enabled, login, lobby, callback):
			if id in self.mods.keys(): 
				return
			self.mods[id] = {'id': id, 'name': name, 'icon': icon, 'description': description, 'enabled': enabled, 'login': login, 'lobby': lobby, 'callback': callback}
			
		def updateMod(self, id, name, description, icon, enabled, login, lobby, callback):
			if id not in self.mods.keys(): 
				return
			self.mods[id] = {'id': id, 'name': name, 'icon': icon, 'description': description, 'enabled': enabled, 'login': login, 'lobby': lobby, 'callback': callback}
			self.onUpdateMod() 
			
		def alertMod(self, id):
			if id not in self.mods.keys(): 
				return
			self.mods[id]['alert'] = True
			self.onUpdateMod() 

		def clearAlert(self, id):
			if id not in self.mods.keys(): 
				return
			self.mods[id]['alert'] = False
			
		def getModsList(self):
			result = list()
			for item in self.mods.values():
				if self.isLobby and item['lobby']: result.append(item)
				elif not self.isLobby and item['login']: result.append(item)
			return result
			
		def callMod(self, id):
			if id not in self.mods.keys(): 
				return
			func = self.mods[id]['callback']
			func()
		
		def onAppInitialized(self, event):
			g_appLoader.getDefLobbyApp().loadView(MODS_BUTTON_ALIAS)

	class ModsListButton(View, AbstractViewMeta):

		def __init__(self):
			super(ModsListButton, self).__init__()
			
		def _populate(self):
			super(ModsListButton, self)._populate()
			BigWorld.ModsLauncher.onUpdateMod += self.__handleListUpdate
			if self._isDAAPIInited():
				self.flashObject.as_setTooltipText(BigWorld.ModsLauncher.tooltipText)
		def _dispose(self):
			BigWorld.ModsLauncher.onUpdateMod -= self.__handleListUpdate  
			super(ModsListButton, self)._dispose() 
			
		def __handleListUpdate(self):
			if self._isDAAPIInited():
				return self.flashObject.as_handleModAlert()
				
		def modsMenuButtonClickS(self):
			g_appLoader.getDefLobbyApp().loadView(MODS_LIST_ALIAS)
				
		def fromLobbyS(self, isLobby):
			BigWorld.ModsLauncher.isLobby = isLobby
		
		def onWindowClose(self):
			self.destroy()
			
		def onFocusIn(self, *args):
			if self._isDAAPIInited():
				return False						 

	class ModsListPopover(AbstractPopOverView):
		
		def __init__(self):
			super(ModsListPopover, self).__init__()			  
			
		def _populate(self):
			super(ModsListPopover, self)._populate()
			BigWorld.ModsLauncher.onUpdateMod += self.__handleListUpdate				   
			if self._isDAAPIInited():
				self.flashObject.as_setTitleText(BigWorld.ModsLauncher.titleText)
		
		def _dispose(self):
			BigWorld.ModsLauncher.onUpdateMod -= self.__handleListUpdate  
			super(ModsListPopover, self)._dispose()	   
			
		def __collectModsData(self):
			mods = BigWorld.ModsLauncher.getModsList()
			self.as_setDataS(mods)
			
		def __handleListUpdate(self):
			self.__collectModsData()
			
		def clearAlertS(self, id):
			BigWorld.ModsLauncher.clearAlert(id)
			
		def getModsListS(self):
			self.__collectModsData()  
			
		def callModS(self, id):
			BigWorld.ModsLauncher.callMod(id)
			
		def as_handleModAlertS(self, id):
			if self._isDAAPIInited():
				return self.flashObject.as_handleModAlert(id)
			
		def as_setDataS(self, data):
			if self._isDAAPIInited():
				return self.flashObject.as_setData(data)
		
	_modsButtonSettings = ViewSettings(MODS_BUTTON_ALIAS, ModsListButton, 'ModsListButton.swf', ViewTypes.WINDOW, None, ScopeTemplates.GLOBAL_SCOPE)	  
	_modsListSettings = GroupedViewSettings(MODS_LIST_ALIAS, ModsListPopover, 'ModsListPopover.swf', ViewTypes.WINDOW, 'ModsListPopover', MODS_LIST_ALIAS, ScopeTemplates.DEFAULT_SCOPE)  
	g_entitiesFactories.addSettings(_modsListSettings) 
	g_entitiesFactories.addSettings(_modsButtonSettings)   

	BigWorld.ModsLauncher = ModsLauncherController()
	g_eventBus.addListener(events.AppLifeCycleEvent.INITIALIZED, BigWorld.ModsLauncher.onAppInitialized)