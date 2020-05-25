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

	method alertModification
		:param id: Uniq modification ID - required

	method clearModificationAlert
		:param id: Uniq modification ID - required
"""

__author__ = "Andruschyshyn Andrey"
__copyright__ = "Copyright 2020, poliroid"
__credits__ = ["Andruschyshyn Andrey"]
__license__ = "CC BY-NC-SA 4.0"
__version__ = "1.3.2"
__maintainer__ = "Andruschyshyn Andrey"
__email__ = "p0lir0id@yandex.ru"
__status__ = "Production"

from gui.modsListApi.controller import g_controller
from gui.modsListApi.hooks import *
from gui.modsListApi.views import *

__all__ = ('g_modsListApi', )

class ModsListApiRepresentation(object):

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
