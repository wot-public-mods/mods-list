package com.poliroid.gui.lobby.modsList.interfaces.impl 
{
	
	import flash.display.DisplayObject;
	
	import net.wg.data.constants.Errors;
	import net.wg.infrastructure.base.AbstractView;
	import net.wg.infrastructure.interfaces.IPopOverCaller;
	import net.wg.infrastructure.exceptions.AbstractException;
	
	import com.poliroid.gui.lobby.modsList.data.ModsListStaticDataVO;
	
	public class ModsListButtonMeta extends AbstractView implements IPopOverCaller 
	{
		
		public var onButtonClick:Function;
		
		public function ModsListButtonMeta() 
		{	
			super();
		}
		
		public function onButtonClickS(isInLobby:Boolean) : void
		{
			App.utils.asserter.assertNotNull(onButtonClick, "onButtonClick" + Errors.CANT_NULL);
			onButtonClick(isInLobby);
		}
		
		public final function as_buttonBlinking() : void
		{
			buttonBlinking();
		}
		
		public final function as_compareBasketVisibility() : void
		{
			compareBasketVisibility();
		}
		
		public final function as_setStaticData(data:Object) : void
		{
			setStaticData(new ModsListStaticDataVO(data));
		}
		
		protected function buttonBlinking() : void
		{
			var message:String = "as_buttonBlinking" + Errors.ABSTRACT_INVOKE;
			DebugUtils.LOG_ERROR(message);
			throw new AbstractException(message);
		}
		
		protected function compareBasketVisibility() : void
		{
			var message:String = "as_compareBasketVisibility" + Errors.ABSTRACT_INVOKE;
			DebugUtils.LOG_ERROR(message);
			throw new AbstractException(message);
		}
		
		protected function setStaticData(data:ModsListStaticDataVO) : void
		{
			var message:String = "as_setStaticData" + Errors.ABSTRACT_INVOKE;
			DebugUtils.LOG_ERROR(message);
			throw new AbstractException(message);
		}
		
		public function getTargetButton() : DisplayObject 
		{
			return this;
		}
		
		public function getHitArea() : DisplayObject 
		{
			return this;
		}
	}
}