// SPDX-License-Identifier: MIT
// Copyright (c) 2015-2025 Andrii Andrushchyshyn

package me.poliroid.modsList.controls 
{

	import flash.events.MouseEvent;
	import flash.text.TextField;

	import org.idmedia.as3commons.util.StringUtils;

	import scaleform.clik.constants.InvalidationType;

	import net.wg.gui.components.assets.NewIndicator;
	import net.wg.gui.components.controls.Image;
	import net.wg.gui.components.controls.SoundListItemRenderer;

	import me.poliroid.modsList.data.ModsListItemRendererVO;

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

			if(StringUtils.isNotEmpty(model.tooltipLabel))
			{
				App.toolTipMgr.showComplex(model.tooltipLabel);
			}
		}

		override protected function handleMouseRollOut(event:MouseEvent) : void 
		{
			super.handleMouseRollOut(event);
			App.toolTipMgr.hide();
			
		}

		override public function setData(data:Object) : void 
		{
			if (data == null)
			{
				return;
			}

			super.setData(data);

			model = ModsListItemRendererVO(data);
			invalidateSize();
		}

		override protected function onDispose(): void
		{

			if (alertMC)
			{
				alertMC.dispose()
			}

			if (modIcon)
			{
				modIcon.dispose();
			}

			modNameTF = null;
			alertMC = null;
			modIcon = null;
			model = null;

			super.onDispose();
		}

		override protected function draw() : void 
		{
			super.draw();

			if(model == null)
			{
				return;
			}

			if (isInvalid(InvalidationType.SIZE)) 
			{
				// this won't work correctly
				enabled = model.isEnabled;

				// this using instead 
				// enabled = model.isEnabled
				// and does not working setState(state)
				if (!model.isEnabled)
				{
					gotoAndPlay('disabled');
				}

				modNameTF.text = model.nameLabel;

				if (StringUtils.isNotEmpty(model.icon))
				{
					modIcon.source = model.icon;
				}

				alertMC.visible = model.isAlerting;
			}
		}
	}
}
