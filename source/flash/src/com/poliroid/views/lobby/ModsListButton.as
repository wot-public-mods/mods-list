package com.poliroid.views.lobby 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import scaleform.clik.events.ButtonEvent;
	import scaleform.clik.utils.Constraints;
	import net.wg.infrastructure.base.AbstractView;
	import net.wg.infrastructure.interfaces.IPopOverCaller;
	
	import com.poliroid.components.lobby.ModsListBlinkingButton;
	import com.poliroid.utils.Utils;
	
	public class ModsListButton extends AbstractView implements IPopOverCaller 
	{
		
		public var onButtonClickS:Function = null;
		
		private var _modsButton:ModsListBlinkingButton = null;
		private var _tooltipText:String = "";
		private var _isLobby:Boolean = false;
		private var _messangerBar:* = null;
		
		public function ModsListButton() 
		{
			super();
			focusable = false;
		}
		
		private function buildButton() : void 
		{
			_modsButton = new ModsListBlinkingButton();
			_modsButton.addEventListener(ButtonEvent.CLICK, handleModsButtonClick);
			_modsButton.tooltip = _tooltipText;
		}
		
		override protected function onPopulate() : void 
		{
			super.onPopulate();
			// load popovers.swf for show popup in Login Window
			App.instance.loaderMgr.loadLibraries(Vector.<String>(["popovers.swf"]));
		}
		
		override protected function nextFrameAfterPopulateHandler() : void 
		{
			// this one needs for Focus in Login Window   
			if (parent != App.instance) {
				(App.instance as MovieClip).addChild(this);
			}
		}
		
		public function getTargetButton() : DisplayObject 
		{
			if (_modsButton) {
				return DisplayObject(_modsButton);
			}
			return DisplayObject(this);
		}
		
		public function getHitArea() : DisplayObject 
		{
			if (_modsButton != null) {
				return DisplayObject(_modsButton);
			}
			return DisplayObject(this);
		}
		
		public function as_setTooltipText(tooltipText:String) : void 
		{
			_tooltipText = tooltipText;
			if (_modsButton) {
				_modsButton.helpText = tooltipText;
			}
		}
		
		public function as_populateLogin() : void 
		{
			_messangerBar = null;
			_isLobby = false;
			var LoginPageUI:DisplayObjectContainer = Utils.recursiveFindDOC(stage, "LoginPageUI");
			if (LoginPageUI) {
				buildButton();
				_modsButton.x = App.appWidth - 80;
				_modsButton.y = App.appHeight - 35;
				LoginPageUI.addChild(_modsButton);
			}
		}
		
		public function as_populateLobby() : void 
		{
			_isLobby = true;
			var MessengerBarUI:DisplayObjectContainer = Utils.recursiveFindDOC(stage, "MessengerBar_UI");
			if (MessengerBarUI) {
				_messangerBar = MessengerBarUI;
				buildButton();
				_modsButton.x = 858;
				_modsButton.y = 9;
				
				// move "vehicle compare butoon" and "vehicle name anim" left
				_messangerBar.vehicleCompareCartBtn.x -= 77;
				_messangerBar.animPlacer.x -= 77;
				
				// append modsButton to messangerBar.constraints (all bottom buttons position manager)
				_messangerBar.addChild(_modsButton);
				_messangerBar.constraints.addElement("modsButton", _modsButton, Constraints.RIGHT);
				
				// shitty channelCarousel resizing
				setTimeout(channelCarouselResize, 50);
				setTimeout(channelCarouselResize, 500);
				setTimeout(channelCarouselResize, 1000);
			}
		}
		
		public function as_handleChangeScreenResolution() : void 
		{
			if (!_isLobby && _modsButton) {
				_modsButton.x = App.appWidth - 80;
				_modsButton.y = App.appHeight - 35;
			} else {
				channelCarouselResize()
			}
		}
		
		public function as_handleButtonBlinking() : void 
		{
			if (_modsButton)
				_modsButton.blinking = true;
		}
		
		public function as_handleChannelCarouselResize() : void 
		{
			channelCarouselResize();	
		}
		
		private function channelCarouselResize(event:Event = null) {
			if (_isLobby && _messangerBar) {
				var rightNext:DisplayObject = _messangerBar.vehicleCompareCartBtn.visible ? _messangerBar.vehicleCompareCartBtn: _modsButton;
				var validChannelCarouselwidth:Number = rightNext.x - _messangerBar.channelCarousel.x - 1;
				if (_messangerBar.channelCarousel.width != validChannelCarouselwidth)
					_messangerBar.channelCarousel.width = validChannelCarouselwidth;
			}
			
		}
		
		private function handleModsButtonClick(event: ButtonEvent) : void 
		{
			onButtonClickS();
			App.toolTipMgr.hide();
			App.popoverMgr.show(this, "modsListPopover");
			if (_modsButton)
				_modsButton.blinking = false;
		}
		
	}
}
