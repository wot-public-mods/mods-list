
from gui.Scaleform.framework import g_entitiesFactories, ViewSettings, GroupedViewSettings, ViewTypes, ScopeTemplates

from gui.modsListApi._constants import MODS_LIST_API_BUTTON_ALIAS, MODS_LIST_API_POPOVER_ALIAS
from gui.modsListApi.views.buttonView import ModsListButtonView
from gui.modsListApi.views.popoverView import ModsListPopoverView

def getViewSettings():
	buttonSettings = ViewSettings(MODS_LIST_API_BUTTON_ALIAS, ModsListButtonView, 'modsListButton.swf',
								ViewTypes.WINDOW, None, ScopeTemplates.GLOBAL_SCOPE)
	popoverSettings = GroupedViewSettings(MODS_LIST_API_POPOVER_ALIAS, ModsListPopoverView, 'modsListPopover.swf',
										ViewTypes.WINDOW, MODS_LIST_API_POPOVER_ALIAS, MODS_LIST_API_POPOVER_ALIAS,
										ScopeTemplates.DEFAULT_SCOPE)
	return buttonSettings, popoverSettings

for item in getViewSettings():
	g_entitiesFactories.addSettings(item)
