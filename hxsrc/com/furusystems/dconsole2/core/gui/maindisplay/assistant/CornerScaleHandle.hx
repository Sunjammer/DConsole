package com.furusystems.dconsole2.core.gui.maindisplay.assistant ;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.strings.Strings;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * The scaling handle shown in the lower right corner when the console is in windowed mode
	 * @author Andreas Roenning
	 */
	 class CornerScaleHandle extends Sprite {
		
		var _delta:Point = new Point();
		var _prevDragPos:Point = new Point();
		var _messaging:PimpCentral;
		
		public function new(console:IConsole) {
			super();
			_messaging = console.messaging;
			//TODO: Tie into theming
			alpha = 0.8;
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, GUIUnits.SQUARE_UNIT, GUIUnits.SQUARE_UNIT);
			graphics.beginFill(Colors.SCALEHANDLE_BG);
			graphics.moveTo(GUIUnits.SQUARE_UNIT, 0);
			graphics.lineTo(GUIUnits.SQUARE_UNIT, GUIUnits.SQUARE_UNIT);
			graphics.lineTo(0, GUIUnits.SQUARE_UNIT);
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		function onMouseOut(e:MouseEvent) {
			_messaging.send(Notifications.ASSISTANT_CLEAR_REQUEST);
		}
		
		function onMouseOver(e:MouseEvent) {
			_messaging.send(Notifications.ASSISTANT_MESSAGE_REQUEST, Strings.ASSISTANT_STRINGS.get(com.furusystems.dconsole2.core.strings.AssistantStringCollection.CORNER_HANDLE_ID), this);
		}
		
		function onMouseDown(e:MouseEvent) {
			alpha = 1;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_prevDragPos.x = stage.mouseX;
			_prevDragPos.y = stage.mouseY;
			_messaging.send(Notifications.CORNER_DRAG_START, _prevDragPos, this);
		}
		
		function onMouseMove(e:MouseEvent) {
			_delta.x = stage.mouseX - _prevDragPos.x;
			_delta.y = stage.mouseY - _prevDragPos.y;
			_prevDragPos.x = stage.mouseX;
			_prevDragPos.y = stage.mouseY;
			_messaging.send(Notifications.CORNER_DRAG_UPDATE, _delta, this);
		}
		
		function onMouseUp(e:MouseEvent) {
			alpha = 0.8;
			_delta.x = stage.mouseX - _prevDragPos.x;
			_delta.y = stage.mouseY - _prevDragPos.y;
			_prevDragPos.x = stage.mouseX;
			_prevDragPos.y = stage.mouseY;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_messaging.send(Notifications.CORNER_DRAG_STOP, _delta, this);
		}
	
	}

