
from gui.modsListApi import g_modsListApi as _modsListApi

__all__ = ('g_modsListApi')

class OldModsListApiRepresentation():
	"""This entry poit DEPRECATED! Backward compatibility will continue until 9.18"""
	def addMod(self, *args, **kwargs):
		_modsListApi.addModification(*args, **kwargs)
	
	def updateMod(self, *args, **kwargs):
		_modsListApi.updateModification(*args, **kwargs)
	
	def alertMod(self, *args, **kwargs):
		_modsListApi.alertModification(*args, **kwargs)
	
	def clearAlert(self, *args, **kwargs):
		_modsListApi.clearModificationAlert(*args, **kwargs)
	
g_modsListApi = OldModsListApiRepresentation()	
