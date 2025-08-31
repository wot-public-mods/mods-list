// SPDX-License-Identifier: MIT
// Copyright (c) 2015-2025 Andrii Andrushchyshyn

package me.poliroid.modsList.data 
{

	import net.wg.data.daapi.base.DAAPIDataClass;

	public class ModsListItemRendererVO extends DAAPIDataClass
	{
		public var id:Number = 0;

		public var isEnabled:Boolean = false;

		public var isAlerting:Boolean = false;

		public var nameLabel:String = "";

		public var tooltipLabel:String = "";

		public var icon:String = "";

		public function ModsListItemRendererVO(data:Object)
		{
			super(data);
		}
	}
}
