package ModsListButton_source.poliroid.components {
	
	import net.wg.gui.components.controls.SoundButton;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.*;
	import ModsListButton_source.poliroid.utils.Images;
	
	dynamic public class ModsListButtonFrame extends SoundButton {

		
		private var blinker_current_frame:uint = 0;
        private var blinker_count_frames:uint = 165;
        private var blinker_blink:Boolean = true;
        private var blinker_alpha:uint = 0;
        private var blinker_interval:uint;
		
        private var _blinking:Boolean;
		private var _images:Object = null;
		private var _toltipText:String = "";
		
		public function ModsListButtonFrame() {
			super();
			
			this._images = new Object();
			
			this._images.button_normal = Images.buttonNormal();
			this.addChild(this._images.button_normal);
			
			this._images.button_blink = Images.buttonBlink();
			this._images.button_blink.visible = false;
			this.addChild(this._images.button_blink);
			
			this._images.button_hover = Images.buttonHover();
			this._images.button_hover.visible = false;
			this.addChild(this._images.button_hover);
			
			this._images.button_pressed = Images.buttonPressed();
			this._images.button_pressed.visible = false;
			this.addChild(this._images.button_pressed);
			
			this._images.button_icon = Images.buttonIcon();
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
			this.blinker_interval = setInterval(drawBlink, 25);
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
			
			if (!this.button_blink.visible){ 
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
