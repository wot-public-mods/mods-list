// SPDX-License-Identifier: MIT
// Copyright (c) 2015-2025 Andrii Andrushchyshyn

package me.poliroid.modsList.data 
{

	import net.wg.data.constants.Errors;
	import net.wg.data.daapi.base.DAAPIDataClass;
	import net.wg.infrastructure.interfaces.entity.IDisposable;

	import me.poliroid.modsList.data.ModsListItemRendererVO;

	public class ModsListModsVO extends DAAPIDataClass
	{
		private static const MODSLIST_FIELD_NAME:String = "mods";

		public var modsList:Array = null;

		public function ModsListModsVO(data:Object) 
		{
			super(data);
		}

		override protected function onDataWrite(name:String, data:Object) : Boolean
		{
			if(name == MODSLIST_FIELD_NAME)
			{
				var mods:Array = data as Array;
				App.utils.asserter.assertNotNull(mods, data + Errors.CANT_NULL);
				modsList = [];
				for each(var mod:Object in mods)
				{
					modsList.push(new ModsListItemRendererVO(mod));
				}
				return false;
			}
			return super.onDataWrite(name, data);
		}

		override protected function onDispose() : void
		{
			if(modsList != null)
			{
				for each(var mod:IDisposable in modsList)
				{
					mod.dispose();
				}
				modsList.splice(0, modsList.length);
				modsList = null;
			}
			super.onDispose();
		}
	}
}
