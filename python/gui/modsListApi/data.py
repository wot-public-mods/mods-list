# SPDX-License-Identifier: MIT
# Copyright (c) 2015-2025 Andrii Andrushchyshyn

import BigWorld
import ResMgr

from ids_generators import SequenceIDGenerator

from ._constants import DEFAULT_MOD_ICON
from .controller import g_controller
from .lang import l10n
from .events import g_eventsManager
from .utils import format_description, get_logger

__all__ = ('g_dataProvider', 'ModificationItem', )

logger = get_logger(__name__)

class _DataProvider(object):
    """
    Provides data for the ModsList API views.
    """

    @property
    def modsData(self):
        # type: () -> dict
        """
        Generates and returns data for all available modifications.
        The return value is represented by ModsListStaticDataVO in ActionScript.
        """
        return self._generateModsData()

    @property
    def staticData(self):
        # type: () -> dict
        """
        Generates and returns static data for the ModsList views.
        The return value is represented by ModsListModsVO in ActionScript.
        """
        return self._generateStaticData()

    @property
    def alertsCount(self):
        # type: () -> int
        """
        Calculates and returns the number of modifications with alerts.
        """
        return sum(int(item.alerting) for item in g_controller.modifications.values())

    @property
    def modsCount(self):
        # type: () -> int
        """
        Calculates and returns the number of available modifications.
        """
        return len(self._generateModsData().get('mods', []))

    @staticmethod
    def _generateModsData():
        # type: () -> dict
        """
        Generates a dictionary of modifications data.
        """
        result = list()
        for item in g_controller.modifications.values():
            if item.available:
                result.append(item.dpData)
        if result:
            result = sorted(result, key=lambda item: item.get('id'))
        return {'mods' : result}

    @staticmethod
    def _generateStaticData():
        # type: () -> dict
        """
        Generates a dictionary of static data.
        """
        result = {
            'titleLabel': l10n('title'),
            'tooltipLabel': '{HEADER}%s{/HEADER}{BODY}%s{/BODY}' % (l10n('title'), l10n('description')),
            'closeButtonVisible': True
        }
        return result

g_dataProvider = _DataProvider()

IDGenerator = SequenceIDGenerator()

class ModificationItem(object):
    """
    Represents a single modification item.
    """

    def __init__(self):
        self.__numID = IDGenerator.next()
        self.__stringID = ''
        self.__alerting = False
        self.__callback = lambda: logger.warning('handler for "%s" not installed' % self.__stringID)
        self.__enabled = False
        self.__availableInLobby = False
        self.__availableInLogin = False
        self.__name = ''
        self.__description = ''
        self.__icon = ''
        g_eventsManager.invokeModification += self.__invokeModification

    @property
    def uniqueID(self):
        # type: () -> int
        """
        The unique numeric ID of the modification.
        """
        return self.__numID

    @property
    def available(self):
        # type: () -> bool
        """
        Checks if the modification is currently available.
        """
        return self.__availabilityCheck()

    @property
    def dpData(self):
        # type: () -> dict
        """
        Generates data for the data provider.
        """
        return self.__genDataForDP()

    @property
    def alerting(self):
        return self.__alerting

    def setData(self, id, name, description, icon, enabled, login, lobby, callback):
        # type: (str, str, str, str, bool, bool, bool, callable) -> None
        """
        Sets the data for the modification item.
        """
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
            self.__description = format_description(description)
        if callback is not None:
            self.__callback = callback
        if icon:
            self.__icon = self.__fixModIcon(icon)
        g_eventsManager.onListUpdated()

    def __fixModIcon(self, path):
        # type: (str) -> str
        """
        Validates and fixes the modification icon path.
        """
        if not path or not ResMgr.isFile(path):
            return DEFAULT_MOD_ICON
        # use '../../' to premature up from "gui/flash" directory
        return '../../%s' % path

    def setAlerting(self, isAlerting):
        # type: (bool) -> None
        """
        Sets the alerting state for the modification.
        """
        self.__alerting = isAlerting
        g_eventsManager.onListUpdated()

    def __availabilityCheck(self):
        # type: () -> bool
        """
        Checks if the modification should be visible.
        """
        result = False
        if g_controller.isInLobby and self.__availableInLobby:
            result = True
        if not g_controller.isInLobby and self.__availableInLogin:
            result = True
        return result

    def __genDataForDP(self):
        # type: () -> dict
        """
        Generates a dictionary of data for the data provider.
        """
        result = {
            'id': self.__numID,
            'isEnabled': self.__enabled,
            'isAlerting': self.__alerting,
            'nameLabel': self.__name,
            'tooltipLabel': self.__description,
            'icon': self.__icon
        }
        return result

    def __invokeModification(self, modificationID):
        # type: (int) -> None
        """
        Invokes the modification's callback.
        """
        if modificationID != self.__numID:
            return
        if callable(self.__callback):
            self.__alerting = False

            # Call the handler on the next frame to:
            # - Fix menu freezes on handler call.
            # - Fix stuck trace if the handler causes an error.
            BigWorld.callback(0, self.__callback)
