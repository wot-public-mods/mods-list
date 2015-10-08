package ModsListButton_source.poliroid.components {

	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	import net.wg.infrastructure.base.AbstractView;
	import flash.events.Event;
	
	import net.wg.infrastructure.events.LoaderEvent;
	import net.wg.infrastructure.events.LifeCycleEvent;
	
	import net.wg.infrastructure.interfaces.IView;
	import net.wg.gui.lobby.LobbyPage;
	import net.wg.gui.components.controls.SoundButton;
	import net.wg.gui.lobby.messengerBar.MessengerBar;
	import flash.events.MouseEvent;
	import net.wg.data.Aliases;
	import net.wg.infrastructure.interfaces.IPopOverCaller;
	import flash.display.DisplayObject;
	import flash.external.ExternalInterface;
	import net.wg.data.constants.SoundTypes;
	import flash.utils.*;
	
	import net.wg.gui.components.controls.IconTextBigButton;
	import net.wg.gui.components.advanced.BlinkingButton;
	import ModsListButton_source.poliroid.components.ModsListButtonFrame;
	
	public class ModsListButton extends AbstractView implements IPopOverCaller {

		private var lobby: LobbyPage = null;
		private var modsButtonLobby: BlinkingButton = null;
		private var modsButtonLogin: ModsListButtonFrame = null;
		private var canResize: Boolean = true;
		private var tooltipText:String = 'Список модификаций: удобный запуск, настройка и оповещение.';
		
		public var onButtonClickS:Function = null;
		public var isLobbyS:Function = null;
		public var logS:Function = null;
		
		private var isLobby:Boolean = false;
		
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
			if (this.isLobby) {
				this.modsButtonLobby.blinking = true;
			} else {
				this.modsButtonLogin.blinking = true;
			}
		}
		
		public function getTargetButton(): DisplayObject {
			if (this.isLobby) {
				return this.modsButtonLobby;
			} else {
				return this.modsButtonLogin;
			}
		}
		
		public function getHitArea(): DisplayObject {
			if (this.isLobby) {
				return this.modsButtonLobby;
			} else {
				return this.modsButtonLogin;
			}
		}
		
		private function init(e: Event = null): void {
			if(!stage) {
				addEventListener(Event.ADDED_TO_STAGE, init);
				return;
			}
			removeEventListener(Event.ADDED_TO_STAGE, init);
			App.containerMgr.loader.loadLibraries(Vector.<String>(["toolTips.swf", "popovers.swf"]));
			App.containerMgr.loader.addEventListener(LoaderEvent.VIEW_LOADED, onViewLoaded);
		}
		
		private function onViewLoaded(event: LoaderEvent): void {
			
			var view:IView = event.view as IView;
			var current_alias: String = view.as_alias;
			
			if (current_alias == "lobby") {
				this.lobby = view as LobbyPage;
				this.isLobby = true;
				this.createModsButtonLobby();
			} else if (current_alias == "login") {
				this.isLobby = false;
				setTimeout(this.createModsButtonLogin, 1);
			}
			
			this.isLobbyS(this.isLobby);
		}
		
		private function createModsButtonLobby(): void {
			
			this.modsButtonLobby = App.utils.classFactory.getComponent("BlinkingButton_UI", BlinkingButton);
			this.modsButtonLobby.width = 72;
			this.modsButtonLobby.height = 33;
			this.modsButtonLobby.autoRepeat = false;
			this.modsButtonLobby.autoSize = "none";
			this.modsButtonLobby.data = "";
			this.modsButtonLobby.inspectableDisabledFillPadding = {
				"top":2,
				"right":1,
				"bottom":2,
				"left":2
			 };
			this.modsButtonLobby.enabled = true;
			this.modsButtonLobby.enableInitCallback = false;
			this.modsButtonLobby.focusable = true;
			this.modsButtonLobby.helpConnectorLength = 12;
			this.modsButtonLobby.helpDirection = "T";
			this.modsButtonLobby.helpText = this.tooltipText;
			this.modsButtonLobby.iconSource = "../../scripts/client/gui/mods/modsListApi/ModsListButtonIcon.png";
			this.modsButtonLobby.iconOffsetLeft = 22;
			this.modsButtonLobby.iconOffsetTop = 4;
			this.modsButtonLobby.label = "";
			this.modsButtonLobby.paddingHorizontal = 0.0;
			this.modsButtonLobby.selected = false;
			this.modsButtonLobby.soundId = "";
			this.modsButtonLobby.soundType = "normal";
			this.modsButtonLobby.toggle = false;
			this.modsButtonLobby.tooltip = "";
			this.modsButtonLobby.visible = true;
			
			
			
			
			var messengerBar:MessengerBar = this.lobby.messengerBar;
			this.modsButtonLobby.x = App.appWidth - 165;
			this.modsButtonLobby.y = messengerBar.notificationListBtn.y;
			
			messengerBar.addChild(this.modsButtonLobby);	
			
			messengerBar.channelCarousel.width = App.appWidth - 316;
			
			messengerBar.addEventListener(Event.RESIZE, this.handleMessengerBarResize);
			messengerBar.addEventListener(Event.ADDED, this.handleMessengerBarAdded);
			
			this.modsButtonLobby.addEventListener(MouseEvent.CLICK, this.handleModsButtonClick);
			
		}
		
		private function createModsButtonLogin(): void {
			
			this.logS("createModsButtonLogin 1");
			
			var LoginPageUI:DisplayObjectContainer = this.recursiveFindDOC(DisplayObjectContainer(stage), "LoginPageUI");
			
			this.logS("createModsButtonLogin 2");
			try {
				this.modsButtonLogin = new ModsListButtonFrame();
			} catch (er:Error) {
				this.logS(er.getStackTrace());
			}
			
			
			this.logS("createModsButtonLogin 3");
			
			this.modsButtonLogin.helpText = this.tooltipText;
			this.modsButtonLogin.width = 72;
			this.modsButtonLogin.height = 32;
			
			this.logS("createModsButtonLogin 4");
			
			this.modsButtonLogin.x = App.appWidth - 80;
			this.modsButtonLogin.y = App.appHeight - 34;
			
			this.logS("createModsButtonLogin 5");
			
			LoginPageUI.addChild(this.modsButtonLogin);	
			
			this.logS("createModsButtonLogin 6");
			
			this.modsButtonLogin.addEventListener(MouseEvent.CLICK, this.handleModsButtonClick);
			
			this.logS("createModsButtonLogin 7");
		}
		
		private function handleMessengerBarAdded(event: Event): void {
			if (this.lobby != null) {
				var messengerBar: MessengerBar = this.lobby.messengerBar;
				messengerBar.channelCarousel.width = App.appWidth - 316;
			}
		}
		
		private function handleMessengerBarResize(event: Event): void {
			if (this.lobby != null) {
				var messengerBar: MessengerBar = this.lobby.messengerBar;
				this.modsButtonLobby.x = App.appWidth - 165;
				messengerBar.channelCarousel.width = App.appWidth - 316;
			}
		}
		
		private function handleModsButtonClick(event: MouseEvent): void {
			this.onButtonClickS();
			App.popoverMgr.show(this, "ModsListPopover");
			if (this.isLobby) {
				this.modsButtonLobby.blinking = false;
			} else {
				this.modsButtonLogin.blinking = false;
			}
		}
		
		public function as_handleChangeScreenResolution(width:Number, height:Number):void {
			if (this.modsButtonLogin == null) {
				this.createModsButtonLogin();
			}
			if (!this.isLobby) {
				this.modsButtonLogin.x = width - 80;
				this.modsButtonLogin.y = height - 34;
			}
		}
		
		private function recursiveFindDOC(dOC:DisplayObjectContainer, className:String) : DisplayObjectContainer {
			var child:DisplayObject = null;
			var childOC:DisplayObjectContainer = null;
			var numCh:int = dOC.numChildren;
			var i:int = 0;
			var result:DisplayObjectContainer = null;
			while (i < numCh) {
				child = dOC.getChildAt(i);
				if ((child is DisplayObject) && (getQualifiedClassName(child) == className)) result = child as DisplayObjectContainer;
				if (result != null) return result;
				childOC = child as DisplayObjectContainer;
				if ((childOC) && (childOC.numChildren > 0)) result = this.recursiveFindDOC(childOC, className);
				i++;
			}
			return result;
		}
		
	}
 
}