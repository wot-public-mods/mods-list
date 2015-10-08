package ModsListPopover_source.poliroid.components {
	
	import net.wg.gui.components.controls.SoundListItemRenderer;
	import flash.display.MovieClip;
	import flash.utils.ByteArray;
	import scaleform.clik.constants.InvalidationType;
	import flash.events.MouseEvent;
	import flash.display.Loader;
	import flash.text.TextField;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.filters.ColorMatrixFilter;
	import ModsListPopover_source.poliroid.utils.Base64;
	import ModsListPopover_source.poliroid.utils.Images;
	
	public class ModsListItemRenderer extends SoundListItemRenderer {
		
		public var modName:TextField;
		public var modIcon:MovieClip;
		public var id:String;
		public var descr:String;
		public var iconStr:String;
		public var icoLoader:Loader;
		
		private var _hovered:Boolean = false;
		private var _enabled:Boolean = true;
		private var _images:Object = null;
		
		public function ModsListItemRenderer() {
			super();
			this._images = new Object();
		}
		
		override public function setData(newDat:Object): void {
			if(newDat == null) {
				return;
			}
			this.data = newDat;
			invalidateData();
		}

		override protected function configUI(): void {
			super.configUI();
			
			this.width = 280;
			this.height = 70;
			
			
			this._images.button_default = Images.buttonDefault();
			this._images.button_default.visible = false;
			this.addChild(this._images.button_default);
			
			this._images.button_hover = Images.buttonHover();
			this._images.button_hover.visible = false;
			this.addChild(this._images.button_hover);
			
			this._images.button_disabled = Images.buttonDisabled();
			this._images.button_disabled.visible = false;
			this.addChild(this._images.button_disabled);
			
			this._images.alert_icon = Images.alertIcon();
			this._images.alert_icon.visible = false;
			this.addChild(this._images.alert_icon);
			
			this.modName = new TextField();
			this.modName.x = 70;
			this.modName.y = 20;
			this.modName.width = 190;
			this.modName.height = 25;
			this.addChild(this.modName);
			
			this.modIcon = new MovieClip();
			this.modIcon.x = 15;
			this.modIcon.y = 10;
			this.modIcon.width = 50;
			this.modIcon.height = 50;
			this.addChild(this.modIcon);
			
			if(this.data) {
				this.setup();
			}
		}

		override protected function handleMouseRollOver(event:MouseEvent): void {
			super.handleMouseRollOver(event);
			this._hovered = true;
			this.drawBG();
			App.toolTipMgr.show(this.descr);
		}

		override protected function handleMouseRollOut(event:MouseEvent): void {
			super.handleMouseRollOut(event);
			this._hovered = false;
			this.drawBG();
			App.toolTipMgr.hide();
		}
		
		override protected function draw(): void {
			if(isInvalid(InvalidationType.DATA)) {
				this.setup();
			}			
			super.draw();
			if(!this.data) {
				this.visible = false;
			}
			this._images.alert_icon.visible = this.data.alert;
		}
		
		private function setup(): void {
			if(this.data) {
				this.id = this.data.id;
				this.descr = this.data.description;
				this.iconStr = this.data.icon;
				this._enabled = this.data.enabled;
				
				var modNameColor:String;
				if (this._enabled){
					modNameColor = '#DDDDD0';
					this.modName.alpha = 1;
				} else {
					modNameColor = '#CCCCCC';
					this.modName.alpha = 0.9;
				}
				
				this.modName.htmlText = '<font size="16" color="' + modNameColor + '" face="$FieldFont"><b>' + this.data.name + '</b></font>';
				
				this.setModIcon();
				this.drawBG();
			}
		}
		
		private function drawBGBase(elem:Bitmap):void{
			this._images.button_disabled.visible = false;
			this._images.button_hover.visible = false;
			this._images.button_default.visible = false;
			elem.visible = true;
		}
		
		private function drawBG():void {
			if(this._enabled == false) {
				this.drawBGBase(this._images.button_disabled);
				return;
			}
			if(this._hovered == true) {
				this.drawBGBase(this._images.button_hover);
			} else {
				this.drawBGBase(this._images.button_default);
			}
		
		}
		
		
		
		
		private function setModIcon(): void {
			this.icoLoader = new Loader();
			this.icoLoader.loadBytes(Base64.decodeToByteArray(this.iconStr));
			this.icoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.icoLoadComplete);
		}

		private function icoLoadComplete(e: Event): void {
			var bmp: BitmapData = new BitmapData(50, 50, true, 0x0);
			bmp.draw(this.icoLoader);
			
			this.modIcon.addChild(new Bitmap(bmp));
			this.modIcon.height = this.modIcon.width = 50;
			
			var shadow:DropShadowFilter = new DropShadowFilter();
			shadow.distance = shadow.angle = 0;
			shadow.color = Number('0x000000');
			shadow.alpha = 0.7;
			shadow.blurX = shadow.blurY = 4;
			shadow.strength = 3;
			shadow.quality = 8;
			
			if (!this._enabled){
				var cc:Number = 1/4;
				var greyscale:ColorMatrixFilter = new ColorMatrixFilter([cc, cc, cc, 0, 0, cc, cc, cc, 0, 0, cc, cc, cc, 0, 0, 0, 0, 0, 1, 0]);
				this.modIcon.filters = new Array(greyscale, shadow);
				this.modIcon.alpha = 0.8;
			} else {
				this.modIcon.filters = new Array(shadow);
				this.modIcon.alpha = 1;
			}
		}

	}
}
