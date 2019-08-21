﻿package com.poliroid.gui.lobby.modsList 
{

	import scaleform.clik.constants.InvalidationType;
	import scaleform.clik.data.DataProvider;
	import scaleform.clik.events.ListEvent;
	import scaleform.clik.controls.ScrollingList;

	import net.wg.gui.components.controls.ScrollBar;
	import net.wg.gui.components.popovers.PopOver;

	import com.poliroid.gui.lobby.modsList.data.ModsListModsVO;
	import com.poliroid.gui.lobby.modsList.data.ModsListItemRendererVO;
	import com.poliroid.gui.lobby.modsList.data.ModsListStaticDataVO;
	import com.poliroid.gui.lobby.modsList.interfaces.IModsListPopoverMeta
	import com.poliroid.gui.lobby.modsList.interfaces.impl.ModsListPopoverMeta

	public class ModsListPopover extends ModsListPopoverMeta implements IModsListPopoverMeta 
	{

		private static const RENDERER_HEIGHT:int = 75;

		private static const BOTTOM_OFFSET:int = 10;

		private static const MAX_ITEMS_IN_LIST:int = 8;

		public var modsList:ScrollingList = null;

		public var scrollBar:ScrollBar = null;

		public function ModsListPopover() 
		{
			super();
		}

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
