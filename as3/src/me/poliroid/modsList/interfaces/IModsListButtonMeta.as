package me.poliroid.modsList.interfaces 
{

	import flash.events.IEventDispatcher;

	public interface IModsListButtonMeta extends IEventDispatcher
	{

		function onButtonClickS(isInLobby:Boolean) : void;

	}
}
