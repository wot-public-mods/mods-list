// SPDX-License-Identifier: MIT
// Copyright (c) 2015-2026 Andrii Andrushchyshyn

package me.poliroid.modsList.data 
{

    import net.wg.data.daapi.base.DAAPIDataClass;

    public class ModsListStaticDataVO  extends DAAPIDataClass
    {
        public var titleLabel:String = "";

        public var tooltipLabel:String = "";

        public var closeButtonVisible:Boolean = false;

        public function ModsListStaticDataVO(data:Object)
        {
            super(data);
        }
    }
}
