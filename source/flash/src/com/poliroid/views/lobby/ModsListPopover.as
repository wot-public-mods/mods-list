package com.poliroid.views.lobby 
{
	import flash.text.TextField;
	import flash.display.MovieClip;
	
	import scaleform.clik.controls.ScrollingList;
	import scaleform.clik.data.DataProvider;
	import scaleform.clik.events.ListEvent;
	import net.wg.infrastructure.base.SmartPopOverView;
	import net.wg.infrastructure.interfaces.IWrapper;
	import net.wg.gui.components.popOvers.PopOver;
	
	import com.poliroid.components.lobby.ModsListItemRenderer;
	
	public class ModsListPopover extends SmartPopOverView
	{
		public var getModsListS: Function = null;
		public var callModS: Function = null;
		public var clearAlertS: Function = null;
		
		protected var _list: ScrollingList = null;
		
		public function ModsListPopover() : void 
		{
			super();
		}
		
		override public function set wrapper(_wrapper:IWrapper) : void
		{
			super.wrapper = _wrapper;
			var popoverWrapper:PopOver = PopOver(wrapper);
			popoverWrapper.isCloseBtnVisible = true;
		}
		
		override protected function configUI() : void {
			
			super.configUI();
			
			width = 280;
			height = 65;
			
			_list = App.utils.classFactory.getComponent("ScrollingList", ScrollingList);
			_list.x = 0;
			_list.y = 0;
			_list.width = 280;
			_list.margin = 0;
			_list.itemRenderer = ModsListItemRenderer;
			_list.itemRendererInstanceName = "";
			_list.rowHeight = 70;
			_list.enabled = true;
			_list.visible = true;
			_list.scrollBar = "";
			_list.wrapping = "normal";
			
			addChild(_list);
			
			getModsListS();
			
			_list.addEventListener(ListEvent.ITEM_CLICK, handleItemClick);
			
		}
		
		private function handleItemClick(event:ListEvent): void 
		{
			var target:ModsListItemRenderer = event.itemRenderer as ModsListItemRenderer;
			callModS(target._id);
			clearAlertS(target._id);
			App.popoverMgr.hide();			
		}
		
		public function as_setTitleText(titleText:String) : void 
		{
			var popoverWrapper:PopOver = PopOver(wrapper);
			popoverWrapper.title = App.utils.locale.makeString(titleText);
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
			
			if (_list) 
			{
				height = _list.y + data.length * 70 + 10;
				_list.rowCount = data.length;
				_list.dataProvider = new DataProvider(data);
				_list.validateNow();
			}
		}
	}
}
