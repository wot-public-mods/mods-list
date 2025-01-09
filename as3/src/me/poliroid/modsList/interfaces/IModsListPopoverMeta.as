// SPDX-License-Identifier: MIT
// Copyright (c) 2015-2025 Andrii Andrushchyshyn

package me.poliroid.modsList.interfaces 
{

	import flash.events.IEventDispatcher;

	public interface IModsListPopoverMeta extends IEventDispatcher
	{

		function getModsListS() : void;

		function invokeModificationS(id:Number) : void;

	}
}
