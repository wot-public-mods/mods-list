
from gui.Scaleform.framework import g_entitiesFactories, ViewSettings, GroupedViewSettings, ViewTypes, ScopeTemplates

from gui.modsListApi.modslist_constants import MODS_LIST_API_BUTTON_ALIAS, MODS_LIST_API_POPOVER_ALIAS
from gui.modsListApi.views.buttonView import ModsListButtonView
from gui.modsListApi.views.popoverView import ModsListPopoverView

def getViewSettings():
	return (ViewSettings(MODS_LIST_API_BUTTON_ALIAS, ModsListButtonView, 'modsListButton.swf', ViewTypes.WINDOW, None, ScopeTemplates.GLOBAL_SCOPE) ,
			GroupedViewSettings(MODS_LIST_API_POPOVER_ALIAS, ModsListPopoverView, 'modsListPopover.swf', ViewTypes.WINDOW, MODS_LIST_API_POPOVER_ALIAS, MODS_LIST_API_POPOVER_ALIAS, ScopeTemplates.DEFAULT_SCOPE) )

for item in getViewSettings():
	g_entitiesFactories.addSettings(item)