package com.poliroid.components.lobby
{
	
	import net.wg.gui.components.controls.SoundButtonEx;
	
	public class ModsListBlinkingButton extends SoundButtonEx
	{
		private var _blinking:Boolean;
		
		public function ModsListBlinkingButton()
		{
			super();
			setState('up');
		}
		
		override protected function canShowTooltipByHover() : Boolean
		{
			return enabled;
		}
		
		public function get blinking() : Boolean
		{
			return _blinking;
		}
		
		public function set blinking(isBlinking:Boolean) : void
		{
			if(_blinking == isBlinking)
				return;
			_blinking = isBlinking;
			setState(state);
		}
		
		override protected function getStatePrefixes() : Vector.<String>
		{
			return _blinking ? Vector.<String>(['blinking_', '']) : Vector.<String>(['']);
		}
	}
}
