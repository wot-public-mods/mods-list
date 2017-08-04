
import BigWorld
from gui.app_loader.loader import g_appLoader
from gui.app_loader.settings import APP_NAME_SPACE
from gui.Scaleform.daapi.view.lobby.messengerBar.messenger_bar import _CompareBasketListener
from gui.Scaleform.framework.managers.loaders import ViewLoadParams
from gui.shared import events, EVENT_BUS_SCOPE, g_eventBus

from gui.modsListApi.modslist_constants import MODS_LIST_API_BUTTON_ALIAS, MODS_LIST_API_POPOVER_ALIAS
from gui.modsListApi.utils import override
from gui.modsListApi.events import g_eventsManager

__all__ = ()

def showPopover():
	"""fire load popover view on button click"""
	app = g_appLoader.getApp(APP_NAME_SPACE.SF_LOBBY)
	if not app:
		return
	app.loadView(ViewLoadParams(MODS_LIST_API_POPOVER_ALIAS, MODS_LIST_API_POPOVER_ALIAS), {})

g_eventsManager.showPopover += showPopover


def onAppInitialized(event):
	"""fire load button view on application initialized"""
	if event.ns == APP_NAME_SPACE.SF_LOBBY:
		app = g_appLoader.getApp(event.ns)
		if not app:
			return
		BigWorld.callback(0.0, lambda: app.loadView(ViewLoadParams(MODS_LIST_API_BUTTON_ALIAS, MODS_LIST_API_BUTTON_ALIAS), {}))
		

g_eventBus.addListener(events.AppLifeCycleEvent.INITIALIZED, onAppInitialized, scope=EVENT_BUS_SCOPE.GLOBAL)

@override(_CompareBasketListener, "_CompareBasketListener__updateBtnVisibility")
def updateBtnVisibility(baseMethod, baseObject):
	"""try move button on compareCartButton visibility"""
	baseMethod(baseObject)
	isButtonVisible = baseObject._CompareBasketListener__currentCartPopover is not None or baseObject.comparisonBasket.getVehiclesCount() > 0
	if not baseObject.comparisonBasket.isEnabled() or not isButtonVisible:
		g_eventsManager.onCompareBasketVisibility()
