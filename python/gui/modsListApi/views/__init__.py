# SPDX-License-Identifier: MIT
# Copyright (c) 2015-2025 Andrii Andrushchyshyn
"""
This package contains the view definitions for the ModsList API.
"""

from frameworks.wulf import WindowLayer
from gui.Scaleform.framework import ScopeTemplates
from gui.Scaleform.framework import (g_entitiesFactories, ComponentSettings, 
                                     GroupedViewSettings, ViewSettings, ScopeTemplates)
from gui.Scaleform.framework.entities.View import View

from .._constants import MODS_LIST_BUTTON_POPOVER, MODS_LIST_BUTTON_VIEW, MODS_LIST_BUTTON_INJECT
from .modsPopover import ModsListPopoverView
from .modsButton import ModsButtonInjectComponent

g_entitiesFactories.addSettings(
    GroupedViewSettings(
        MODS_LIST_BUTTON_POPOVER,
        ModsListPopoverView,
        'modsListPopover.swf',
        WindowLayer.TOP_WINDOW,
        MODS_LIST_BUTTON_POPOVER,
        MODS_LIST_BUTTON_POPOVER,
        ScopeTemplates.WINDOW_VIEWED_MULTISCOPE
    )
)
g_entitiesFactories.addSettings(
    ViewSettings(
        MODS_LIST_BUTTON_VIEW,
        View,
        'modsListButton.swf',
        WindowLayer.WINDOW,
        None,
        ScopeTemplates.GLOBAL_SCOPE
    )
)
g_entitiesFactories.addSettings(
    ComponentSettings(
        MODS_LIST_BUTTON_INJECT,
        ModsButtonInjectComponent,
        ScopeTemplates.DEFAULT_SCOPE
    )
)
