// SPDX-License-Identifier: MIT
// Copyright (c) 2015-2025 Andrii Andrushchyshyn

package me.poliroid.modsList.data 
{

	import net.wg.data.daapi.base.DAAPIDataClass;

	public class ModsListStaticDataVO  extends DAAPIDataClass
	{
		public var buttonLinkage:String = "";

		public var titleLabel:String = "";

		public var descriptionLabel:String = "";

		public var closeButtonVisible:Boolean = false;

		public function ModsListStaticDataVO(data:Object)
		{
			super(data);
		}
	}
}
