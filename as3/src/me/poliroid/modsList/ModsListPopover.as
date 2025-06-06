﻿// SPDX-License-Identifier: MIT
// Copyright (c) 2015-2025 Andrii Andrushchyshyn

package me.poliroid.modsList 
{

	import scaleform.clik.constants.InvalidationType;
	import scaleform.clik.data.DataProvider;
	import scaleform.clik.events.ListEvent;
	import scaleform.clik.controls.ScrollingList;

	import net.wg.gui.components.controls.ScrollBar;
	import net.wg.gui.components.popovers.PopOver;

	import me.poliroid.modsList.data.ModsListModsVO;
	import me.poliroid.modsList.data.ModsListItemRendererVO;
	import me.poliroid.modsList.data.ModsListStaticDataVO;
	import me.poliroid.modsList.interfaces.IModsListPopoverMeta
	import me.poliroid.modsList.interfaces.impl.ModsListPopoverMeta

	public class ModsListPopover extends ModsListPopoverMeta implements IModsListPopoverMeta 
	{

		private static const RENDERER_HEIGHT:int = 75;

		private static const BOTTOM_OFFSET:int = 10;

		private static const MAX_ITEMS_IN_LIST:int = 8;

		public var modsList:ScrollingList = null;

		public var scrollBar:ScrollBar = null;

		override protected function onDispose() : void 
		{
			modsList.removeEventListener(ListEvent.ITEM_CLICK, handleModsListItemClick);
			super.onDispose();
		}

		override protected function configUI() : void 
		{
			super.configUI();
			modsList.addEventListener(ListEvent.ITEM_CLICK, handleModsListItemClick);
			getModsListS();
		}

		override protected function draw() : void
		{
			super.draw();
			if(isInvalid(InvalidationType.DATA))
			{
				var modsListHeight:int;
				var listItemsCount:int = modsList.dataProvider.length;

				if (listItemsCount > MAX_ITEMS_IN_LIST) 
				{
					scrollBar.visible = true;
					modsListHeight = MAX_ITEMS_IN_LIST * RENDERER_HEIGHT;
				}
				else
				{
					scrollBar.visible = false;
					modsListHeight = listItemsCount * RENDERER_HEIGHT;
				}

				modsList.validateNow();
				modsList.rowCount = listItemsCount;
				modsList.height = modsListHeight;
				height = modsListHeight + BOTTOM_OFFSET;
			}
		}

		override protected function setStaticData(data:ModsListStaticDataVO) : void 
		{
			var popoverWrapper:PopOver = PopOver(wrapper);
			popoverWrapper.title = data.titleLabel;
			popoverWrapper.isCloseBtnVisible = data.closeButtonVisible;
		}

		override protected function setModsData(data:ModsListModsVO) : void 
		{
			modsList.dataProvider = new DataProvider(data.modsList);
			invalidateData();
		}

		private function handleModsListItemClick(event:ListEvent): void 
		{
			var modID:Number = (event.itemData as ModsListItemRendererVO).id;
			invokeModificationS(modID);
			App.popoverMgr.hide();
		}
	}
}
