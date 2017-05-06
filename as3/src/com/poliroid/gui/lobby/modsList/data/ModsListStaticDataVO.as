package com.poliroid.gui.lobby.modsList.data 
{
	import net.wg.data.daapi.base.DAAPIDataClass;
	
	public class ModsListStaticDataVO  extends DAAPIDataClass
	{
		public var titleLabel:String = "";
		
		public var descriptionLabel:String = "";
		
		public var closeButtonVisible:Boolean = false;
		
		public function ModsListStaticDataVO(data:Object)
		{
			super(data);
		}
	}
}