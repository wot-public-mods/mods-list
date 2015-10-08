package ModsListButton_source.poliroid.utils {

	import flash.display.Bitmap;
	
	public class Images {
		
		public function Images() {
			throw new Error("Images class is static container");
		}
		
		[Embed(source="../../images/button_normal.png")]
		private static const imageButtonNormal:Class;
		public static function buttonNormal():Bitmap {
			return new imageButtonNormal();
		}
		
		[Embed(source="../../images/button_hover.png")]
		private static const imageButtonHover:Class;
		public static function buttonHover():Bitmap {
			return new imageButtonHover();
		}
		
		[Embed(source="../../images/button_pressed.png")]
		private static const imageButtonPressed:Class;
		public static function buttonPressed():Bitmap {
			return new imageButtonPressed();
		}
		
		[Embed(source="../../images/button_blink.png")]
		private static const imageButtonBlink:Class;
		public static function buttonBlink():Bitmap {
			return new imageButtonBlink();
		}
		
		[Embed(source="../../images/button_icon.png")]
		private static const imageButtonIcon:Class;
		public static function buttonIcon():Bitmap {
			return new imageButtonIcon();
		}
		
	}
}