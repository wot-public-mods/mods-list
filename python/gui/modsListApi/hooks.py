
from gui.shared.personality import ServicesLocator
from gui.app_loader.settings import APP_NAME_SPACE
from gui.Scaleform.daapi.view.lobby.messengerBar.messenger_bar import _CompareBasketListener
from gui.Scaleform.framework.managers.loaders import SFViewLoadParams
from gui.shared import events, EVENT_BUS_SCOPE, g_eventBus

from gui.modsListApi.modslist_constants import MODS_LIST_API_BUTTON_ALIAS, MODS_LIST_API_POPOVER_ALIAS
from gui.modsListApi.utils import override
from gui.modsListApi.events import g_eventsManager

__all__ = ()

def showPopover():
	"""fire load popover view on button click"""
	app = ServicesLocator.appLoader.getApp(APP_NAME_SPACE.SF_LOBBY)
	if not app:
		return
	app.loadView(SFViewLoadParams(MODS_LIST_API_POPOVER_ALIAS), {})

g_eventsManager.showPopover += showPopover


def onAppInitialized(event):
	"""fire load button view on application initialized"""
	if event.ns == APP_NAME_SPACE.SF_LOBBY:
		app = ServicesLocator.appLoader.getApp(event.ns)
		if not app:
			return
		app.loadView(SFViewLoadParams(MODS_LIST_API_BUTTON_ALIAS))


g_eventBus.addListener(events.AppLifeCycleEvent.INITIALIZED, onAppInitialized, scope=EVENT_BUS_SCOPE.GLOBAL)

@override(_CompareBasketListener, "_CompareBasketListener__updateBtnVisibility")
def updateBtnVisibility(baseMethod, baseObject):
	"""try move button on compareCartButton visibility"""
	baseMethod(baseObject)
	cartPopover = baseObject._CompareBasketListener__currentCartPopover
	vehiclesCount = baseObject.comparisonBasket.getVehiclesCount()
	buttonIsVisible = cartPopover is not None or vehiclesCount > 0
	if not baseObject.comparisonBasket.isEnabled() or not buttonIsVisible:
		g_eventsManager.onCompareBasketVisibility()
