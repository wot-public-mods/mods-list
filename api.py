
"""
	method addMod
		:param id: Uniq modification ID - required
		:param name: Modification name - required
		:param description: Modification hint (mouse over) - required
		:param icon: Modification icon (path from res_mods/<game_vaersion>/) - required
		:param enabled: Is modification enabled (can be clicked) - required
		:param login: Show modification on Login Window - required
		:param lobby: Show modification in Lobby - required
		:param callback: Called on modification click - required
	
	method updateMod
		:param id: Uniq modification ID - required
		:param name: Modification name - not necessary
		:param description: Modification hint (mouse over) - not necessary
		:param icon: Modification icon (path from res_mods/<game_vaersion>/) - not necessary
		:param enabled: Is modification enabled (can be clicked) - not necessary
		:param login: Show modification on Login Window - not necessary
		:param lobby: Show modification in Lobby - not necessary
		:param callback: Called on modification click - not necessary
		
	method alertMod
		:param id: Uniq modification ID - required
	
	method clearAlert
		:param id: Uniq modification ID - required
"""



from gui.mods.modsListApi import g_modsListApi

def test1_callback():
	print 'test1_callback'

g_modsListApi.addMod(
	id = "test1", 
	name = 'test1 mod name', 
	description = 'test1 hint', 
	icon = 'scripts/client/gui/mods/test1.png', 
	enabled = True, 
	login = True, 
	lobby = True, 
	callback = test1_callback
)



"""
	Change lang (RU cluster "Russian", else "English")
"""

from constants import AUTH_REALM
ru_realm = True if AUTH_REALM in ['EU', 'CT'] else False

def test2_callback():
	print 'test2 кнопка нажата' if ru_realm else 'test2 button clicked'

g_modsListApi.addMod(
	id = "test2", 
	name = 'test2 название мода' if ru_realm else 'test2 mod name', 
	description = 'test2 подсказка' if ru_realm else 'test2 hint', 
	enabled = True, 
	login = False, 
	lobby = True, 
	callback = test2_callback
)



"""
	Update mod_item data (test2 in the example)
	Passing of all parameters is not necessary
"""

g_modsListApi.updateMod(
	id = 'test2', 
	icon = 'scripts/client/gui/mods/test2.png', 
	login = True
)



"""
	Managing mod_item state (orange ticket + button blinking) (test1 in the example)
"""

g_modsListApi.alertMod("test1")
g_modsListApi.clearAlert("test1")
