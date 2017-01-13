package com.poliroid.components.lobby 
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import scaleform.clik.constants.InvalidationType;
	import net.wg.gui.components.controls.SoundListItemRenderer;
	
	public class ModsListItemRenderer extends SoundListItemRenderer 
	{
		
		public var alertMC: MovieClip = null;
		public var modIconMC: MovieClip = null;
		public var modNameTF: TextField = null;
		
		public var _id: String = "";
		protected var _descr: String = "";
		
		public function ModsListItemRenderer() : void 
		{
			super();
		}
		
		override protected function configUI() : void 
		{
			super.configUI();
			if (data) 
				setup();
		}
		
		override protected function onDispose(): void
		{
			alertMC = null;
			modIconMC = null;
			modNameTF = null;
			super.onDispose();
		}
		
		override public function setData(newData:Object) : void 
		{
			if (newData == null) 
				return;
			data = newData;
			invalidateData();
		}
		
		override protected function handleMouseRollOver(event:MouseEvent) : void 
		{
			super.handleMouseRollOver(event);
			App.toolTipMgr.show(_descr);
		}
		
		override protected function handleMouseRollOut(event:MouseEvent) : void 
		{
			super.handleMouseRollOut(event);
			App.toolTipMgr.hide();
		}
		
		override protected function draw() : void 
		{
		
			if (isInvalid(InvalidationType.DATA)) 
				setup(); 	
			
			if (!data)
				visible = false;
				
			super.draw();
		}
		
		private function setup() : void 
		{
			if (!data)
				return;
			
			enabled = data.enabled;
			
			_id = data.id;
			_descr = data.description;
			
			alertMC.visible = data.alert;
			
			modNameTF.text = data.name;
			modNameTF.alpha = data.enabled ? 1 : 0.9;
			modNameTF.textColor = data.enabled ? 0xDDDDD0 : 0xCCCCCC;
			
			if (data.icon) {
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function (event:Event){
					modIconMC.addChild(loader);
					modIconMC.height = modIconMC.width = 50;
				});
				// use "../../" to premature up from "gui/flash" directory
				loader.load(new URLRequest("../../" + data.icon));
				
				var shadow:DropShadowFilter = new DropShadowFilter(0, 0, 0, 0.7, 3, 3, 3, 8);
				var greyscale:ColorMatrixFilter = new ColorMatrixFilter([0.25, 0.25, 0.25, 0, 0, 0.25, 0.25, 0.25, 0, 0, 0.25, 0.25, 0.25, 0, 0, 0, 0, 0, 1, 0]);
				modIconMC.filters = data.enabled ? [shadow] : [greyscale, shadow];
				modIconMC.alpha = data.enabled ? 1 : 0.8;
			}
				
		}
	}
}