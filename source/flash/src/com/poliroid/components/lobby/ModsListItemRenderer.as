package com.poliroid.components.lobby 
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import scaleform.clik.constants.InvalidationType;
	import net.wg.gui.components.controls.SoundListItemRenderer;
	
	public class ModsListItemRenderer extends SoundListItemRenderer 
	{
		
		public var alertMC: MovieClip = null;
		public var backgroundMC: MovieClip = null;
		public var modIconMC: MovieClip = null;
		public var modNameTF: TextField = null;
		
		public var _id: String = "";
		
		protected var _descr: String = "";
		protected var _hovered: Boolean = false;
		protected var _enabled: Boolean = false;
		
		protected static const BACKGROUND_VALIDATION: String = "background";
		
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
			alertMC  = null;
			backgroundMC  = null;
			modIconMC  = null;
			modNameTF  = null;
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
			_hovered = true;
			invalidate(BACKGROUND_VALIDATION);
			App.toolTipMgr.show(_descr);
		}
		
		override protected function handleMouseRollOut(event:MouseEvent) : void 
		{
			super.handleMouseRollOut(event);
			_hovered = false;
			invalidate(BACKGROUND_VALIDATION);
			App.toolTipMgr.hide();
		}
		
		override protected function draw() : void 
		{
		
			if (isInvalid(InvalidationType.DATA)) 
				setup(); 	
			
			if (!data)
				visible = false;
				
			super.draw();
			
			if (isInvalid(BACKGROUND_VALIDATION)) 
			{
				if (!_enabled) {
					backgroundMC.gotoAndStop("disabled");
				} else if (_hovered) {
					backgroundMC.gotoAndStop("hovered");
				} else {
					backgroundMC.gotoAndStop("normal");
				}
			}
		}
		
		private function setup() : void 
		{
			if (!data)
				return;
			
			_enabled = data.enabled;
			_id = data.id;
			_descr = data.description;
			
			alertMC.visible = data.alert;
			modNameTF.text = data.name;
			modNameTF.alpha = _enabled ? 1 : 0.9;
			modNameTF.textColor = _enabled ? 0xDDDDD0 : 0xCCCCCC;
			
			invalidate(BACKGROUND_VALIDATION);
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function (event:Event){
				modIconMC.addChild(loader);
				modIconMC.width = modIconMC.height = 50;
			});
			
			if (data.icon)
				// use "../../" to premature up from "gui/flash" directory
				loader.load(new URLRequest("../../" + data.icon));
		}
	}
}