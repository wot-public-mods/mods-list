package ModsListPopover_source.poliroid.utils {

	import flash.display.Bitmap;
	
	public class Images {
		
		public function Images() {
			throw new Error("Images class is static container");
		}
		
		[Embed(source="../../images/button_default.jpg")]
		private static const imageButtonDefault:Class;
		public static function buttonDefault():Bitmap {
			return new imageButtonDefault();
		}
		
		[Embed(source="../../images/button_hover.jpg")]
		private static const imageButtonHover:Class;
		public static function buttonHover():Bitmap {
			return new imageButtonHover();
		}
		
		[Embed(source="../../images/button_disabled.jpg")]
		private static const imageButtonDisabled:Class;
		public static function buttonDisabled():Bitmap {
			return new imageButtonDisabled();
		}
		
		[Embed(source="../../images/alert_icon.png")]
		private static const imageAlertIcon:Class;
		public static function alertIcon():Bitmap {
			return new imageAlertIcon();
		}
		
	}
}