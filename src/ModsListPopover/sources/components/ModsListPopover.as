package components {
	
	import net.wg.infrastructure.base.SmartPopOverView;
	
	import net.wg.gui.components.controls.LabelControl;
	import scaleform.clik.controls.ScrollingList;
	import scaleform.clik.data.DataProvider;
	import scaleform.clik.events.ListEvent;
	import flash.text.TextField;
	
	public class ModsListPopover extends SmartPopOverView {
		
		public var getModsListS:Function = null;
		public var callModS:Function = null;
		public var clearAlertS:Function = null;
		private var _data:Array;
		private var _list:ScrollingList;
		private var _headerText:TextField = null;
		private var titleText:String = 'Список модификаций';
		
		public function ModsListPopover() {
			super();
		}

		override protected function configUI(): void {
			super.configUI();
			try {

				this.width = 280;
				this.height = 65;

				this._headerText = new TextField();
				this._headerText.x = 15;
				this._headerText.y = 15;
				this._headerText.width = 250;
				this._headerText.height = 30;
				this._headerText.selectable = false;
				this._headerText.htmlText = '<font size="18" color="#DDDDD0" face="$FieldFont"><b>' + this.titleText + '</b></font>';
				this.addChild(this._headerText);
				
				this._list = App.utils.classFactory.getComponent("ScrollingList", ScrollingList);
				this._list.x = 0;
				this._list.y = 55;
				this._list.width = 280;
				this._list.margin = 0;
				this._list.itemRenderer = ModItemRenderer;
				this._list.itemRendererInstanceName = "";
				this._list.rowHeight = 70;
				this._list.rowCount = 4;
				this._list.enabled = true;
				this._list.visible = true;
				this._list.scrollBar = "";
				this._list.wrapping = "normal";
				this.addChild(this._list);
				
				this.getModsListS();
				
				this._list.addEventListener(ListEvent.ITEM_CLICK, this.handleItemClick);

				
			} catch(err: Error) {
				DebugUtils.LOG_ERROR("ModsListPopover::configUI " + err.getStackTrace());
			}
		}
		
		private function handleItemClick(event:ListEvent):void {
			var target:ModItemRenderer = event.itemRenderer as ModItemRenderer;
			this.callModS(target.id);
			this.clearAlertS(target.id);
			App.popoverMgr.hide();			
		}
		
		public function as_setTitleText(titleText:String) : void {
			this.titleText = titleText;
			if (this._headerText != null) {
				this._headerText.htmlText = '<font size="18" color="#DDDDD0" face="$FieldFont"><b>' + this.titleText + '</b></font>';
			}
		}
		
		public function as_setData(data:Array): void {
			try {

				this._data = data;
				this.width = 280;
				this.height = this._list.y + data.length * 70 + 10;

				this._list.rowCount = data.length;
				this._list.dataProvider = new DataProvider(data);
				this._list.validateNow();

			} catch(err:Error) {
				DebugUtils.LOG_ERROR("ModsListPopover::as_setData " + err.getStackTrace());
			}			
		}
	}
}
