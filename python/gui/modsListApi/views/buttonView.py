from gui.Scaleform.framework.entities.View import View

from gui.modsListApi.controller import g_controller
from gui.modsListApi.data import g_dataProvider
from gui.modsListApi.events import g_eventsManager

class ModsListButtonViewMeta(View):

	def onButtonClick(self, isInLobby):
		self._printOverrideError('onButtonClick')

	def as_buttonBlinkingS(self):
		if self._isDAAPIInited():
			return self.flashObject.as_buttonBlinking()

	def as_compareBasketVisibilityS(self):
		if self._isDAAPIInited():
			return self.flashObject.as_compareBasketVisibility()

	def as_setStaticDataS(self, data):
		# :param data: Represented by ModsListStaticDataVO (AS)
		if self._isDAAPIInited():
			return self.flashObject.as_setStaticData(data)

class ModsListButtonView(ModsListButtonViewMeta):

	def _populate(self):
		super(ModsListButtonView, self)._populate()
		g_eventsManager.onCompareBasketVisibility += self.__onCompareBasketVisibility
		g_eventsManager.onButtonBlinking += self.__onButtonBlinking
		self.as_setStaticDataS(g_dataProvider.staticData)

	def _dispose(self):
		g_eventsManager.onButtonBlinking -= self.__onButtonBlinking
		g_eventsManager.onCompareBasketVisibility -= self.__onCompareBasketVisibility
		super(ModsListButtonView, self)._dispose()

	def onButtonClick(self, isInLobby):
		g_controller.isInLobby = isInLobby
		g_eventsManager.showPopover()

	def __onButtonBlinking(self):
		self.as_buttonBlinkingS()

	def __onCompareBasketVisibility(self):
		self.as_compareBasketVisibilityS()

	def onFocusIn(self, alias):
		if self._isDAAPIInited():
			return False
