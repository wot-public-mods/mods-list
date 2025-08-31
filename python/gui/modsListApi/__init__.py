# SPDX-License-Identifier: MIT
# Copyright (c) 2015-2025 Andrii Andrushchyshyn

__version__ = "1.7.0"

from .controller import g_controller
from .hooks import *
from .views import *

__all__ = ('g_modsListApi', )

class ModsListApiRepresentation(object):
    """
    ModsListApiRepresentation provides a static interface to the mods list controller.

    This class defines the public API for adding, updating, removing, and alerting on modifications.
    """

    @staticmethod
    def addModification(*args, **kwargs):
        # type: (*str, **str) -> None
        """
        Adds a new modification to the list.

        :param id: Unique modification ID - required
        :param name: Modification name - required
        :param description: Modification hint (mouse over) - required
        :param icon: Modification icon (path from res_mods/<game_version>/) - required
        :param enabled: Is modification enabled (can be clicked) - required
        :param login: Show modification on Login Window - required
        :param lobby: Show modification in Lobby - required
        :param callback: Called on modification click - required
        """
        g_controller.addModification(*args, **kwargs)

    @staticmethod
    def updateModification(*args, **kwargs):
        # type: (*str, **str) -> None
        """
        Updates an existing modification.

        :param id: Unique modification ID - required
        :param name: Modification name - optional
        :param description: Modification hint (mouse over) - optional
        :param icon: Modification icon (path from res_mods/<game_version>/) - optional
        :param enabled: Is modification enabled (can be clicked) - optional
        :param login: Show modification on Login Window - optional
        :param lobby: Show modification in Lobby - optional
        :param callback: Called on modification click - optional
        """
        g_controller.updateModification(*args, **kwargs)

    @staticmethod
    def removeModification(*args, **kwargs):
        # type: (*str, **str) -> None
        """
        Removes a modification from the list.

        :param id: Unique modification ID - required
        """
        g_controller.removeModification(*args, **kwargs)

    @staticmethod
    def alertModification(*args, **kwargs):
        # type: (*str, **str) -> None
        """
        Highlights a modification in the list.

        :param id: Unique modification ID - required
        """
        g_controller.alertModification(*args, **kwargs)

    @staticmethod
    def clearModificationAlert(*args, **kwargs):
        # type: (*str, **str) -> None
        """
        Clears the alert state for a modification.

        :param id: Unique modification ID - required
        """
        g_controller.clearModificationAlert(*args, **kwargs)

g_modsListApi = ModsListApiRepresentation()
