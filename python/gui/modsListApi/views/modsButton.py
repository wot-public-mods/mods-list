# SPDX-License-Identifier: MIT
# Copyright (c) 2015-2025 Andrii Andrushchyshyn

from frameworks.wulf import ViewModel
from gui.impl.pub.view_component import ViewComponent
from gui.Scaleform.framework.entities.inject_component_adaptor import InjectComponentAdaptor

from openwg_gameface import ModDynAccessor, gf_mod_inject

from .._constants import MODS_LIST_BUTTON_VIEW
from ..controller import g_controller
from ..data import g_dataProvider
from ..events import g_eventsManager
from ..lang import l10n

class ModsButtonModel(ViewModel):

	def __init__(self, properties=3, commands=1):
		super(ModsButtonModel, self).__init__(properties=properties, commands=commands)

	def _initialize(self):
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
		self._setString(0, value)

	def getTitle(self):
		return self._getString(0)

	def setDescription(self, value):
		self._setString(1, value)

	def getDescription(self):
		return self._getString(1)

	def setAlerts(self, value):
		self._setNumber(2, value)

	def getAlerts(self):
		return self._getNumber(2)

class ModsButtonView(ViewComponent[ModsButtonModel]):

	buttonLayoutID = ModDynAccessor(MODS_LIST_BUTTON_VIEW)

	def __init__(self):
		super(ModsButtonView, self).__init__(
			layoutID=ModsButtonView.buttonLayoutID(),
			model=ModsButtonModel
		)

	@property
	def viewModel(self):
		return super(ModsButtonView, self).getViewModel()

	def _finalize(self):
		g_eventsManager.onListUpdated -= self.__onListUpdated
		super(ModsButtonView, self)._finalize()

	def _onLoading(self, *args, **kwargs):
		super(ModsButtonView, self)._onLoading()
		g_eventsManager.onListUpdated += self.__onListUpdated

	def __onListUpdated(self):
		alertsCount = g_dataProvider.alertsCount
		self.viewModel.setAlerts(alertsCount)

	def _getEvents(self):
		return ((self.viewModel.onButtonClick, self.__onButtonClick),)

	def __onButtonClick(self, isInLobby=True):
		g_controller.isInLobby = isInLobby
		g_eventsManager.showPopover()

class ModsButtonInjectComponent(InjectComponentAdaptor):

	def _makeInjectView(self):
		return ModsButtonView()
