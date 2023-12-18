package com.furusystems.dconsole2.plugins.controller ;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import com.furusystems.dconsole2.core.style.TextFormats;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class ControlField extends Sprite {
		var tf:TextField;
		public var targetProperty:String;
		public var hasFocus:Bool = false;
		
		public function new(property:String, type:String = "string") {
			super();
			targetProperty = property;
			tf = new TextField();
			tf.defaultTextFormat = TextFormats.consoleTitleFormat;
			tf.embedFonts = true;
			tf.textColor = 0x333333;
			tf.height = GUIUnits.SQUARE_UNIT;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.selectable = true;
			tf.type = TextFieldType.INPUT;
			//tf.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, onFocus);
			tf.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			tf.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			addChild(tf);
			switch (type.toLowerCase()) {
				case "uint":
					tf.restrict = "0123456789";
					
				case "int":
					tf.restrict = "0123456789-";
					
				case "number":
					tf.restrict = "0123456789.-";
					
			}
			if (type.toLowerCase() != "string")
				tf.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
		}
		
		function onFocusOut(e:FocusEvent) {
			hasFocus = false;
			removeEventListener(KeyboardEvent.KEY_DOWN, onEnter);
		}
		
		function onFocusIn(e:FocusEvent) {
			hasFocus = true;
			addEventListener(KeyboardEvent.KEY_DOWN, onEnter, false, 0, true);
		}
		
		function onEnter(e:KeyboardEvent) {
			if (e.keyCode == Keyboard.ENTER) {
				onTextfieldChange();
			}
		}
		
		function onMouseWheel(e:MouseEvent) {
			var d= Math.max(-1, Math.min(1, e.delta));
			var num= ASCompat.toNumber(tf.text);
			if (e.shiftKey) {
				d *= 0.1;
			}
			if (e.ctrlKey) {
				d *= 0.1;
			}
			num += d;
			tf.text = Std.string(num);
			onTextfieldChange();
		}
		
				
		@:flash.property public var value(get,set):ASAny;
function  get_value():ASAny {
			return tf.text;
		}
function  set_value(n:ASAny):ASAny{
			tf.text = Std.string(n);
return n;
		}
		
		function onTextfieldChange(e:Event = null) {
			dispatchEvent(new ControllerEvent(ControllerEvent.VALUE_CHANGE));
		}
	
	}

