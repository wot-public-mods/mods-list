# SPDX-License-Identifier: MIT
# Copyright (c) 2015-2026 Andrii Andrushchyshyn

from .events import g_eventsManager
from .utils import get_logger

logger = get_logger(__name__)

class ApiLogicController(object):
    """
    The main controller for the ModsList API.
    Manages all modifications and their states.
    """

    def __init__(self):
        # type: () -> None
        self.__modifications = dict() # type list[ModificationItem]
        self.__isInLobby = False

    @property
    def modifications(self):
        # type: () -> dict
        """
        A dictionary of all registered modifications.
        """
        return self.__modifications

    @property
    def isInLobby(self):
        # type: () -> bool
        """
        A boolean indicating if the player is currently in the lobby.
        """
        return self.__isInLobby

    @isInLobby.setter
    def isInLobby(self, isInLobby):
        # type: (bool) -> None
        """
        Sets the lobby status.
        """
        if isInLobby != self.__isInLobby:
            self.__isInLobby = isInLobby
            g_eventsManager.onListUpdated()

    @property
    def isModsExist(self):
        # type: () -> bool
        """
        A boolean indicating if any modifications are registered.
        """
        return len(self.__modifications)

    def addModification(self, id, name=None, description=None, icon=None, enabled=None,
                        login=None, lobby=None, callback=None):
        # type: (str, str, str, str, bool, bool, bool, callable) -> None
        """
        Adds a new modification or updates an existing one.
        """
        # Use updateModification instead of addModification if the modification already exists.
        if id in self.__modifications.keys():
            return self.updateModification(id, name, description, icon, enabled, login, lobby, callback)

        if name is None or description is None or enabled is None or login is None or lobby is None or callback is None:
            logger.error('Method @addModification requires mandatory parameters [name, description, '
                         'enabled, login, lobby, callback]')
            return

        from .data import ModificationItem
        modification = self.__modifications[id] = ModificationItem()
        modification.setData(id, name, description, icon, enabled, login, lobby, callback)

    def updateModification(self, id, name=None, description=None, icon=None, enabled=None,
                           login=None, lobby=None, callback=None):
        # type: (str, str, str, str, bool, bool, bool, callable) -> None
        """
        Updates an existing modification.
        """
        if id not in self.__modifications:
            logger.error('Method @updateModification requires a ModificationItem instance. '
                         'Use @addModification instead.')
            return

        modification = self.__modifications[id]
        modification.setData(id, name, description, icon, enabled, login, lobby, callback)

    def removeModification(self, id):
        # type: (str) -> None
        """
        Removes a modification.
        """
        if id not in self.__modifications:
            logger.error('Method @removeModification requires a ModificationItem instance.')
            return
        del self.__modifications[id]
        g_eventsManager.onListUpdated()

    def alertModification(self, id):
        # type: (str) -> None
        """
        Sets the alerting state for a modification.
        """
        if id not in self.__modifications:
            logger.error('Method @alertModification requires a ModificationItem instance. Check the id argument.')
            return

        modification = self.__modifications[id]
        modification.setAlerting(True)

    def clearModificationAlert(self, id):
        # type: (str) -> None
        """
        Clears the alerting state for a modification.
        """
        if id not in self.__modifications:
            logger.error('Method @clearModificationAlert requires a ModificationItem instance. Check the id argument.')
            return

        modification = self.__modifications[id]
        modification.setAlerting(False)

g_controller = ApiLogicController()
