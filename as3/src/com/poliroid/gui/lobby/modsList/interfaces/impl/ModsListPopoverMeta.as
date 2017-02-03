package com.poliroid.gui.lobby.modsList.interfaces.impl 
{
	
	import net.wg.data.constants.Errors;
	import net.wg.infrastructure.base.SmartPopOverView;
	import net.wg.infrastructure.exceptions.AbstractException;
	
	import com.poliroid.gui.lobby.modsList.data.ModsListModsVO;
	import com.poliroid.gui.lobby.modsList.data.ModsListStaticDataVO;
	
	public class ModsListPopoverMeta extends SmartPopOverView
	{
		
		public var invokeModification:Function;
		
		public var getModsList:Function;
		
		public function ModsListPopoverMeta() 
		{	
			super();
		}
		
		public function invokeModificationS(id:Number) : void
		{
			App.utils.asserter.assertNotNull(invokeModification, "invokeModification" + Errors.CANT_NULL);
			invokeModification(id);
		}

		public function getModsListS() : void
		{
			App.utils.asserter.assertNotNull(getModsList, "getModsList" + Errors.CANT_NULL);
			getModsList();
		}
		
		public final function as_setStaticData(data:Object) : void
		{
			setStaticData(new ModsListStaticDataVO(data));
		}
		
		public final function as_setModsData(data:Object) : void
		{
			var items:ModsListModsVO = new ModsListModsVO(data);
			setModsData(items);
			items.dispose();
		}
		
		protected function setStaticData(data:ModsListStaticDataVO) : void
		{
			var message:String = "as_setStaticData" + Errors.ABSTRACT_INVOKE;
			DebugUtils.LOG_ERROR(message);
			throw new AbstractException(message);
		}
		
		protected function setModsData(data:ModsListModsVO) : void
		{
			var message:String = "as_setModsData" + Errors.ABSTRACT_INVOKE;
			DebugUtils.LOG_ERROR(message);
			throw new AbstractException(message);
		}
	}
}