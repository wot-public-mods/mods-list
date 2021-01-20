package com.poliroid.gui.lobby.modsList 
{

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;

	import scaleform.clik.constants.InvalidationType;
	import scaleform.clik.events.ButtonEvent;
	import scaleform.clik.utils.Constraints;

	import net.wg.infrastructure.managers.impl.ContainerManagerBase;
	import net.wg.gui.components.containers.MainViewContainer;
	import net.wg.infrastructure.events.LifeCycleEvent;
	import net.wg.infrastructure.interfaces.ISimpleManagedContainer;
	import net.wg.infrastructure.interfaces.IManagedContent;

	import net.wg.data.Aliases;
	import net.wg.data.constants.generated.LAYER_NAMES;
	import net.wg.gui.lobby.messengerBar.MessengerBar;
	import net.wg.infrastructure.interfaces.IView;
	import net.wg.infrastructure.events.LoaderEvent;
	import net.wg.gui.lobby.LobbyPage;
	import net.wg.gui.login.impl.LoginPage;

	import com.poliroid.gui.lobby.modsList.controls.ModsListBlinkingButton;
	import com.poliroid.gui.lobby.modsList.data.ModsListStaticDataVO;
	import com.poliroid.gui.lobby.modsList.interfaces.IModsListButtonMeta;
	import com.poliroid.gui.lobby.modsList.interfaces.impl.ModsListButtonMeta;

	public class ModsListButton extends ModsListButtonMeta implements IModsListButtonMeta 
	{

		private static const BUTTON_LOGIN_BOTTOM_MARGIN:int = 36;

		private static const BUTTON_LOGIN_RIGHT_MARGIN:int = 86;

		private static const BUTTON_LOBBY_TOP_MARGIN:int = 9;

		private static const BUTTON_LOBBY_GAP:int = 5;

		private static const POPOVER_ALIAS:String = 'ModsListApiPopover';

		private static const BUTTON_ALIAS:String = 'ModsListBlinkingButtonUI';

		private static const INVALIDATE_ALIASES:Array = [Aliases.LOGIN, Aliases.LOBBY, Aliases.LOBBY_HANGAR, Aliases.LOBBY_TRAINING_ROOM];

		public var modsButton:ModsListBlinkingButton = null;

		public var messengerBar:MessengerBar = null;

		public var isInLobby:Boolean = false;

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
			App.instance.stage.addEventListener(Event.RESIZE, onResize);

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
			App.instance.stage.removeEventListener(Event.RESIZE, onResize);

			super.onDispose();
		}

		override protected function draw() : void 
		{
			super.draw();

			if(isInvalid(InvalidationType.SIZE) && modsButton)
			{
				if (isInLobby && messengerBar)
				{
					var mostLeftButton:DisplayObject = DisplayObject(modsButton);
					if (messengerBar.sessionStatsBtn.visible)
					{
						mostLeftButton = DisplayObject(messengerBar.sessionStatsBtn);
					}
					if (messengerBar.vehicleCompareCartBtn.visible)
					{
						mostLeftButton = DisplayObject(messengerBar.vehicleCompareCartBtn);
					}
					messengerBar.channelCarousel.width = mostLeftButton.x - messengerBar.channelCarousel.x - 1;
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

		private function onResize(e:Event) : void 
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
				modsButton.x = Math.max(messengerBar.sessionStatsBtn.x, messengerBar.vehicleCompareCartBtn.x);
				modsButton.y = BUTTON_LOBBY_TOP_MARGIN;

				var positionOffset:int = BUTTON_LOBBY_GAP + modsButton.width;

				// move "sessionstats button" left
				messengerBar.sessionStatsBtn.x -= positionOffset;

				// move "vehicle compare button" and "vehicle name anim" left
				messengerBar.vehicleCompareCartBtn.x -= positionOffset;
				messengerBar.animPlacer.x -= positionOffset;

				// append modsButton to messengerBar.constraints (all bottom buttons position manager)
				messengerBar.addChild(DisplayObject(modsButton));
				messengerBar.constraints.addElement("modsButton", DisplayObject(modsButton), Constraints.RIGHT);

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

		private function handleMessangerBarDispose() : void
		{
			messengerBar = null;
		}

		private function buttonCreate() : void
		{
			buttonDestroy();
			modsButton = App.utils.classFactory.getComponent(BUTTON_ALIAS, ModsListBlinkingButton);
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
				modsButton.dispose();
			}
			modsButton = null;
		}

		override protected function setStaticData(data:ModsListStaticDataVO) : void 
		{
			_tooltip = data.descriptionLabel;
			invalidateData();
		}

		override protected function buttonBlinking() : void 
		{
			_blinking = true;
			invalidateData();
		}

		override protected function onButtonInvalid() : void 
		{
			invalidateSize();
		}
	}
}
