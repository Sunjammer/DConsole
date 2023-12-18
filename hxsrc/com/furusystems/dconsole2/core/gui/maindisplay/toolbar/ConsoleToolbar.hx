package com.furusystems.dconsole2.core.gui.maindisplay.toolbar ;
	import com.furusystems.dconsole2.core.gui.layout.IContainable;
	import com.furusystems.dconsole2.core.interfaces.IThemeable;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.core.style.TextFormats;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.messaging.pimp.MessageData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class ConsoleToolbar extends Sprite implements IContainable implements  IThemeable {
		
		var _titleField:TextField = new TextField();
		var _rect:Rectangle;
		var _console:IConsole;
		
		public function new(console:IConsole) {
			super();
			_console = console;
			_titleField.height = GUIUnits.SQUARE_UNIT;
			_titleField.selectable = _titleField.mouseEnabled = false;
			_titleField.defaultTextFormat = TextFormats.consoleTitleFormat;
			_titleField.embedFonts = true;
			_titleField.textColor = Colors.HEADER_FG;
			_titleField.text = "Doomsday Console II";
			_titleField.x = _titleField.y = 1;
			addChild(_titleField);
			_console.messaging.addCallback(Notifications.THEME_CHANGED, onThemeChange);
		
		}
		
		public function setTitle(text:String) {
			_titleField.text = text;
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.gui.layout.IContainable */
		
		public function onParentUpdate(allotedRect:Rectangle) {
			_rect = allotedRect;
			//x = _rect.x;
			//y = _rect.y;
			graphics.clear();
			graphics.beginFill(Colors.HEADER_BG);
			graphics.drawRect(0, 0, _rect.width, GUIUnits.SQUARE_UNIT);
			graphics.endFill();
			_titleField.width = allotedRect.width;
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.interfaces.IThemeable */
		
		public function onThemeChange(md:MessageData) {
			_titleField.textColor = Colors.HEADER_FG;
			graphics.clear();
			graphics.beginFill(Colors.HEADER_BG);
			graphics.drawRect(0, 0, _rect.width, GUIUnits.SQUARE_UNIT);
			graphics.endFill();
		}
		
		@:flash.property public var minHeight(get,never):Float;
function  get_minHeight():Float {
			return 0;
		}
		
		@:flash.property public var minWidth(get,never):Float;
function  get_minWidth():Float {
			return 0;
		}
		
		@:flash.property public var rect(get,never):Rectangle;
function  get_rect():Rectangle {
			return getRect(this);
		}
	
	}

