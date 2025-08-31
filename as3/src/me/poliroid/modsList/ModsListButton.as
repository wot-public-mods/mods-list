// SPDX-License-Identifier: MIT
// Copyright (c) 2015-2025 Andrii Andrushchyshyn

package me.poliroid.modsList 
{

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;

	import scaleform.clik.constants.InvalidationType;
	import scaleform.clik.events.ButtonEvent;
	import scaleform.clik.utils.Constraints;

	import net.wg.app.iml.base.StageResizeEvent;
	import net.wg.infrastructure.managers.impl.ContainerManagerBase;
	import net.wg.gui.components.containers.MainViewContainer;
	import net.wg.infrastructure.events.LifeCycleEvent;
	import net.wg.infrastructure.interfaces.ISimpleManagedContainer;
	import net.wg.infrastructure.interfaces.IManagedContent;
	import net.wg.infrastructure.interfaces.IDisplayObject;

	import net.wg.data.Aliases;
	import net.wg.data.constants.generated.LAYER_NAMES;
	import net.wg.gui.lobby.messengerBar.MessengerBar;
	import net.wg.infrastructure.interfaces.IView;
	import net.wg.infrastructure.events.LoaderEvent;
	import net.wg.gui.lobby.LobbyPage;
	import net.wg.gui.login.impl.LoginPage;

	import me.poliroid.modsList.controls.ModsListBlinkingButton;
	import me.poliroid.modsList.data.ModsListStaticDataVO;
	import me.poliroid.modsList.interfaces.IModsListButtonMeta;
	import me.poliroid.modsList.interfaces.impl.ModsListButtonMeta;

	public class ModsListButton extends ModsListButtonMeta implements IModsListButtonMeta 
	{

		private static const BUTTON_LOGIN_BOTTOM_MARGIN:int = 40;

		private static const BUTTON_LOGIN_RIGHT_MARGIN:int = 80;

		private static const BUTTON_LOBBY_TOP_MARGIN:int = 9;

		private static const BUTTON_LOBBY_GAP:int = 5;

		private static const POPOVER_ALIAS:String = 'ModsListApiPopover';

		private static const INVALIDATE_ALIASES:Array = [Aliases.LOGIN, Aliases.LOBBY, Aliases.LOBBY_HANGAR, Aliases.LOBBY_TRAINING_ROOM];

		public var modsButton:ModsListBlinkingButton = null;

		public var messengerBar:MessengerBar = null;

		public var isInLobby:Boolean = false;

		private var _buttonLinkage:String = 'WoTModsListBlinkingButtonUI';

		private var _tooltip:String = '';

		private var _blinking:Boolean = false;

		override protected function configUI() : void 
		{
			super.configUI();

			// process already loaded views
			var viewContainer:MainViewContainer = _getContainer(LAYER_NAMES.VIEWS) as MainViewContainer;
			if (viewContainer != null)
			{
				var num:int = viewContainer.numChildren;
				for (var idx:int = 0; idx < num; ++idx)
				{
					var view:IView = viewContainer.getChildAt(idx) as IView;
					if (view != null)
					{
						processView(view);
					}
				}
				var topmostView:IManagedContent = viewContainer.getTopmostView();
				if (topmostView != null)
				{
					viewContainer.setFocusedView(topmostView);
				}
			}

			// subscribe to stage resize
			App.instance.stage.addEventListener(StageResizeEvent.STAGE_RESIZE, onStageResize);

			// subscribe to container manager loader
			(App.containerMgr as ContainerManagerBase).loader.addEventListener(LoaderEvent.VIEW_LOADED, onViewLoaded, false, 0, true);
		}

		override protected function onDispose() : void 
		{
			buttonDestroy();

			// remove links
			messengerBar = null;

			// unsubscribe from container manager loader
			(App.containerMgr as ContainerManagerBase).loader.removeEventListener(LoaderEvent.VIEW_LOADED, onViewLoaded);

			// unsubscribe from stage resize
			App.instance.stage.removeEventListener(StageResizeEvent.STAGE_RESIZE, onStageResize);

			super.onDispose();
		}

		override protected function draw() : void 
		{
			super.draw();

			if(isInvalid(InvalidationType.SIZE) && modsButton)
			{
				if (isInLobby)
				{
					if (messengerBar)
					{
						fixRightSideBtnsOrder();
						messengerBar['updateChannelCarouselWidth']();
					}
				}
				else
				{
					modsButton.x = App.appWidth - BUTTON_LOGIN_RIGHT_MARGIN
					modsButton.y = App.appHeight - BUTTON_LOGIN_BOTTOM_MARGIN;
				}
			}

			if(isInvalid(InvalidationType.DATA) && modsButton)
			{
				modsButton.tooltip = _tooltip;
				modsButton.blinking = _blinking;
			}

		}

		override protected function nextFrameAfterPopulateHandler() : void 
		{
			super.nextFrameAfterPopulateHandler();
			addAsChildToApp();
		}

		// this needs for valid Focus and Position in Login Window 
		public function addAsChildToApp() : void 
		{
			if (parent != App.instance)
			{
				(App.instance as MovieClip).addChild(this);
			}
		}

		private function _getContainer(containerName:String) : ISimpleManagedContainer
		{
			return App.containerMgr.getContainer(LAYER_NAMES.LAYER_ORDER.indexOf(containerName))
		}

		private function onStageResize(e:StageResizeEvent) : void
		{
			invalidateSize();
			validateNow();
		}

		private function onViewLoaded(event:LoaderEvent) : void 
		{
			var view:IView = event.view as IView;
			processView(view);
		}

		private function processView(view:IView) : void 
		{
			var alias:String = view.as_config.alias;

			if (alias == Aliases.LOGIN)
			{
				isInLobby = false;

				buttonCreate();

				(view as LoginPage).addChild(DisplayObject(modsButton));
			}

			if (alias == Aliases.LOBBY)
			{
				addAsChildToApp();
				isInLobby = true;
				messengerBar = (view as LobbyPage).messengerBar as MessengerBar;

				buttonCreate();

				modsButton.y = BUTTON_LOBBY_TOP_MARGIN;

				messengerBar.addChild(DisplayObject(modsButton));
				messengerBar.constraints.addElement("modsButton", DisplayObject(modsButton), Constraints.RIGHT);

				messengerBar.addEventListener(LifeCycleEvent.ON_AFTER_POPULATE, handleMessangerBarPopulate);
				messengerBar.addEventListener(LifeCycleEvent.ON_BEFORE_DISPOSE, handleMessangerBarDispose);
			}

			if (INVALIDATE_ALIASES.indexOf(alias) >= 0)
			{
				invalidateSize();
			}
		}

		private function handleModsButtonClick(event:ButtonEvent) : void 
		{
			onButtonClickS(isInLobby);
			_blinking = false;
			invalidateData();
			App.toolTipMgr.hide();
			App.popoverMgr.show(modsButton, POPOVER_ALIAS);
		}

		private function handleMessangerBarPopulate() : void
		{
			fixRightSideBtnsOrder();
			App.utils.scheduler.scheduleOnNextFrame(fixRightSideBtnsOrder);
		}

		private function handleMessangerBarDispose() : void
		{
			messengerBar = null;
		}

		private function buttonCreate() : void
		{
			buttonDestroy();
			modsButton = App.utils.classFactory.getComponent(_buttonLinkage, ModsListBlinkingButton);
			modsButton.addEventListener(ButtonEvent.CLICK, handleModsButtonClick);
			invalidateData();
			invalidateSize();
		}

		private function buttonDestroy() : void
		{
			if (modsButton)
			{
				if (modsButton.parent)
				{
					modsButton.parent.removeChild(modsButton);
				}
				modsButton.removeEventListener(ButtonEvent.CLICK, handleModsButtonClick);
				if (!modsButton.isDisposed())
				{
					modsButton.dispose();
				}
			}
			modsButton = null;
		}

		override protected function setStaticData(data:ModsListStaticDataVO) : void 
		{
			_buttonLinkage = data.buttonLinkage;
			_tooltip = data.tooltipLabel;
			invalidateData();
		}

		private function fixRightSideBtnsOrder() : void
		{
			// just skip if not initialized
			if (!messengerBar || !modsButton)
				return;

			// try insert our button in order if it not in it
			// insert after notifications and before others
			var rightSideBtnsOrder:Vector.<IDisplayObject> = messengerBar['_rightSideBtnsOrder'];
			if (rightSideBtnsOrder && rightSideBtnsOrder.indexOf(modsButton) == -1)
				rightSideBtnsOrder.splice(1, 0, modsButton);
		}

		override protected function buttonBlinking() : void 
		{
			_blinking = true;
			invalidateData();
		}

	}
}
