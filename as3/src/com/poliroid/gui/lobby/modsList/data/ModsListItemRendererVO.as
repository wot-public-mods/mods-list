package com.poliroid.gui.lobby.modsList.data 
{
	import net.wg.data.daapi.base.DAAPIDataClass;
	
	public class ModsListItemRendererVO extends DAAPIDataClass
	{	
		public var id:Number = 0;
		
		public var isEnabled:Boolean = false;
		
		public var isAlerting:Boolean = false;
		
		public var nameLabel:String = "";
		
		public var descriptionLabel:String = "";
		
		public var icon:String = "";
		
		public function ModsListItemRendererVO(data:Object)
		{
			super(data);
		}
	}
}