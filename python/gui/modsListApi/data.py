
from debug_utils import LOG_ERROR, LOG_CURRENT_EXCEPTION
from ids_generators import SequenceIDGenerator

from gui.modsListApi.controller import g_controller
from gui.modsListApi.lang import l10n
from gui.modsListApi.events import g_eventsManager

__all__ = ('g_dataProvider', 'ModificationItem', )

class _DataProvider(object):
	
	modsData = property(lambda self: self.__generateModsData())
	staticData = property(lambda self: self.__generateStaticData())
	
	def __generateModsData(self):
		"""return value Represented by ModsListStaticDataVO (AS)"""
		result = list()
		for item in g_controller.modifications.values():
			if item.available:
				result.append(item.dpData)
		
		if result:
			result = sorted(result, key=lambda item: item['id'])
		
		if not result:
			result.append({})
		
		return {
			'mods' : result
		}
	
	def __generateStaticData(self):
		"""return value Represented by ModsListModsVO (AS)"""
		return {
			'titleLabel' : l10n('title'),
			'descriptionLabel' : l10n('description'),
			'closeButtonVisible' : True
		}
	
g_dataProvider = _DataProvider()

IDGenerator = SequenceIDGenerator()

class ModificationItem(object):
	
	id = property(lambda self: self.__numID)
	available = property(lambda self: self.__checkAvailability())
	dpData = property(lambda self: self.__genDataForDP())
	
	def __init__(self):
		self.__numID = IDGenerator.next()
		self.__stringID = ''
		self.__alerting = False
		self.__callback = lambda : LOG_ERROR('handler for "%s" not installed' % self.__stringID)
		self.__enabled = False
		self.__availableInLobby = False
		self.__availableInLogin = False
		self.__name = ''
		self.__description = ''
		self.__icon = ''
		g_eventsManager.invokeModification += self.__invokeModification
	
	def setData(self, id, name, description, icon, enabled, login, lobby, callback):
		
		if id is not None:
			self.__stringID = id
		
		if enabled is not None:
			self.__enabled = enabled
		
		if lobby is not None:
			self.__availableInLobby = lobby
		
		if login is not None:
			self.__availableInLogin = login
		
		if name is not None:
			self.__name = name
		
		if description is not None:
			self.__description = description
		
		if callback is not None:
			self.__callback = callback
		
		# use '../../' to premature up from "gui/flash" directory
		if icon:
			self.__icon = '../../%s' % icon
		
		g_eventsManager.onListUpdated()
	
	def setAlerting(self, isAlerting):
		self.__alerting = isAlerting
		g_eventsManager.onListUpdated()
		if isAlerting:	
			g_eventsManager.onButtonBlinking() 
		
	def __checkAvailability(self):
		return g_controller.isInLobby and self.__availableInLobby or not g_controller.isInLobby and self.__availableInLogin
		
	def __genDataForDP(self):
		return {
			'id': self.__numID,
			'isEnabled': self.__enabled,
			'isAlerting': self.__alerting,
			'nameLabel': self.__name,
			'descriptionLabel': self.__description,
			'icon': self.__icon
		}

	def __invokeModification(self, modificationID):
		func = self.__callback
		if modificationID == self.__numID and func:
			self.__alerting = False
			try:
				func()
			except:
				LOG_ERROR('Failed invoke modification ID={id} CALLBACK={cb}'.format(id=self.__stringID, cb=self.__callback))
				LOG_CURRENT_EXCEPTION()
