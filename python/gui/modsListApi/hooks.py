
from gui.shared.personality import ServicesLocator
from gui.app_loader.settings import APP_NAME_SPACE
from gui.Scaleform.framework.managers.loaders import SFViewLoadParams
from gui.shared import events, EVENT_BUS_SCOPE, g_eventBus

from ._constants import MODS_LIST_API_BUTTON_ALIAS, MODS_LIST_API_POPOVER_ALIAS
from .events import g_eventsManager
from .utils import getParentWindow

__all__ = ()

def showPopover():
	"""fire load popover view on button click"""
	app = ServicesLocator.appLoader.getApp(APP_NAME_SPACE.SF_LOBBY)
	if not app:
		return
	app.loadView(SFViewLoadParams(MODS_LIST_API_POPOVER_ALIAS, parent=getParentWindow()))

g_eventsManager.showPopover += showPopover

def onAppInitialized(event):
	"""fire load button view on application initialized"""
	if event.ns == APP_NAME_SPACE.SF_LOBBY:
		app = ServicesLocator.appLoader.getApp(event.ns)
		if not app:
			return
		app.loadView(SFViewLoadParams(MODS_LIST_API_BUTTON_ALIAS, parent=getParentWindow()))

g_eventBus.addListener(events.AppLifeCycleEvent.INITIALIZED, onAppInitialized, scope=EVENT_BUS_SCOPE.GLOBAL)
