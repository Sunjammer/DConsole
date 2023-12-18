package com.furusystems.dconsole2.core.gui
;
	import com.furusystems.dconsole2.core.gui.layout.IContainable;
	import com.furusystems.dconsole2.core.interfaces.IThemeable;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.strings.Strings;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.messaging.pimp.MessageData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class ScaleHandle extends Sprite implements IContainable implements  IThemeable
	{

		var _dragging:Bool = false;
		var allotedRect:Rectangle;
		var console:DConsole;

		public function new(console:DConsole)
		{
			super();
			this.console = console;
			// buttonMode = true;
			doubleClickEnabled = true;
			tabEnabled = false;
			// var dsf:DropShadowFilter = new DropShadowFilter(0, 90, 0, 1, 4, 4, 1, 1, true);
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			alpha = 0;
			console.messaging.addCallback(Notifications.THEME_CHANGED, onThemeChange);
		}

		function onMouseOut(e:MouseEvent)
		{
			console.messaging.send(Notifications.ASSISTANT_CLEAR_REQUEST);
		}

		function onMouseOver(e:MouseEvent)
		{
			console.messaging.send(Notifications.ASSISTANT_MESSAGE_REQUEST, Strings.ASSISTANT_STRINGS.get (com.furusystems.dconsole2.core.strings.AssistantStringCollection.SCALE_HANDLE_ID), this);
		}

		function onRollOut(e:MouseEvent)
		{
			if (dragging)
				return;
			alpha = 0;
			Mouse.cursor = MouseCursor.AUTO;
		}

		function onRollOver(e:MouseEvent)
		{
			alpha = 1;
			Mouse.cursor = MouseCursor.HAND;
		}

		/* INTERFACE com.furusystems.dconsole2.core.gui.layout.IContainable */

		public function onParentUpdate(allotedRect:Rectangle)
		{
			this.allotedRect = allotedRect;
			graphics.clear();
			x = allotedRect.x;
			y = allotedRect.y;
			graphics.beginFill(Colors.SCALEHANDLE_BG, 1);
			var h= GUIUnits.SQUARE_UNIT / 2;
			graphics.drawRect(0, 0, allotedRect.width, h);
			graphics.endFill();
			graphics.lineStyle(0, Colors.SCALEHANDLE_FG);
			graphics.moveTo(3, h / 2);
			graphics.lineTo(allotedRect.width - 3, h / 2);
		}

		/* INTERFACE com.furusystems.dconsole2.core.interfaces.IThemeable */

		public function onThemeChange(md:MessageData)
		{
			graphics.clear();
			x = allotedRect.x;
			y = allotedRect.y;
			graphics.beginFill(Colors.SCALEHANDLE_BG, 1);
			var h= GUIUnits.SQUARE_UNIT / 2;
			graphics.drawRect(0, 0, allotedRect.width, h);
			graphics.endFill();
			graphics.lineStyle(0, Colors.SCALEHANDLE_FG);
			graphics.moveTo(3, h / 2);
			graphics.lineTo(allotedRect.width - 3, h / 2);
		}

		@:flash.property public var rect(get,never):Rectangle;
function  get_rect():Rectangle
		{
			return getRect(parent);
		}

		@:flash.property public var minHeight(get,never):Float;
function  get_minHeight():Float
		{
			return 0;
		}

		@:flash.property public var minWidth(get,never):Float;
function  get_minWidth():Float
		{
			return 0;
		}

		
		@:flash.property public var dragging(get,set):Bool;
function  get_dragging():Bool
		{
			return _dragging;
		}
function  set_dragging(value:Bool):Bool		{
			_dragging = value;
			if (value)
			{

				alpha = 1;
			}
			else
			{

				alpha = 0;
			}
return value;
		}

	}

