# SPDX-License-Identifier: MIT
# Copyright (c) 2015-2025 Andrii Andrushchyshyn

from frameworks.wulf import WindowLayer
from gui.app_loader.settings import APP_NAME_SPACE
from gui.impl.lobby.page.lobby_footer import LobbyFooter
from gui.Scaleform.framework.managers.containers import POP_UP_CRITERIA
from gui.Scaleform.framework.managers.loaders import SFViewLoadParams
from gui.shared import events, EVENT_BUS_SCOPE, g_eventBus
from gui.shared.personality import ServicesLocator

from ._constants import MODS_LIST_BUTTON_POPOVER, MODS_LIST_BUTTON_VIEW
from .views.modsButton import ModsButtonView
from .utils import getParentWindow, override
from .controller import g_controller
from .events import g_eventsManager

__all__ = ()

def showPopover():
	"""fire load popover view on button click"""
	app = ServicesLocator.appLoader.getApp(APP_NAME_SPACE.SF_LOBBY)
	if not app:
		return
	app.loadView(SFViewLoadParams(MODS_LIST_BUTTON_POPOVER, parent=getParentWindow()))

g_eventsManager.showPopover += showPopover

def showButton():
	"""fire load button view on application initialized"""
	app = ServicesLocator.appLoader.getApp(APP_NAME_SPACE.SF_LOBBY)
	if not app:
		return
	app.loadView(SFViewLoadParams(MODS_LIST_BUTTON_VIEW, parent=getParentWindow()))

def onAppInitialized(event):
	if event.ns != APP_NAME_SPACE.SF_LOBBY:
		return
	showButton()

g_eventBus.addListener(events.AppLifeCycleEvent.INITIALIZED, onAppInitialized, scope=EVENT_BUS_SCOPE.GLOBAL)

def onListUpdated():
	# get lobby application
	app = ServicesLocator.appLoader.getApp(APP_NAME_SPACE.SF_LOBBY)
	if not app:
		return
	# if manager not exist skip
	if not app.containerManager:
		return
	# get view target container
	container = app.containerManager.getContainer(WindowLayer.WINDOW)
	if not container:
		return
	# if target view already exist, skip
	view = container.getView(criteria={POP_UP_CRITERIA.VIEW_ALIAS: MODS_LIST_BUTTON_VIEW})
	# try load button view
	if g_controller.isModsExist and not view:
		return showButton()

g_eventsManager.onListUpdated += onListUpdated

@override(LobbyFooter, '_initChildren')
def hooked_initChildren(baseMethod, baseObject):
	baseMethod(baseObject)
	baseObject.setChildView(
		ModsButtonView.buttonLayoutID(),
		ModsButtonView()
	)
