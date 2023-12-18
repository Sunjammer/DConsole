package com.furusystems.dconsole2.plugins.inspectorviews.propertyview.fieldtypes
;
	import com.furusystems.dconsole2.IConsole;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.core.style.TextFormats;

	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class ControlField extends Sprite
	{
		public var tf:TextField;
		public var targetProperty:String;
		public var hasFocus:Bool = false;
		var _readOnly:Bool = false;
		var _clickOverlay:Sprite;
		var _type:String;
		var _doubleClickTarget:ASObject;
		var _prevWidth:Float = 0;
		var access:String;
		var _console:IConsole;
		public static var FOCUSED_FIELD:ControlField = null;

		public function new(console:IConsole, property:String, type:String = "string", access:String = "readwrite")
		{
			super();
			_console = console;
			this.access = access;
			targetProperty = property;
			_type = type;
			tf = new TextField();
			tf.defaultTextFormat = TextFormats.windowDefaultFormat;
			tf.embedFonts = true;
			tf.textColor = Colors.INSPECTOR_PROPERTY_CONTROL_FIELD_FG;
			tf.backgroundColor = Colors.INSPECTOR_PROPERTY_CONTROL_FIELD_BG;
			tf.height = GUIUnits.SQUARE_UNIT;
			tf.selectable = true;
			tf.background = true;
			tf.type = TextFieldType.INPUT;
			tf.addEventListener(FocusEvent.FOCUS_IN, onFocusIn, false, 0, true);
			tf.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut, false, 0, true);
			addChild(tf);
			var enableMouseWheelControl= false;
			var writeable= true;
			switch (type.toLowerCase())
			{
				case "boolean":
					enableMouseWheelControl = true;
					
				case "uint":
					tf.restrict = "0123456789xABCDEF";
					enableMouseWheelControl = true;
					
				case "int":
					tf.restrict = "0123456789xABCDEF-";
					enableMouseWheelControl = true;
					
				case "number":
					tf.restrict = "0123456789xABCDEF.-";
					enableMouseWheelControl = true;
					
				case "array":
					readOnly = true;
					value = "Array";
					writeable = false;
					
				case "string":
					writeable = true;
					
				default:
					if (type.toLowerCase().indexOf("::") > -1)
					{
						enableDoubleClickToSelect();
					}
					writeable = false;
			}
			readOnly = ((access != "readwrite" && access != "writeonly") || !writeable);
			if (enableMouseWheelControl && !readOnly)
			{
				tf.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
			}
		}

		public function enableDoubleClickToSelect(target:ASObject = null)
		{
			if (_clickOverlay != null)
				return;
			_doubleClickTarget = target;
			tf.type = TextFieldType.DYNAMIC;
			tf.selectable = false;
			_clickOverlay = new Sprite();
			addChild(_clickOverlay);
			_clickOverlay.buttonMode = true;
			_clickOverlay.doubleClickEnabled = true;
			_clickOverlay.addEventListener(MouseEvent.DOUBLE_CLICK, onObjectTargetDoubleClick, false, 0, true);
		}

		function onObjectTargetDoubleClick(e:MouseEvent)
		{
			if (_doubleClickTarget)
			{
				if (Std.is(_doubleClickTarget , DisplayObject))
				{
					_console.executeStatement("select " + cast(_doubleClickTarget, DisplayObject).name);
				}
				else
				{
					_console.executeStatement("select " + targetProperty);
				}
			}
			else
			{
				_console.executeStatement("select " + targetProperty);
			}
		}

		function onFocusOut(e:FocusEvent)
		{
			hasFocus = false;
			removeEventListener(KeyboardEvent.KEY_DOWN, onEnter);
			tf.backgroundColor = 0xFFFFFF - tf.backgroundColor;
			tf.textColor = 0xFFFFFF - tf.textColor;
			FOCUSED_FIELD = null;
		}

		function onFocusIn(e:FocusEvent)
		{
			hasFocus = true;
			addEventListener(KeyboardEvent.KEY_DOWN, onEnter, false, 0, true);
			tf.backgroundColor = 0xFFFFFF - tf.backgroundColor;
			tf.textColor = 0xFFFFFF - tf.textColor;
			if (tf.selectable)
			{
				// info("Select all");
				tf.setSelection(-1, tf.text.length);
			}
			FOCUSED_FIELD = this;
		}

		function onEnter(e:KeyboardEvent)
		{
			if (e.keyCode == Keyboard.ENTER)
			{
				onTextfieldChange();
			}
		}

		function onMouseWheel(e:MouseEvent)
		{
			if (!hasFocus)
				return;
			var d= Math.max(-1, Math.min(1, e.delta));
			if (_type != "Boolean")
			{
				var num= ASCompat.toNumber(tf.text);
				if (e.shiftKey)
				{
					d *= 0.1;
				}
				if (e.ctrlKey)
				{
					d *= 0.1;
				}
				num += d;
				tf.text = Std.string(num);
			}
			else
			{
				tf.text = d > 0 ? "true" : "false";
			}
			onTextfieldChange();
		}
				@:flash.property public var value(get,set):ASAny;
function  get_value():ASAny
		{
			return tf.text;
		}
function  set_value(n:ASAny):ASAny		{
			if (n != null)
			{
				tf.text = Std.string(n);
			}
			else if (n == null)
			{
				tf.text = "null";
			}
return n;
		}
		override function  get_width():Float
		{
			return super.width;
		}

		override function  set_width(value:Float):Float		{
			tf.width = value;
			if (_clickOverlay != null)
			{
				_clickOverlay.graphics.clear();
				_clickOverlay.graphics.beginFill(_readOnly ? Colors.LOCKED : Colors.ENABLED, .2);
				_clickOverlay.graphics.drawRect(0, 0, value, GUIUnits.SQUARE_UNIT);
				_clickOverlay.graphics.endFill();
			}
			return _prevWidth = value;
		}

		
		@:flash.property public var readOnly(get,set):Bool;
function  get_readOnly():Bool
		{
			return _readOnly;
		}
function  set_readOnly(value:Bool):Bool		{
			tf.type = (_readOnly = value) ? TextFieldType.DYNAMIC : TextFieldType.INPUT;
return value;
		}

		@:flash.property public var type(get,never):String;
function  get_type():String
		{
			return _type;
		}

		function onTextfieldChange(e:Event = null)
		{
			try
			{
				if (type == "string")
				{
					_console.executeStatement("set " + targetProperty + " '" + value + "'", true);
				}
				else
				{
					_console.executeStatement("set " + targetProperty + " " + value, true);
				}
			}
			catch (e:Error)
			{
				cast(e.message, Error);
			}
		}
		public function updateAppearance()
		{
			width = _prevWidth;
			tf.textColor = Colors.INSPECTOR_PROPERTY_CONTROL_FIELD_FG;
			tf.backgroundColor = Colors.INSPECTOR_PROPERTY_CONTROL_FIELD_BG;
		}

	}

