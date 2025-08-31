# SPDX-License-Identifier: MIT
# Copyright (c) 2015-2025 Andrii Andrushchyshyn
"""
This module contains the view for the ModsList API button.
"""

from frameworks.wulf import ViewModel
from gui.impl.pub.view_component import ViewComponent
from gui.Scaleform.framework.entities.inject_component_adaptor import InjectComponentAdaptor

from openwg_gameface import ModDynAccessor, gf_mod_inject

from .._constants import MODS_LIST_BUTTON_VIEW
from ..data import g_dataProvider
from ..events import g_eventsManager
from ..lang import l10n

class ModsButtonModel(ViewModel):
    """
    The view model for the ModsList API button.
    """

    def __init__(self, properties=3, commands=1):
        # type: (int, int) -> None
        super(ModsButtonModel, self).__init__(properties=properties, commands=commands)

    def _initialize(self):
        # type: () -> None
        """
        Initializes the view model.
        """
        super(ModsButtonModel, self)._initialize()

        self._addStringProperty('title', l10n('title'))
        self._addStringProperty('description', l10n('description'))
        self._addNumberProperty('alerts', g_dataProvider.alertsCount)
        self.onButtonClick = self._addCommand('onButtonClick')

        gf_mod_inject(self, MODS_LIST_BUTTON_VIEW, styles=[
            'coui://gui/gameface/mods/poliroid/ModsListButton/ModsListButton.css'
        ], modules=[
            'coui://gui/gameface/mods/poliroid/ModsListButton/ModsListButton.js'
        ])

    def setTitle(self, value):
        # type: (str) -> None
        self._setString(0, value)

    def getTitle(self):
        # type: () -> str
        return self._getString(0)

    def setDescription(self, value):
        # type: (str) -> None
        self._setString(1, value)

    def getDescription(self):
        # type: () -> str
        return self._getString(1)

    def setAlerts(self, value):
        # type: (int) -> None
        self._setNumber(2, value)

    def getAlerts(self):
        # type: () -> int
        return self._getNumber(2)

class ModsButtonView(ViewComponent[ModsButtonModel]):
    """
    The view for the ModsList API button.
    """

    buttonLayoutID = ModDynAccessor(MODS_LIST_BUTTON_VIEW)

    def __init__(self):
        # type: () -> None
        super(ModsButtonView, self).__init__(
            layoutID=ModsButtonView.buttonLayoutID(),
            model=ModsButtonModel
        )

    @property
    def viewModel(self):
        # type: () -> ModsButtonModel
        """
        Gets the view model.
        """
        return super(ModsButtonView, self).getViewModel()

    def _finalize(self):
        # type: () -> None
        """
        Disposes of the view.
        """
        g_eventsManager.onListUpdated -= self.__onListUpdated
        super(ModsButtonView, self)._finalize()

    def _onLoading(self, *args, **kwargs):
        # type: (*str, **str) -> None
        """
        Initializes the view.
        """
        super(ModsButtonView, self)._onLoading()
        g_eventsManager.onListUpdated += self.__onListUpdated

    def __onListUpdated(self):
        # type: () -> None
        """
        Handles the list updated event.
        """
        alertsCount = g_dataProvider.alertsCount
        self.viewModel.setAlerts(alertsCount)

    def _getEvents(self):
        # type: () -> tuple
        """
        Gets the view events.
        """
        return ((self.viewModel.onButtonClick, self.__onButtonClick),)

    def __onButtonClick(self, isInLobby=True):
        # type: (bool) -> None
        """
        Handles the button click event.
        """
        g_eventsManager.showPopover()

class ModsButtonInjectComponent(InjectComponentAdaptor):
    """
    Injects the button view into the lobby footer.
    """

    def _makeInjectView(self):
        # type: () -> ModsButtonView
        """
        Creates the inject view.
        """
        return ModsButtonView()
