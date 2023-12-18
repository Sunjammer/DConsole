package com.furusystems.dconsole2.core.gui ;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.core.style.TextFormats;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 final class DropDownOption extends Sprite {
		public var title:String;
		var titleField:TextField;
		public var data:ASAny;
		public var index:Int = -1;
		public var isDefault:Bool = false;
		
		public function new(title:String = "Blah", data:ASAny = null, isDefault:Bool = false) {
			super();
			this.data = data;
			this.isDefault = isDefault;
			this.title = title;
			titleField = new TextField();
			addChild(titleField);
			//titleField.autoSize = TextFieldAutoSize.LEFT;
			titleField.height = GUIUnits.SQUARE_UNIT;
			titleField.defaultTextFormat = TextFormats.consoleTitleFormat;
			titleField.embedFonts = titleField.defaultTextFormat.font.charAt(0) != "_";
			titleField.text = title;
			titleField.mouseEnabled = false;
			titleField.y = 1;
			titleField.background = true;
			titleField.textColor = Colors.DROPDOWN_FG_INACTIVE;
			titleField.backgroundColor = Colors.DROPDOWN_BG_INACTIVE;
			selected = false;
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		public function setWidth(w:Float) {
			titleField.width = w;
		}
		
		@:flash.property var selected(never,set):Bool;
function  set_selected(b:Bool):Bool{
			if (b) {
				titleField.textColor = Colors.DROPDOWN_FG_ACTIVE;
				titleField.backgroundColor = Colors.DROPDOWN_BG_ACTIVE;
			} else {
				titleField.textColor = Colors.DROPDOWN_FG_INACTIVE;
				titleField.backgroundColor = Colors.DROPDOWN_BG_INACTIVE;
			}
return b;
		}
		
		function onMouseOver(e:MouseEvent) {
			selected = true;
		}
		
		function onMouseOut(e:MouseEvent) {
			selected = false;
		}
		
		@:flash.property public var background(never,set):Bool;
function  set_background(b:Bool):Bool{
			return titleField.background = b;
		}
		
		public function updateAppearance() {
			selected = false;
		}
	
	}

