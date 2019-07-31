package com.poliroid.gui.lobby.modsList.interfaces 
{
	import flash.events.IEventDispatcher;
	
	public interface IModsListButtonMeta extends IEventDispatcher
	{
		
		function onButtonClickS(isInLobby:Boolean) : void;
		
	}
}