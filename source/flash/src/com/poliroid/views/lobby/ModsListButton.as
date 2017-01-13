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
		public var onButtonClickS:Function;
		public var modsButton:ModsListBlinkingButton;
		private var isLobby:Boolean;
		private var messangerBar:MessengerBar;
		
		public function ModsListButton() 
		{
			super();
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
			
			modsButton.addEventListener(ButtonEvent.CLICK, onButtonClick);
		}
		
		override protected function onDispose() : void 
		{
			if (modsButton) {
				modsButton.removeEventListener(ButtonEvent.CLICK, onButtonClick);
				modsButton.dispose();
				modsButton = null;
			}
			
			(App.containerMgr as ContainerManagerBase).loader.removeEventListener(LoaderEvent.VIEW_LOADED, onViewLoaded);
			
			App.instance.stage.removeEventListener(Event.RESIZE, onResize);
			
			super.onDispose();
		}
		
		public function getTargetButton() : DisplayObject 
		{
			// this need for correct smart popover work
			return modsButton;
		}
		
		public function getHitArea() : DisplayObject 
		{
			// this need for correct smart popover work
			return modsButton;
		}
		
		override protected function nextFrameAfterPopulateHandler() : void 
		{
			// this needs for valid Focus snd Position in Login Window   
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
			
			if (alias == Aliases.LOGIN) 
			{
				messangerBar = null;
				isLobby = false;

				onResize();
				
				(view as LoginPage).addChild(modsButton);
			}
			else if (alias == Aliases.LOBBY) 
			{
				
				// in case whan hangar loaded faster then nextFrameAfterPopulateHandler fire
				if (parent != App.instance)
					(App.instance as MovieClip).addChild(this);
				
				
				isLobby = true;
				messangerBar = ((view as LobbyPage).messengerBar as MessengerBar);
				
				moveButton(messangerBar.vehicleCompareCartBtn.x, 9);
				
				// move "vehicle compare button" and "vehicle name anim" left
				messangerBar.vehicleCompareCartBtn.x -= 77;
				messangerBar.animPlacer.x -= 77;
				
				// append modsButton to messangerBar.constraints (all bottom buttons position manager)
				messangerBar.addChild(modsButton);
				messangerBar.constraints.addElement("modsButton", modsButton, Constraints.RIGHT);
				
				onResize();
			}
			
			if (alias == Aliases.LOBBY_HANGAR) {
				onResize();
			}
				
		}
		
		private function channelCarouselResize(e:Event = null) 
		{
			if (isLobby && messangerBar) 
			{
				var rightNext:DisplayObject = messangerBar.vehicleCompareCartBtn.visible ? messangerBar.vehicleCompareCartBtn: modsButton;
				var validWidth:Number = rightNext.x - messangerBar.channelCarousel.x - 1;
				if (messangerBar.channelCarousel.width != validWidth)
					messangerBar.channelCarousel.width = validWidth;
			}
		}
		
		private function moveButton(posX:Number, posY:Number) : void
		{
			modsButton.x = posX;
			modsButton.y = posY;
		}
		
		private function onResize(e:Event = null) : void 
		{
			if (isLobby) 
				channelCarouselResize();
			else 
				moveButton(App.appWidth - 80, App.appHeight - 35);
		}
		
		private function onButtonClick(event: ButtonEvent) : void 
		{
			onButtonClickS(isLobby);
			modsButton.blinking = false;
			App.toolTipMgr.hide();
			App.popoverMgr.show(this, "modsListPopover");
		}
		
		public function as_setTooltipText(text:String) : void 
		{
			modsButton.tooltip = text;
		}
		
		public function as_ButtonBlinking() : void 
		{
			modsButton.blinking = true;
		}
		
		public function as_handleCompareBasketVisibility() : void 
		{
			channelCarouselResize();
		}
	}
}
