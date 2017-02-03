package com.poliroid.gui.lobby.modsList.controls
{
	
	import net.wg.gui.components.controls.SoundButtonEx;
	import net.wg.gui.interfaces.ISoundButtonEx;
	
	public class ModsListBlinkingButton extends SoundButtonEx implements ISoundButtonEx
	{
		private var _blinking:Boolean = false;
		
		public function ModsListBlinkingButton()
		{
			super();
		}
		
		override protected function getStatePrefixes() : Vector.<String>
		{
			return _blinking ? Vector.<String>(['blinking_', '']) : Vector.<String>(['']);
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
	}
}
