// SPDX-License-Identifier: MIT
// Copyright (c) 2015-2025 Andrii Andrushchyshyn

package me.poliroid.modsList.interfaces 
{

	import flash.events.IEventDispatcher;

	public interface IModsListButtonMeta extends IEventDispatcher
	{

		function onButtonClickS(isInLobby:Boolean) : void;

	}
}
