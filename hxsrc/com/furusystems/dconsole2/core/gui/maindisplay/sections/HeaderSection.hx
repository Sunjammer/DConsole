package com.furusystems.dconsole2.core.gui.maindisplay.sections ;
	import com.furusystems.dconsole2.core.gui.maindisplay.toolbar.ConsoleToolbar;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.strings.Strings;
	import com.furusystems.dconsole2.IConsole;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class HeaderSection extends ConsoleViewSection {
		
		public var toolBar:ConsoleToolbar;
		var _delta:Point = new Point();
		var _prevDragPos:Point = new Point();
		var _console:IConsole;
		
		public function new(console:IConsole) {
			super();
			_console = console;
			toolBar = new ConsoleToolbar(console);
			addChild(toolBar);
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		function onMouseOut(e:MouseEvent) {
			_console.messaging.send(Notifications.ASSISTANT_CLEAR_REQUEST);
		}
		
		function onMouseOver(e:MouseEvent) {
			_console.messaging.send(Notifications.ASSISTANT_MESSAGE_REQUEST, Strings.ASSISTANT_STRINGS.get(com.furusystems.dconsole2.core.strings.AssistantStringCollection.HEADER_BAR_ID), this);
		}
		
		function onMouseDown(e:MouseEvent) {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			_prevDragPos.x = stage.mouseX;
			_prevDragPos.y = stage.mouseY;
			_console.messaging.send(Notifications.TOOLBAR_DRAG_START, _prevDragPos, this);
		}
		
		function onMouseMove(e:MouseEvent) {
			_delta.x = stage.mouseX - _prevDragPos.x;
			_delta.y = stage.mouseY - _prevDragPos.y;
			_prevDragPos.x = stage.mouseX;
			_prevDragPos.y = stage.mouseY;
			_console.messaging.send(Notifications.TOOLBAR_DRAG_UPDATE, _delta, this);
		}
		
		function onMouseUp(e:MouseEvent) {
			_delta.x = stage.mouseX - _prevDragPos.x;
			_delta.y = stage.mouseY - _prevDragPos.y;
			_prevDragPos.x = stage.mouseX;
			_prevDragPos.y = stage.mouseY;
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_console.messaging.send(Notifications.TOOLBAR_DRAG_STOP, _delta, this);
		}
		
		override public function onParentUpdate(allotedRect:Rectangle) {
			visible = allotedRect.height >= 80;
			toolBar.onParentUpdate(allotedRect);
		}
	
	}

