
from debug_utils import LOG_ERROR

__all__ = ('g_controller', )

class ApiLogicController(object):
	
	modifications = property(lambda self: self.__modifications)
	
	def __init__(self):
		self.__modifications = dict()
		self.__isInLobby = False
	
	def addModification(self, id, name = None, description = None, icon = None, enabled = None, login = None, lobby = None, callback = None):
		if id in self.__modifications.keys(): 
			self.updateModification(id, name, description, icon, enabled, login, lobby, callback)
			return
		if name is None or description is None or enabled is None or login is None or lobby is None or callback is None:
			LOG_ERROR('method @addModification required mandatory parameters [name, description, enabled, login, lobby, callback]')
			return
		
		from gui.modsListApi.data import ModificationItem
		modification = ModificationItem()
		modification.setData(id, name, description, icon, enabled, login, lobby, callback)
		self.__modifications[id] = modification
	
	def updateModification(self, id, name = None, description = None, icon = None, enabled = None, login = None, lobby = None, callback = None):
		if id not in self.__modifications.keys(): 
			LOG_ERROR('method @updateModification required ModificationItem instance, use @addModification instead updateModification')
			return
		modification = self.__modifications[id]
		modification.setData(id, name, description, icon, enabled, login, lobby, callback)
	
	def alertModification(self, id):
		if id not in self.__modifications.keys(): 
			LOG_ERROR('method @alertModification required ModificationItem instance, check the id argument')
			return
		modification = self.__modifications[id]
		modification.setAlerting(True)

	def clearModificationAlert(self, id):
		if id not in self.__modifications.keys(): 
			LOG_ERROR('method @clearModificationAlert required ModificationItem instance, check the id argument')
			return
		modification = self.__modifications[id]
		modification.setAlerting(False)

	def __set_isInLobby(self, isInLobby):
		self.__isInLobby = isInLobby
	
	isInLobby = property(lambda self: self.__isInLobby, __set_isInLobby)
	
g_controller = ApiLogicController()