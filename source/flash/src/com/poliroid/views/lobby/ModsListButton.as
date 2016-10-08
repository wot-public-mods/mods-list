package com.poliroid.views.lobby 
{

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;

	import scaleform.clik.events.ButtonEvent;
	import scaleform.clik.utils.Constraints;
	
	import net.wg.data.Aliases;
	import net.wg.infrastructure.base.AbstractView;
	import net.wg.infrastructure.events.LifeCycleEvent;
	import net.wg.infrastructure.events.LoaderEvent;
	import net.wg.infrastructure.interfaces.IManagedContainer;
	import net.wg.infrastructure.interfaces.IPopOverCaller;
	import net.wg.infrastructure.interfaces.IView;
	import net.wg.infrastructure.managers.impl.ContainerManagerBase;
	import net.wg.gui.components.containers.MainViewContainer;
	import net.wg.gui.lobby.messengerBar.MessengerBar;
	import net.wg.gui.lobby.LobbyPage;
	import net.wg.gui.login.impl.LoginPage;
	
	import com.poliroid.components.lobby.ModsListBlinkingButton;
	
	public class ModsListButton extends AbstractView implements IPopOverCaller 
	{
		public var onButtonClickS:Function = null;
		private var _button:ModsListBlinkingButton = null;
		private var _isLobby:Boolean = false;
		private var _tooltipText:String = "";
		private var _messangerBar:MessengerBar = null;
		
		public function ModsListButton() 
		{
			super();
			focusable = false;
		}
		
		override protected function onPopulate() : void 
		{
			super.onPopulate();
			
			// load popovers.swf for show popup in Login Window
			App.instance.loaderMgr.loadLibraries(Vector.<String>(["popovers.swf"]));
		}
		
		override protected function onDispose() : void 
		{
			if (_button) {
				_button.removeEventListener(ButtonEvent.CLICK, onButtonClick);
				_button.dispose();
				_button = null;
			}
			
			(App.containerMgr as ContainerManagerBase).loader.removeEventListener(LoaderEvent.VIEW_LOADED, onViewLoaded);
			
			App.instance.stage.removeEventListener(Event.RESIZE, onResize);
			
			super.onDispose();
		}
			
		override protected function configUI() : void 
		{
			super.configUI();
			
			// subscribe to container manager loader
			(App.containerMgr as ContainerManagerBase).loader.addEventListener(LoaderEvent.VIEW_LOADED, onViewLoaded, false, 0, true);
			
			// subscribe to stage resize
			App.instance.stage.addEventListener(Event.RESIZE, onResize);
			
			// process already loaded views
            var containerMgr:ContainerManagerBase = App.containerMgr as ContainerManagerBase;
            for each (var container:IManagedContainer in containerMgr.containersMap)
            {
                var viewContainer:MainViewContainer = container as MainViewContainer;
                if (viewContainer != null)
                {
                    var num:int = viewContainer.numChildren;
                    for (var idx:int = 0; idx < num; ++idx)
                    {
                        var view:IView = viewContainer.getChildAt(idx) as IView;
                        if (view != null)
                            processView(view, true);
                    }
                }
            }
		}
		
		override protected function nextFrameAfterPopulateHandler() : void 
		{
			// this needs for valid Focus in Login Window   
			if (parent != App.instance) {
				(App.instance as MovieClip).addChild(this);
			}
		}
		
		private function onViewLoaded(event:LoaderEvent) : void
        {
			var view:IView = event.view as IView;
			processView(view);
		}
		
		private function processView(view:IView, populated:Boolean = false) : void
        {
			var alias:String = view.as_config.alias;
			
			if (alias == Aliases.LOGIN) {
				_messangerBar = null;
				_isLobby = false;
				
				assembleButton(App.appWidth - 80, App.appHeight - 35);
				
				(view as LoginPage).addChild(_button);
			}
			
			if (alias == Aliases.LOBBY) {
				_isLobby = true;
				_messangerBar = ((view as LobbyPage).messengerBar as MessengerBar);
				
				assembleButton(858, 9);
				
				// move "vehicle compare butoon" and "vehicle name anim" left
				_messangerBar.vehicleCompareCartBtn.x -= 77;
				_messangerBar.animPlacer.x -= 77;
				
				// append modsButton to messangerBar.constraints (all bottom buttons position manager)
				_messangerBar.addChild(_button);
				_messangerBar.constraints.addElement("modsButton", _button, Constraints.RIGHT);
			}
		}
		
		public function getTargetButton() : DisplayObject 
		{
			// this need for correct smart popover work
			return _button;
		}
		
		public function getHitArea() : DisplayObject 
		{
			// this need for correct smart popover work
			return _button;
		}
		
		private function onButtonClick(event: ButtonEvent) : void 
		{
			onButtonClickS(_isLobby);
			_button.blinking = false;
			App.toolTipMgr.hide();
			App.popoverMgr.show(this, "modsListPopover");
		}
		
		private function onResize(e:Event = null) : void 
		{
			if (_isLobby) {
				channelCarouselResize();
			} else {
				_button.x = App.appWidth - 80;
				_button.y = App.appHeight - 35;
			}
		}
		
		private function channelCarouselResize(e:Event = null) 
		{
			if (_isLobby && _messangerBar) 
			{
				var rightNext:DisplayObject = _messangerBar.vehicleCompareCartBtn.visible ? _messangerBar.vehicleCompareCartBtn: _button;
				var validWidth:Number = rightNext.x - _messangerBar.channelCarousel.x - 1;
				if (_messangerBar.channelCarousel.width != validWidth)
					_messangerBar.channelCarousel.width = validWidth;
			}
		}
		
		private function assembleButton(_x:Number, _y:Number) : void
		{
			if (_button) {
				_button.removeEventListener(ButtonEvent.CLICK, onButtonClick);
				_button.dispose();
				_button = null;
			}
			_button = new ModsListBlinkingButton();
			_button.x = _x;
			_button.y = _y;
			_button.tooltip = _tooltipText;
			_button.addEventListener(ButtonEvent.CLICK, onButtonClick);
		}
		
		public function as_setTooltipText(tooltipText:String) : void 
		{
			_tooltipText = tooltipText;
			if (_button) 
				_button.tooltip = _tooltipText;
		}
		
		public function as_ButtonBlinking() : void 
		{
			if (_button)
				_button.blinking = true;
		}
		
		public function as_handleCompareBasketVisibility() : void 
		{
			channelCarouselResize();
		}
	}
}
