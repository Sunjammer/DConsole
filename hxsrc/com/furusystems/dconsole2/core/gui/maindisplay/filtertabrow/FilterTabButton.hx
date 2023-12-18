package com.furusystems.dconsole2.core.gui.maindisplay.filtertabrow ;
	import com.furusystems.dconsole2.core.gui.TextFieldFactory;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * A button used along the filter tab row
	 * @author Andreas Ronning
	 */
	 class FilterTabButton extends Sprite {
		var _name:String;
		var label:TextField;
		var _active:Bool = false;
		var _messaging:PimpCentral;
		
		public function new(console:IConsole, name:String) {
			super();
			_messaging = console.messaging;
			buttonMode = true;
			_name = name;
			label = TextFieldFactory.getLabel(name);
			label.mouseEnabled = false;
			label.autoSize = TextFieldAutoSize.LEFT;
			addChild(label);
			active = false;
			addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}
		
		public function redraw() {
			active = _active;
		}
		
		function onClick(e:MouseEvent) {
			_messaging.send(Notifications.LOG_BUTTON_CLICKED, _name, this);
		}
		
				
		@:flash.property public var active(get,set):Bool;
function  set_active(b:Bool):Bool{
			_active = b;
			graphics.clear();
			if (!_active) {
				graphics.lineStyle(0, Colors.BUTTON_BORDER);
				graphics.beginFill(Colors.BUTTON_INACTIVE_BG);
				label.textColor = Colors.BUTTON_INACTIVE_FG;
			} else {
				graphics.lineStyle(0, Colors.BUTTON_BORDER);
				graphics.beginFill(Colors.BUTTON_ACTIVE_BG);
				label.textColor = Colors.BUTTON_ACTIVE_FG;
			}
			graphics.drawRect(0, 0, label.textWidth + 4, GUIUnits.SQUARE_UNIT);
			graphics.endFill();
return b;
		}
function  get_active():Bool {
			return _active;
		}
		
		@:flash.property public var logName(get,never):String;
function  get_logName():String {
			return _name;
		}
	
	}

