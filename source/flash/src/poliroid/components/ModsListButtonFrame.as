package poliroid.components {
	
	import net.wg.gui.components.controls.SoundButton;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.*;
	
	dynamic public class ModsListButtonFrame extends SoundButton {
		
		[Embed(source="../../../res/modsListApi/button_normal.png")]
		private static var imageButtonNormal:Class;
		
		[Embed(source="../../../res/modsListApi/button_hover.png")]
		private static var imageButtonHover:Class;
		
		[Embed(source="../../../res/modsListApi/button_pressed.png")]
		private static var imageButtonPressed:Class;
		
		[Embed(source="../../../res/modsListApi/button_blink.png")]
		private static var imageButtonBlink:Class;
		
		[Embed(source="../../../res/modsListApi/button_icon.png")]
		private static var imageButtonIcon:Class;
		
		
		private var blinker_current_frame:uint = 0;
        private var blinker_count_frames:uint = 165;
        private var blinker_blink:Boolean = true;
        private var blinker_alpha:uint = 0;
        private var blinker_interval:uint;
		
        private var _blinking:Boolean;
		private var _images:Object = new Object();
		private var _toltipText:String = "";
		
		public function ModsListButtonFrame() {
			
			super();
			
			this.focusable = false;
			this.tabEnabled = false;
			
			this._images.button_normal = new imageButtonNormal() as Bitmap;
			this.addChild(this._images.button_normal);
			
			this._images.button_blink = new imageButtonBlink() as Bitmap;
			this._images.button_blink.visible = false;
			this.addChild(this._images.button_blink);
			
			this._images.button_hover = new imageButtonHover() as Bitmap;
			this._images.button_hover.visible = false;
			this.addChild(this._images.button_hover);
			
			this._images.button_pressed = new imageButtonPressed() as Bitmap;
			this._images.button_pressed.visible = false;
			this.addChild(this._images.button_pressed);
			
			this._images.button_icon = new imageButtonIcon() as Bitmap;
			this.addChild(this._images.button_icon);
			
			this.addEventListener(MouseEvent.ROLL_OVER, this.handleRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, this.handleRollOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.handleDown);
			this.addEventListener(MouseEvent.MOUSE_UP, this.handleUp);
		}
		
		public function startBlinking():void {
			clearInterval(this.blinker_interval); 
			this.blinker_current_frame = 0;
			this.blinker_blink = true;
			this.blinker_alpha = 0;
			this.blinker_interval = setInterval(this.drawBlink, 25);
		}
		
		public function stopBlinking():void {
			this._images.button_blink.visible = false;
			this.blinker_current_frame = 0;
			clearInterval(this.blinker_interval); 
		}
		
		private function processBlinking():void {
			if (this._blinking) {
				this.startBlinking();
			} else {
				this.stopBlinking();
			}
		}
		
		private function drawBlink(): void {
			
			if (!this._images.button_blink.visible){ 
				this._images.button_blink.visible = true;
			}
			this._images.button_blink.alpha = this.blinker_alpha / 15;
			
			if (this.blinker_blink) {
				this.blinker_alpha += 1;
			} else {
				this.blinker_alpha -= 1;
			}
			
			if(this.blinker_alpha == 0){this.blinker_blink = true;}
			if(this.blinker_alpha == 15){ this.blinker_blink = false;}
			
			this.blinker_current_frame += 1;
			if (this.blinker_current_frame > this.blinker_count_frames){
				this._images.button_blink.alpha = 1;
				clearInterval(this.blinker_interval); 
			}
		}
		
		private function handleRollOver(event:MouseEvent): void {
			this._images.button_hover.visible = true;
			this._images.button_pressed.visible = false;
			App.toolTipMgr.show(this._toltipText);
		}

		private function handleRollOut(event:MouseEvent): void {
			this._images.button_hover.visible = false;
			this._images.button_pressed.visible = false;
			App.toolTipMgr.hide();
		}
		
		private function handleDown(event:MouseEvent): void {
			this._images.button_hover.visible = false;
			this._images.button_pressed.visible = true;
		}
		
		private function handleUp(event:MouseEvent): void {
			this._images.button_hover.visible = true;
			this._images.button_pressed.visible = false;
		}
		
		public function set helpText(text:String):void {
			this._toltipText = text;
		}
		public function get helpText():String {
			return this._toltipText;
		}
		
		public function set blinking(blinking:Boolean):void {
			this._blinking = blinking;
			this.processBlinking();
		}
		public function get blinking():Boolean {
			return this._blinking;
		}
	}
	
}
