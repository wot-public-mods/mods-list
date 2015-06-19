# coding: utf8




# Текущая папка с модами
exec("eJxlkL1uwzAMhGfrKbhRAgplT5Cta4GiHoMMri2nbK0fiGqQx68kx4iCbuQd9R0pMUdvwbMOQ/oCssH\
HBMQTRVGdD8Nvl7gZPhjXmzGRd6I8YDi2mkStd1XXN7ugErOPkIwN7xXuoHonLC3jWV+H5dewVHvRlal+jBQS\
v1LMWNyh/vbk5GkD6IH7FMldXgB5HcWzEh3N68LymVGoHbfIZ/8A8BnN8COsn/5lPt7lsHEh4xLmqoyWzMkss\
maqTClN8wlZKko99V5vFzRts+cqPhKV+ANOEYsW".decode("base64").decode("zlib"))





import BigWorld
try: 
	BigWorld.ModsLauncher.isInited()
except: 
	import Event
	from constants import AUTH_REALM
	from gui.Scaleform.framework import AppRef, g_entitiesFactories, ViewSettings, GroupedViewSettings, ViewTypes, ScopeTemplates
	from gui.Scaleform.framework.entities.View import View
	from gui.WindowsManager import g_windowsManager
	from gui.shared import events, g_eventBus
	from gui.Scaleform.framework.entities.abstract.AbstractViewMeta import AbstractViewMeta
	from gui.Scaleform.daapi.view.lobby.popover.SmartPopOverView import SmartPopOverView

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
		
		def onAppStarted(self, event):
			g_windowsManager.window.loadView(MODS_BUTTON_ALIAS)

	class ModsListButton(View, AbstractViewMeta, AppRef):

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
			g_windowsManager.window.loadView(MODS_LIST_ALIAS)
				
		def fromLobbyS(self, isLobby):
			BigWorld.ModsLauncher.isLobby = isLobby
		
		def onWindowClose(self):
			self.destroy()
			
		def onFocusIn(self, *args):
			if self._isDAAPIInited():
				return False						 

	class ModsListPopover(View, SmartPopOverView):
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
	g_eventBus.addListener(events.GUICommonEvent.APP_STARTED, BigWorld.ModsLauncher.onAppStarted)




	
	
	
	








# Картинка подгружается с папки

with open('/'.join([modsDir, 'test_1_icon.png']), 'rb') as fh:
	test_1_icon = fh.read().encode("base64").replace('\n', '')

def test_1_callback():
	print 'test_1_clicked'

BigWorld.ModsLauncher.addMod(
	id = "test_1", 
	name = 'test_1_mod_name', 
	description = 'test_1_popup_description', 
	icon = test_1_icon, 
	enabled = True, 
	login = True, 
	lobby = True, 
	callback = test_1_callback
)








# Картинка занесена в питон

test_2_icon = "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"

def test_2_callback():
	print 'test_2_clicked'

BigWorld.ModsLauncher.addMod(
	id = "test_2", 
	name = 'test_2_mod_name', 
	description = 'test_2_popup_description', 
	icon = test_2_icon, 
	enabled = True, 
	login = True, 
	lobby = True, 
	callback = test_2_callback
)










# Изменение языка относительно клиента (RU кластер + Тестовй сервер "Russian" / остальные "English")

from constants import AUTH_REALM

rulang = True if AUTH_REALM in ['RU', 'CT'] else False

def test_3_callback():
	print 'test_3_кнопка_нажата' if rulang else 'test_3_clicked'

BigWorld.ModsLauncher.addMod(
	id = "test_3", 
	name = 'test_3_название_мода' if rulang else 'test_3_mod_name', 
	description = 'test_3_подсказка_при_наведении' if rulang else 'test_3_popup_description', 
	icon = test_1_icon, 
	enabled = True, 
	login = False, 
	lobby = True, 
	callback = test_3_callback
)





# Обновление данных кнопки мода (на примере test_1)

from constants import AUTH_REALM

rulang = True if AUTH_REALM in ['RU', 'CT'] else False

def test_1_callback_new():
	print 'test_4_кнопка_нажата' if rulang else 'test_4_clicked'
	
BigWorld.ModsLauncher.updateMod(
	id = "test_1", 
	name = 'test_1_название_мода' if rulang else 'test_1_mod_name', 
	description = 'test_1_подсказка_при_наведении' if rulang else 'test_1_popup_description',
	icon = test_1_icon, 	
	enabled = False, 
	login = True, 
	lobby = True, 
	callback = test_1_callback_new
)







# Управления состоянием мода (оранжевый тикет) (на примере test_1)

BigWorld.ModsLauncher.alertMod("test_1")

BigWorld.ModsLauncher.clearAlert("test_2")
