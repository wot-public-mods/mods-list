package com.poliroid.views.lobby 
{

	import scaleform.clik.data.DataProvider;
	import scaleform.clik.events.ListEvent;
	import net.wg.infrastructure.base.SmartPopOverView;
	import net.wg.infrastructure.interfaces.IWrapper;
	import net.wg.gui.components.popovers.PopOver;
	import scaleform.clik.controls.ScrollingList;
	
	public class ModsListPopover extends SmartPopOverView 
	{
		
		public var getModsListS: Function = null;
		public var callModS: Function = null;
		public var clearAlertS: Function = null;
		public var modsList:ScrollingList = null;
		
		public function ModsListPopover() 
		{
			super();
		}
		
		override public function set wrapper(_wrapper:IWrapper) : void
		{
			super.wrapper = _wrapper;
			var popoverWrapper:PopOver = PopOver(wrapper);
			popoverWrapper.isCloseBtnVisible = true;
		}
		
		override protected function onPopulate() : void 
		{
			super.onPopulate();
			modsList.addEventListener(ListEvent.ITEM_CLICK, handleItemClick);
		}
		
		override protected function onDispose() : void 
		{
			super.onDispose();
			modsList.removeEventListener(ListEvent.ITEM_CLICK, handleItemClick);
		}
		
		override protected function configUI() : void 
		{
			super.configUI();
			getModsListS();
		}
		
		private function handleItemClick(event:ListEvent): void 
		{
			var target:ModsListItemRendererUI = event.itemRenderer as ModsListItemRendererUI;
			callModS(target._id);
			clearAlertS(target._id);
			App.popoverMgr.hide();			
		}
		
		public function as_setTitleText(titleText:String) : void 
		{
			var popoverWrapper:PopOver = PopOver(wrapper);
			popoverWrapper.title = titleText;
		}
		
		public function as_setData(data:Array): void 
		{
			if (!data || data.length < 1) 
			{
				data = [{
					id: "none", 
					name: " ", 
					description: " ", 
					icon: null, 
					enabled: false, 
					alert: false
				}];
			}
			
			modsList.height = data.length * 70;
			modsList.dataProvider = new DataProvider(data);
			modsList.validateNow();
			height = modsList.height + 10;
		}
	}
}
