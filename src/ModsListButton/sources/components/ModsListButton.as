package components {

	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import net.wg.infrastructure.base.AbstractView;
	import flash.events.Event;
	import net.wg.infrastructure.events.LoaderEvent;
	import net.wg.infrastructure.interfaces.IView;
	import net.wg.gui.lobby.LobbyPage;
	import net.wg.gui.components.controls.SoundButton;
	import net.wg.gui.lobby.messengerBar.MessengerBar;
	import net.wg.infrastructure.events.LifeCycleEvent;
	import flash.events.MouseEvent;
	import net.wg.data.Aliases;
	import net.wg.infrastructure.interfaces.IPopOverCaller;
	import flash.display.DisplayObject;
	import flash.external.ExternalInterface;
	import net.wg.data.constants.SoundTypes;
	import flash.utils.*;

	public class ModsListButton extends AbstractView implements IPopOverCaller {

		private var lobby: LobbyPage = null;
		private var modsButton: ModsListButtonFrame = null;
		private var canResize: Boolean = true;
		private var tooltipText:String = 'Список модификаций: удобный запуск, настройка и оповещение.';
		
		public var modsMenuButtonClickS:Function = null;
		public var fromLobbyS:Function = null;
		
		public function ModsListButton() {
			this.init();
		}
		
		override protected function nextFrameAfterPopulateHandler(): void {
			if(this.parent != App.instance)
				(App.instance as MovieClip).addChild(this);
			visible = false;
		}
		
		public function as_setTooltipText(tooltipText:String): void {
			this.tooltipText = tooltipText;
		}
		
		public function as_handleModAlert():void {
			this.modsButton.startBlinking();
		}

		public function getTargetButton(): DisplayObject {
			return this.modsButton;
		}

		public function getHitArea(): DisplayObject {
			return this.modsButton;
		}

		private function init(e: Event = null): void {
			if(!stage) {
				addEventListener(Event.ADDED_TO_STAGE, init);
				return;
			}
			removeEventListener(Event.ADDED_TO_STAGE, init);
			App.containerMgr.loader.loadLibraries(Vector.<String>(["toolTips.swf","popovers.swf"]));
			App.containerMgr.loader.addEventListener(LoaderEvent.VIEW_LOADED, onViewLoaded);
		}

		private function onViewLoaded(e: LoaderEvent): void {
			processView(e.view, false);
		}

		private function processView(view: IView, populated: Boolean): void {
			try {
				var current_alias: String = view.as_alias;
				if(current_alias == "lobby") {
					this.canResize = true;
					this.lobby = view as LobbyPage;
					setTimeout(function():void { arguments[0].createModsButton(true); }, 1, this);
					fromLobbyS(true);
				}
				if(current_alias == "hangar") {
					this.createModsButton(false);
					fromLobbyS(true);
				}
				if (current_alias == "login") {
					setTimeout(this.createModsButtonLoginWindow, 1);
					fromLobbyS(false);
				}
			} catch(ex: Error) {
				DebugUtils.LOG_ERROR(ex);
			}
		}

		private function createModsButton(fromLobby:Boolean): void {
			
			if(this.lobby != null) {
				var messengerBar: MessengerBar = this.lobby.messengerBar;
				
				if (fromLobby) {
					this.modsButton = new ModsListButtonFrame(this.tooltipText);
				}
				
				this.modsButton.width = 72;
				this.modsButton.height = 32;
				
				this.modsButton.soundType = SoundTypes.MESSANGER_BTN;
				
				messengerBar.addEventListener(Event.RESIZE, this.handleMessengerBarResize);
				
				
				if (!fromLobby && this.canResize) {
					messengerBar.channelCarousel.width -= this.modsButton.width + 4;
					this.canResize = false;
				}
				
				this.modsButton.x = messengerBar.notificationListBtn.x - this.modsButton.width - 4;
				this.modsButton.y = messengerBar.notificationListBtn.y;

				
				messengerBar.addChild(this.modsButton);	
				
				if(!this.modsButton.hasEventListener(MouseEvent.CLICK)) {
					this.modsButton.addEventListener(MouseEvent.CLICK, this.handleModsButtonClick);
				}
				
			}
			
		}

		private function createModsButtonLoginWindow(): void {

			var doc:DisplayObjectContainer = DisplayObjectContainer(stage);
			doc = DisplayObjectContainer(this.recursiveFindDOC(doc, "net.wg.app.impl::LobbyApp"));
			doc = DisplayObjectContainer(this.recursiveFindDOC(doc, "net.wg.gui.components.containers::MainViewContainer"));
			var LoginPageUI:* = DisplayObjectContainer(this.recursiveFindDOC(doc, "LoginPageUI"));
			var rssNewsFeed:* = DisplayObjectContainer(this.recursiveFindDOC(LoginPageUI, "RssNewsFeedUI"));
			
			this.modsButton = new ModsListButtonFrame(this.tooltipText);
			
			this.modsButton.width = 72;
			this.modsButton.height = 32;
			
			this.modsButton.soundType = SoundTypes.MESSANGER_BTN;
			
			this.modsButton.x = rssNewsFeed.x + 140;
			this.modsButton.y = rssNewsFeed.y - 34;
			
			LoginPageUI.addChild(this.modsButton);	
			
			if(!this.modsButton.hasEventListener(MouseEvent.CLICK)) {
				this.modsButton.addEventListener(MouseEvent.CLICK, this.handleModsButtonClick);
			}
				
		}

		private function handleMessengerBarResize(event: Event): void {
			this.canResize = true;
			this.createModsButton(false);
		}
		
		private function handleModsButtonClick(event: MouseEvent): void {
			this.modsMenuButtonClickS();
			App.popoverMgr.show(this, "ModsListPopover");
			this.modsButton.stopBlinking(); 
		}
		
		
		private function recursiveFindDOC(dOC:DisplayObjectContainer, className:String) : DisplayObject {
			var child:DisplayObject = null;
			var childOC:DisplayObjectContainer = null;
			var numCh:int = dOC.numChildren;
			var i:int = 0;
			var result:DisplayObject = null;
			while(i < numCh) {
				child = dOC.getChildAt(i);
				if((child is DisplayObject) && (getQualifiedClassName(child) == className)) result = DisplayObject(child);
				if (result != null) return result;
				childOC = child as DisplayObjectContainer;
				if((childOC) && (childOC.numChildren > 0)) result = this.recursiveFindDOC(childOC, className);
				i++;
			}
			return result;
		}
		
		private function recursivePrintDOC(dOC:DisplayObjectContainer, depth:int, currentDeph:int, depthIter:String) : void {
			if (currentDeph <= depth) {
				var child:DisplayObject = null;
				var childOC:DisplayObjectContainer = null;
				var numCh:int = dOC.numChildren;
				var i:int = 0;
				var l:int = 0;
				var logStr:String = '';
				while (l < currentDeph) {
					logStr = logStr + depthIter;
					l++;
				}
				
				while (i < numCh) {
					child = dOC.getChildAt(i);
					childOC = child as DisplayObjectContainer;
					
					DebugUtils.LOG_DEBUG(logStr, getQualifiedClassName(child));
					
					if ((childOC) && (childOC.numChildren > 0)) {
						this.recursivePrintDOC(childOC, depth, currentDeph + 1, depthIter);
					}
					i++;
				}
			}
		}
		
	}
 
}