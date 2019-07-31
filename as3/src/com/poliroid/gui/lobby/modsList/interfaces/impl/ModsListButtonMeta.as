package com.poliroid.gui.lobby.modsList.interfaces.impl 
{
	import net.wg.data.constants.Errors;
	import net.wg.infrastructure.base.AbstractView;
	import net.wg.infrastructure.exceptions.AbstractException;
	
	import com.poliroid.gui.lobby.modsList.data.ModsListStaticDataVO;
	
	public class ModsListButtonMeta extends AbstractView
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
		
		public final function as_onButtonInvalid() : void
		{
			onButtonInvalid();
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
		
		protected function onButtonInvalid() : void
		{
			var message:String = "as_onButtonInvalid" + Errors.ABSTRACT_INVOKE;
			DebugUtils.LOG_ERROR(message);
			throw new AbstractException(message);
		}
		
		protected function setStaticData(data:ModsListStaticDataVO) : void
		{
			var message:String = "as_setStaticData" + Errors.ABSTRACT_INVOKE;
			DebugUtils.LOG_ERROR(message);
			throw new AbstractException(message);
		}
	}
}