package com.poliroid.gui.lobby.modsList.controls
{
	import flash.display.DisplayObject;
	
	import net.wg.gui.components.controls.SoundButtonEx;
	import net.wg.infrastructure.interfaces.IPopOverCaller;
	
	public class ModsListBlinkingButton extends SoundButtonEx implements IPopOverCaller 
	{
		private var _blinking:Boolean = false;
		
		public function ModsListBlinkingButton()
		{
			super();
		}
		
		override protected function getStatePrefixes() : Vector.<String>
		{
			if (blinking)
			{
				return Vector.<String>(['blinking_', '']);
			}
			else 
			{
				return Vector.<String>(['']);
			}
		}
		
		public function get blinking() : Boolean
		{
			return _blinking;
		}
		
		public function set blinking(isBlinking:Boolean) : void
		{
			if(blinking == isBlinking)
			{
				return;
			}
			_blinking = isBlinking;
			setState(state);
		}
		
		public function getTargetButton() : DisplayObject 
		{
			return this as DisplayObject;
		}
		
		public function getHitArea() : DisplayObject 
		{
			return this as DisplayObject;
		}
	}
}
