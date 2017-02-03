
from gui.modsListApi.controller import *
from gui.modsListApi.data import *
from gui.modsListApi.events import *
from gui.modsListApi.hooks import *
from gui.modsListApi.lang import *
from gui.modsListApi.view import *

__all__ = ('g_modsListApi', )

class ModsListApiRepresentation():
	
	@staticmethod
	def addModification(*args, **kwargs):
		g_controller.addModification(*args, **kwargs)
	
	@staticmethod
	def updateModification(*args, **kwargs):
		g_controller.updateModification(*args, **kwargs)
	
	@staticmethod
	def alertModification(*args, **kwargs):
		g_controller.alertModification(*args, **kwargs)
	
	@staticmethod
	def clearModificationAlert(*args, **kwargs):
		g_controller.clearModificationAlert(*args, **kwargs)

g_modsListApi = ModsListApiRepresentation()
