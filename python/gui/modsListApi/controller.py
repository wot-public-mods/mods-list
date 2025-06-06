﻿# SPDX-License-Identifier: MIT
# Copyright (c) 2015-2025 Andrii Andrushchyshyn

from .events import g_eventsManager
from .utils import getLogger

__all__ = ('g_controller', )

logger = getLogger(__name__)

class ApiLogicController(object):

	@property
	def modifications(self):
		return self.__modifications

	@property
	def isInLobby(self):
		return self.__isInLobby

	@isInLobby.setter
	def isInLobby(self, isInLobby):
		self.__isInLobby = isInLobby

	@property
	def isModsExist(self):
		return len(self.__modifications)

	def __init__(self):
		self.__modifications = dict()
		self.__isInLobby = False

	def addModification(self, id, name=None, description=None, icon=None, enabled=None,
						login=None, lobby=None, callback=None):
		# use updateModification instead addModification if modification already exist
		if id in self.__modifications.keys():
			return self.updateModification(id, name, description, icon, enabled, login, lobby, callback)

		if name is None or description is None or enabled is None or login is None or lobby is None or callback is None:
			return logger.error('method @addModification required mandatory parameters [name, description, ' + \
						'enabled, login, lobby, callback]')

		from .data import ModificationItem
		modification = self.__modifications[id] = ModificationItem()
		modification.setData(id, name, description, icon, enabled, login, lobby, callback)

	def updateModification(self, id, name=None, description=None, icon=None, enabled=None,
						login=None, lobby=None, callback=None):

		if id not in self.__modifications.keys():
			return logger.error('method @updateModification required ModificationItem instance, use ' + \
						'@addModification instead updateModification')

		modification = self.__modifications[id]
		modification.setData(id, name, description, icon, enabled, login, lobby, callback)

	def removeModification(self, id):
		if id not in self.__modifications.keys():
			return logger.error('method @removeModification required ModificationItem instance')
		del self.__modifications[id]
		g_eventsManager.onListUpdated()

	def alertModification(self, id):
		if id not in self.__modifications.keys():
			return logger.error('method @alertModification required ModificationItem instance, check ' + \
							'the id argument')
		modification = self.__modifications[id]
		modification.setAlerting(True)

	def clearModificationAlert(self, id):
		if id not in self.__modifications.keys():
			return logger.error('method @clearModificationAlert required ModificationItem instance, ' + \
							'check the id argument')
		modification = self.__modifications[id]
		modification.setAlerting(False)

g_controller = ApiLogicController()
