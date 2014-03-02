package ssen.mvc.impl.context {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Stage;
import flash.events.Event;

import mx.core.UIComponent;

import ssen.mvc.IContextView;

internal class ViewCatcher {
	private var _run:Boolean;
	private var view:DisplayObjectContainer;
	private var stage:Stage;
	private var viewInjector:ViewInjector;
	private var contextView:IContextView;

	public function ViewCatcher(viewInjector:ViewInjector, contextView:IContextView) {
		this.viewInjector=viewInjector;
		this.contextView=contextView;
	}

	public function dispose():void {
		if (_run) {
			stop();
		}

		viewInjector=null;
	}

	public function start(view:IContextView):void {
		var stage:Stage;
		if (view is UIComponent) {
			stage=UIComponent(view).systemManager.stage;
		} else {
			stage=DisplayObjectContainer(view).stage;
		}

		this.view=view as DisplayObjectContainer;
		this.stage=stage;
		this.view.addEventListener(Event.ADDED, added, true);
		this.stage.addEventListener(Event.ADDED_TO_STAGE, globalAdded, true);

		_run=true;
	}

	private function globalAdded(event:Event):void {
		var view:DisplayObject=event.target as DisplayObject;

		if (viewInjector.hasMapping(view) && viewInjector.isGlobal(view)) {
			viewInjector.injectInto(view);
		}
	}

	private function added(event:Event):void {
		var view:DisplayObject=event.target as DisplayObject;
		var isChild:Boolean=isMyChild(view);

		if (view is IContextView && isChild) {
			var contextView:IContextView=view as IContextView;

			if (!contextView.contextInitialized) {
				if (!contextView.contextInitialized) {
					contextView.initialContext(context);
				}
			}
		} else if (viewInjector.hasMapping(view) && !viewInjector.isGlobal(view) && isChild) {
			viewInjector.injectInto(view);
		}
	}

	private function isMyChild(view:DisplayObject):Boolean {
		var parent:DisplayObjectContainer=view.parent;

		while (true) {
			if (parent is IContextView) {
				if (parent == this.contextView) {
					return true;
				} else {
					return false;
				}
			}

			parent=parent.parent;

			if (parent === null) {
				break;
			}
		}

		return false;
	}

	public function stop():void {
		view.removeEventListener(Event.ADDED, added, true);
		stage.removeEventListener(Event.ADDED_TO_STAGE, globalAdded, true);

		_run=false;
		view=null;
		stage=null;
	}

	public function isRun():Boolean {
		return _run;
	}
}
}
