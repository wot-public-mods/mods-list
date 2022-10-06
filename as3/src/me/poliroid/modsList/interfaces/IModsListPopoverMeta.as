package me.poliroid.modsList.interfaces 
{

	import flash.events.IEventDispatcher;

	public interface IModsListPopoverMeta extends IEventDispatcher
	{

		function getModsListS() : void;

		function invokeModificationS(id:Number) : void;

	}
}
