package com.poliroid.gui.lobby.modsList.controls 
{
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import org.idmedia.as3commons.util.StringUtils;
	
	import scaleform.clik.constants.InvalidationType;
	
	import net.wg.gui.components.assets.NewIndicator;
	import net.wg.gui.components.controls.Image;
	import net.wg.gui.components.controls.SoundListItemRenderer;
	
	import com.poliroid.gui.lobby.modsList.data.ModsListItemRendererVO;
	
	public class ModsListItemRenderer extends SoundListItemRenderer
	{
		
		public var alertMC:NewIndicator = null;
		
		public var modIcon:Image = null;
		
		public var modNameTF:TextField = null;
		
		private var model:ModsListItemRendererVO = null;
		
		public function ModsListItemRenderer() 
		{
			super();
			mouseEnabledOnDisabled = false;
		}
		
		override protected function handleMouseRollOver(event:MouseEvent) : void 
		{
			super.handleMouseRollOver(event);
			
			if(StringUtils.isNotEmpty(model.descriptionLabel))
				App.toolTipMgr.show(model.descriptionLabel);
		}
		
		override protected function handleMouseRollOut(event:MouseEvent) : void 
		{
			super.handleMouseRollOut(event);
			App.toolTipMgr.hide();
		}
		
		override public function setData(data:Object) : void 
		{
			if (data == null) 
				return;
			
			super.setData(data);
			
			model = ModsListItemRendererVO(data);
			invalidateSize();
		}
		
		override protected function onDispose(): void
		{
			
			if (alertMC)
				alertMC.dispose()
			
			if (modIcon) 
				modIcon.dispose();
				
			modNameTF = null;
			alertMC = null;
			modIcon = null;
			model = null;
			
			super.onDispose();
		}
		
		override protected function draw() : void 
		{
			super.draw();
			if(model != null)
			{
				if (isInvalid(InvalidationType.SIZE)) 
				{
					// this wont work correctly
					enabled = model.isEnabled;
					
					// use instead 
					// enabled = model.isEnabled
					// and dosnt working setState(state)
					if (!model.isEnabled)
						gotoAndPlay('disabled');
					
					modNameTF.text = model.nameLabel;
					
					if (StringUtils.isNotEmpty(model.icon))
						modIcon.source = model.icon;
					
					alertMC.visible = model.isAlerting;
				}
			}
		}
	}
}