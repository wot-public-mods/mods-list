package components {
	 

	import net.wg.gui.components.controls.SoundButton;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.*;
	
	dynamic public class ModsListButtonFrame extends SoundButton {

		[Embed(source="../images/button_normal.png")]
		private static var button_normal_img:Class;
		private var button_normal:Bitmap;

		[Embed(source="../images/button_hover.png")]
		private static var button_hover_img:Class;
		private var button_hover:Bitmap;

		[Embed(source="../images/button_pressed.png")]
		private static var button_pressed_img:Class;
		private var button_pressed:Bitmap;

		[Embed(source="../images/button_blink.png")]
		private static var button_blink_img:Class;
		private var button_blink:Bitmap;

		[Embed(source="../images/button_icon.png")]
		private static var button_icon_img:Class;
		private var button_icon:Bitmap;
		
		private var blinker_current_frame:uint = 0;
        private var blinker_count_frames:uint = 165;
        private var blinker_blink:Boolean = true;
        private var blinker_alpha:uint = 0;
        private var blinker_interval:uint;
		
		public var toltipText:String = "";
		
		public function ModsListButtonFrame(toltipText:String) {
			super();
			
			this.toltipText = toltipText;
			
			this.button_normal = new button_normal_img();
			this.addChild(this.button_normal);
			
			this.button_blink = new button_blink_img();
			this.button_blink.visible = false;
			this.addChild(this.button_blink);
			
			this.button_hover = new button_hover_img();
			this.button_hover.visible = false;
			this.addChild(this.button_hover);
			
			this.button_pressed = new button_pressed_img();
			this.button_pressed.visible = false;
			this.addChild(this.button_pressed);
			
			this.button_icon = new button_icon_img();
			this.addChild(this.button_icon);
			
			this.addEventListener(MouseEvent.ROLL_OVER, this.handleRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, this.handleRollOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.handleDown);
			this.addEventListener(MouseEvent.MOUSE_UP, this.handleUp);
		}
		
		public function startBlinking():void {
			this.blinker_current_frame = 0;
			this.blinker_blink = true;
			this.blinker_alpha = 0;
			this.blinker_interval = setInterval(drawBlink, 25);
		}
		
		public function stopBlinking():void {
			this.button_blink.visible = false;
			this.blinker_current_frame = 0;
			clearInterval(this.blinker_interval); 
		}
		
		private function drawBlink(): void {
			
			if (!this.button_blink.visible){ 
				this.button_blink.visible = true;
			}
			this.button_blink.alpha = this.blinker_alpha / 15;
			
			if (this.blinker_blink) {
				this.blinker_alpha += 1;
			} else {
				this.blinker_alpha -= 1;
			}
			
			if(this.blinker_alpha == 0){this.blinker_blink = true;}
			if(this.blinker_alpha == 15){ this.blinker_blink = false;}
			
			this.blinker_current_frame += 1;
			if (this.blinker_current_frame > this.blinker_count_frames){
				this.button_blink.alpha = 1;
				clearInterval(this.blinker_interval); 
			}
		}
		
		private function handleRollOver(event:MouseEvent): void {
			this.button_hover.visible = true;
			this.button_pressed.visible = false;
			App.toolTipMgr.show(this.toltipText);
		}

		private function handleRollOut(event:MouseEvent): void {
			this.button_hover.visible = false;
			this.button_pressed.visible = false;
			App.toolTipMgr.hide();
		}
		
		private function handleDown(event:MouseEvent): void {
			this.button_hover.visible = false;
			this.button_pressed.visible = true;
		}
		
		private function handleUp(event:MouseEvent): void {
			this.button_hover.visible = true;
			this.button_pressed.visible = false;
		}
	}
	
}
