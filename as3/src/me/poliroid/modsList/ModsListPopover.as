// SPDX-License-Identifier: MIT
// Copyright (c) 2015-2025 Andrii Andrushchyshyn

package me.poliroid.modsList
{

    import scaleform.clik.constants.InvalidationType;
    import scaleform.clik.data.DataProvider;
    import scaleform.clik.events.ListEvent;
    import scaleform.clik.controls.ScrollingList;

    import net.wg.data.constants.Linkages;
    import net.wg.gui.components.controls.ScrollBar;
    import net.wg.gui.components.popovers.PopOver;
    import net.wg.infrastructure.base.SmartPopOverView;

    import me.poliroid.modsList.data.ModsListModsVO;
    import me.poliroid.modsList.data.ModsListItemRendererVO;
    import me.poliroid.modsList.data.ModsListStaticDataVO;

    public class ModsListPopover extends SmartPopOverView
    {

        private static const RENDERER_HEIGHT:int = 75;

        private static const BOTTOM_OFFSET:int = 10;

        private static const MAX_ITEMS_IN_LIST:int = 8;

        public var modsList:ScrollingList = null;

        public var scrollBar:ScrollBar = null;

        public var invokeModification:Function;

        public var getModsList:Function;

        // bcs SWC in very good condition
        public function get wrapperLinkage() : String 
        {
            return Linkages.SMART_POPOVER;
        }

        override protected function configUI() : void 
        {
            super.configUI();
            modsList.addEventListener(ListEvent.ITEM_CLICK, handleModsListItemClick);
            getModsList();
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

        override protected function onDispose() : void 
        {
            modsList.removeEventListener(ListEvent.ITEM_CLICK, handleModsListItemClick);
            super.onDispose();
        }

        public final function as_setStaticData(data:Object) : void
        {
            var vo:ModsListStaticDataVO = new ModsListStaticDataVO(data);
            var popoverWrapper:PopOver = PopOver(wrapper);
            popoverWrapper.title = vo.titleLabel;
            popoverWrapper.isCloseBtnVisible = vo.closeButtonVisible;
        }

        public final function as_setModsData(data:Object) : void
        {
            var vo:ModsListModsVO = new ModsListModsVO(data);
            modsList.dataProvider = new DataProvider(vo.modsList);
            invalidateData();
            vo.dispose();
        }

        private function handleModsListItemClick(event:ListEvent): void 
        {
            var modID:Number = (event.itemData as ModsListItemRendererVO).id;
            invokeModification(modID);
            App.popoverMgr.hide();
        }
    }
}
