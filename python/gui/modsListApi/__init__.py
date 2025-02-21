# SPDX-License-Identifier: MIT
# Copyright (c) 2015-2025 Andrii Andrushchyshyn

__version__ = "1.6.01"

from .controller import g_controller
from .hooks import *
from .views import *

__all__ = ('g_modsListApi', )

class ModsListApiRepresentation(object):

	@staticmethod
	def addModification(*args, **kwargs):
		g_controller.addModification(*args, **kwargs)

	@staticmethod
	def updateModification(*args, **kwargs):
		g_controller.updateModification(*args, **kwargs)

	@staticmethod
	def removeModification(*args, **kwargs):
		g_controller.removeModification(*args, **kwargs)

	@staticmethod
	def alertModification(*args, **kwargs):
		g_controller.alertModification(*args, **kwargs)

	@staticmethod
	def clearModificationAlert(*args, **kwargs):
		g_controller.clearModificationAlert(*args, **kwargs)

g_modsListApi = ModsListApiRepresentation()

"""
ModsListApi

	method addModification
		:param id: Uniq modification ID - required
		:param name: Modification name - required
		:param description: Modification hint (mouse over) - required
		:param icon: Modification icon (path from res_mods/<game_vaersion>/) - required
		:param enabled: Is modification enabled (can be clicked) - required
		:param login: Show modification on Login Window - required
		:param lobby: Show modification in Lobby - required
		:param callback: Called on modification click - required

	method updateModification
		:param id: Uniq modification ID - required
		:param name: Modification name - not necessary
		:param description: Modification hint (mouse over) - not necessary
		:param icon: Modification icon (path from res_mods/<game_vaersion>/) - not necessary
		:param enabled: Is modification enabled (can be clicked) - not necessary
		:param login: Show modification on Login Window - not necessary
		:param lobby: Show modification in Lobby - not necessary
		:param callback: Called on modification click - not necessary

	method removeModification
		:param id: Uniq modification ID - required

	method alertModification
		:param id: Uniq modification ID - required

	method clearModificationAlert
		:param id: Uniq modification ID - required
"""
