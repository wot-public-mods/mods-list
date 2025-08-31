// SPDX-License-Identifier: MIT
// Copyright (c) 2015-2025 Andrii Andrushchyshyn

package me.poliroid.modsList 
{

    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.events.Event;

    import net.wg.app.iml.base.StageResizeEvent;
    import net.wg.data.Aliases;
    import net.wg.data.constants.generated.LAYER_NAMES;
    import net.wg.gui.components.containers.inject.GFInjectComponent;
    import net.wg.gui.components.containers.MainViewContainer;
    import net.wg.gui.login.impl.LoginPage;
    import net.wg.infrastructure.base.AbstractView;
    import net.wg.infrastructure.events.LoaderEvent;
    import net.wg.infrastructure.interfaces.IManagedContent;
    import net.wg.infrastructure.interfaces.ISimpleManagedContainer;
    import net.wg.infrastructure.interfaces.IView;
    import net.wg.infrastructure.managers.impl.ContainerManagerBase;
    import net.wg.infrastructure.events.LifeCycleEvent;

    public class ModsListButton extends AbstractView
    {

        public var _buttonInject:GFInjectComponent = null;

        private static const INJECTOR_ALIAS:String = 'ModsListButtonInject';

        override protected function configUI() : void 
        {
            super.configUI();
            var viewContainer:MainViewContainer = _getContainer(LAYER_NAMES.VIEWS) as MainViewContainer;
            if (viewContainer != null)
            {
                var num:int = viewContainer.numChildren;
                for (var idx:int = 0; idx < num; ++idx)
                {
                    var view:IView = viewContainer.getChildAt(idx) as IView;
                    if (view != null)
                    {
                        processView(view);
                    }
                }
                var topmostView:IManagedContent = viewContainer.getTopmostView();
                if (topmostView != null)
                {
                    viewContainer.setFocusedView(topmostView);
                }
            }
            App.instance.stage.addEventListener(StageResizeEvent.STAGE_RESIZE, onStageResize);
            (App.containerMgr as ContainerManagerBase).loader.addEventListener(LoaderEvent.VIEW_LOADED, onViewLoaded, false, 0, true);
        }

        override protected function onDispose() : void 
        {
            _buttonInject = null;
            (App.containerMgr as ContainerManagerBase).loader.removeEventListener(LoaderEvent.VIEW_LOADED, onViewLoaded);
            App.instance.stage.removeEventListener(StageResizeEvent.STAGE_RESIZE, onStageResize);
            super.onDispose();
        }

        private function _getContainer(containerName:String) : ISimpleManagedContainer
        {
            return App.containerMgr.getContainer(LAYER_NAMES.LAYER_ORDER.indexOf(containerName))
        }

        private function onStageResize(e:StageResizeEvent) : void
        {
            updateInject();
        }

        // this needs for valid Focus and Position in Login Window 
        override protected function nextFrameAfterPopulateHandler() : void 
        {
            super.nextFrameAfterPopulateHandler();
            if (parent != App.instance)
            {
                (App.instance as MovieClip).addChild(this);
            }
        }

        private function onViewLoaded(event:LoaderEvent) : void 
        {
            var view:IView = event.view as IView;
            processView(view);
        }

        private function processView(view:IView) : void 
        {
            var alias:String = view.as_config.alias;
            if (alias == Aliases.LOGIN)
            {
                createInject(view);
                updateInject();
            }
        }

        private function createInject(view:IView) : void
        {
            if (_buttonInject)
                return;
            const loginPage = (view as LoginPage);
            _buttonInject = new GFInjectComponent();
            _buttonInject.setManageSize(true);
            loginPage.addChild(DisplayObject(_buttonInject));
            loginPage.addEventListener(LifeCycleEvent.ON_BEFORE_DISPOSE, _handleLoginPageDispose);
            registerFlashComponentS(_buttonInject, INJECTOR_ALIAS);
        }

        private function destroyInject() : void
        {
            if (!_buttonInject)
                return;
            unregisterFlashComponentS(INJECTOR_ALIAS);
            if (_buttonInject.parent)
                _buttonInject.parent.removeChild(_buttonInject);
            _buttonInject = null;
        }

        private function updateInject() : void
        {
            if (_buttonInject)
            {
                const targetWidth:int = int(150 / App.appScale);
                const targetHeight:int = int(150 / App.appScale);
                _buttonInject.x = App.appWidth - targetWidth;
                _buttonInject.y = App.appHeight - targetHeight;
                _buttonInject.setSize(targetWidth, targetHeight);
            }
        }

        private function _handleLoginPageDispose(event:LifeCycleEvent) : void
        {
            destroyInject();
        }
    }
}
