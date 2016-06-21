
from gui.mods.modsListApi import g_modsListApi


"""
	Картинка подгружается с папки
"""

with open('/'.join(['some', 'path', 'to', 'your', 'icon.png']), 'rb') as fh:
	test_1_icon = fh.read().encode("base64").replace('\n', '')

def test_1_callback():
	print 'test_1_clicked'

g_modsListApi.addMod(
	id = "test_1", 
	name = 'test_1_mod_name', 
	description = 'test_1_popup_description', 
	icon = test_1_icon, 
	enabled = True, 
	login = True, 
	lobby = True, 
	callback = test_1_callback
)








"""
	Картинка занесена в питон
"""

test_2_icon = "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"

def test_2_callback():
	print 'test_2_clicked'

g_modsListApi.addMod(
	id = "test_2", 
	name = 'test_2_mod_name', 
	description = 'test_2_popup_description', 
	icon = test_2_icon, 
	enabled = True, 
	login = True, 
	lobby = True, 
	callback = test_2_callback
)









"""
	Изменение языка относительно клиента (RU кластер + Тестовый сервер "Russian" / остальные "English")
"""

from constants import AUTH_REALM
rulang = True if AUTH_REALM in ['RU', 'CT'] else False

def test_3_callback():
	print 'test_3_кнопка_нажата' if rulang else 'test_3_clicked'

g_modsListApi.addMod(
	id = "test_3", 
	name = 'test_3_название_мода' if rulang else 'test_3_mod_name', 
	description = 'test_3_подсказка_при_наведении' if rulang else 'test_3_popup_description', 
	icon = test_1_icon, 
	enabled = True, 
	login = False, 
	lobby = True, 
	callback = test_3_callback
)







"""
	Обновление данных кнопки мода (на примере test_1)
	Можно передавать как все так и отдельные параметры
"""

def test_1_callback_new():
	print 'test_4_кнопка_нажата' if rulang else 'test_4_clicked'

g_modsListApi.updateMod(
	id = "test_1", 
	name = 'test_1_название_мода' if rulang else 'test_1_mod_name', 
	description = 'test_1_подсказка_при_наведении' if rulang else 'test_1_popup_description',
	icon = test_1_icon, 	
	enabled = False, 
	login = True, 
	lobby = True, 
	callback = test_1_callback_new
)

g_modsListApi.updateMod(
	id = "test_1", 
	enabled = True, 
)








"""
	Управления состоянием мода (оранжевый тикет + мигание кнопки) (на примере test_1)
"""

g_modsListApi.alertMod("test_1")
g_modsListApi.clearAlert("test_1")


