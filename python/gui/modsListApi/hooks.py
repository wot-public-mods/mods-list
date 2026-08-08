# SPDX-License-Identifier: MIT
# Copyright (c) 2015-2026 Andrii Andrushchyshyn

import importlib
import typing

from frameworks.wulf import WindowLayer
from gui.app_loader.settings import APP_NAME_SPACE
from gui.Scaleform.daapi.settings.views import VIEW_ALIAS
from gui.Scaleform.framework.managers.containers import POP_UP_CRITERIA
from gui.Scaleform.framework.managers.loaders import SFViewLoadParams
from gui.shared import events, EVENT_BUS_SCOPE, g_eventBus
from gui.shared.personality import ServicesLocator

from ._constants import MODS_LIST_BUTTON_POPOVER, MODS_LIST_BUTTON_VIEW
from .views.modsButton import ModsButtonView
from .utils import get_parent_window, override, get_logger
from .controller import g_controller
from .events import g_eventsManager

if typing.TYPE_CHECKING:
    from gui.impl.lobby.page.lobby_footer import LobbyFooter

logger = get_logger(__name__)

from openwg_gameface import manager as resmap

def show_popover():
    # type: () -> None
    """
    Loads the popover view when the button is clicked.
    """
    app = ServicesLocator.appLoader.getApp(APP_NAME_SPACE.SF_LOBBY)
    if not app:
        return
    app.loadView(SFViewLoadParams(MODS_LIST_BUTTON_POPOVER, parent=get_parent_window()))

g_eventsManager.showPopover += show_popover

def add_button():
    # type: () -> None
    """
    Loads the button view if UiResourceManager is validated.
    """
    if not resmap.isResMapValidated:
        return
    app = ServicesLocator.appLoader.getApp(APP_NAME_SPACE.SF_LOBBY)
    if not app:
        return
    app.loadView(SFViewLoadParams(MODS_LIST_BUTTON_VIEW, parent=get_parent_window()))

def on_app_initialized(event):
    # type: (events.AppLifeCycleEvent) -> None
    """
    Handles the application initialization event.
    """
    if event.ns != APP_NAME_SPACE.SF_LOBBY:
        return
    add_button()

g_eventBus.addListener(events.AppLifeCycleEvent.INITIALIZED, on_app_initialized, scope=EVENT_BUS_SCOPE.GLOBAL)

def on_view_loaded(event):
    # type: (events.ViewEventType) -> None
    """
    Handles the application view loading to switch lobby/login state.
    """
    if event.alias == VIEW_ALIAS.LOGIN:
        g_controller.isInLobby = False
    elif event.alias in (VIEW_ALIAS.LOBBY, VIEW_ALIAS.LOBBY_HANGAR, VIEW_ALIAS.LEGACY_LOBBY_HANGAR, ):
        g_controller.isInLobby = True
g_eventBus.addListener(events.ViewEventType.LOAD_VIEW, on_view_loaded, scope=EVENT_BUS_SCOPE.LOBBY)

def onListUpdated():
    # type: () -> None
    """
    Handles the list updated event.
    """
    # Get the lobby application.
    app = ServicesLocator.appLoader.getApp(APP_NAME_SPACE.SF_LOBBY)
    if not app:
        return
    # If the manager does not exist, skip.
    if not app.containerManager:
        return
    # Get the view target container.
    container = app.containerManager.getContainer(WindowLayer.WINDOW)
    if not container:
        return
    # If the target view already exists, skip.
    view = container.getView(criteria={POP_UP_CRITERIA.VIEW_ALIAS: MODS_LIST_BUTTON_VIEW})
    # Try to load the button view.
    if g_controller.isModsExist and not view:
        return add_button()

g_eventsManager.onListUpdated += onListUpdated

def button_inject_hook(baseMethod, baseObject):
    # type: (object, LobbyFooter) -> None
    """
    Injects the button view into the lobby footer.
    """
    baseMethod(baseObject)
    if not resmap.isResMapValidated:
        return
    baseObject.setChildView(
        ModsButtonView.viewLayoutID(),
        ModsButtonView()
    )

def button_inject(path, name):
    try:
        module = importlib.import_module(path)
        cls = getattr(module, name, None)
        if cls is None:
            logger.error('Class not found: %s.%s', path, name)
            return
        override(cls, '_initChildren')(button_inject_hook)
    except ImportError:
        logger.warning('Module not loaded yet: %s', path)
    except Exception:
        logger.exception('Failed to inject %s.%s', path, name)

for path, name in (
    ('gui.impl.lobby.page.lobby_footer', 'LobbyFooter'),
    ('comp7.gui.impl.lobby.page.lobby_footer', 'Comp7LobbyFooter'),
    ('comp7_light.gui.impl.lobby.page.lobby_footer', 'Comp7LightLobbyFooter'),
    ('last_stand.gui.impl.lobby.page.ls_lobby_footer', 'LSLobbyFooter'),
    ('battle_royale.gui.Scaleform.daapi.view.lobby.footer.battle_royale_lobby_footer', 'BattleRoyaleLobbyFooter')
): button_inject(path, name)

def onResMapValidated():
    # type: () -> None
    """
    Handles UiResourceManager validation.
    """
    return add_button()

resmap.onResMapValidated += onResMapValidated
