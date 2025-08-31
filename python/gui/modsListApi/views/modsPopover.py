# SPDX-License-Identifier: MIT
# Copyright (c) 2015-2025 Andrii Andrushchyshyn
"""
This module contains the popover view for the ModsList API.
"""

from gui.Scaleform.framework.entities.abstract.AbstractPopOverView import \
    AbstractPopOverView

from ..data import g_dataProvider
from ..events import g_eventsManager

class ModsListPopoverViewMeta(AbstractPopOverView):
    """
    Meta class for the ModsListPopoverView.
    """

    def getModsList(self):
        # type: () -> None
        """
        Gets the list of mods from the client.
        """
        self._printOverrideError('getModsList')

    def invokeMod(self, modification_id):
        # type: (int) -> None
        """
        Invokes a mod by its ID.
        """
        self._printOverrideError('invokeMod')

    def as_setModsDataS(self, data):
        # type: (dict) -> None
        """
        Sets the mods data for the popover.
        :param data: Represented by ModsListModsVO (AS)
        """
        if self._isDAAPIInited():
            return self.flashObject.as_setModsData(data)

    def as_setStaticDataS(self, data):
        # type: (dict) -> None
        """
        Sets the static data for the popover.
        :param data: Represented by ModsListStaticDataVO (AS)
        """
        if self._isDAAPIInited():
            return self.flashObject.as_setStaticData(data)

class ModsListPopoverView(ModsListPopoverViewMeta):
    """
    The popover view for the ModsList API.
    """

    def _populate(self):
        # type: () -> None
        """
        Initializes the view.
        """
        super(ModsListPopoverView, self)._populate()
        g_eventsManager.onListUpdated += self.__collectModsData
        self.as_setStaticDataS(g_dataProvider.staticData)
        self.__collectModsData()

    def _dispose(self):
        # type: () -> None
        """
        Disposes of the view.
        """
        g_eventsManager.onListUpdated -= self.__collectModsData
        super(ModsListPopoverView, self)._dispose()

    def __collectModsData(self):
        # type: () -> None
        """
        Collects and sets the mods data.
        """
        self.as_setModsDataS(g_dataProvider.modsData)

    def getModsList(self):
        # type: () -> None
        """
        Gets the list of mods from the client.
        """
        self.__collectModsData()

    def invokeModification(self, modification_id):
        # type: (int) -> None
        """
        Invokes a mod by its ID.
        """
        g_eventsManager.invokeModification(modification_id)
