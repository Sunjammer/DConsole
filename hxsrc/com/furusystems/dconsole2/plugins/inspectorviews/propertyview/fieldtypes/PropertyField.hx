package com.furusystems.dconsole2.plugins.inspectorviews.propertyview.fieldtypes
;
	import com.furusystems.dconsole2.IConsole;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import com.furusystems.dconsole2.core.gui.TextFieldFactory;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.plugins.inspectorviews.propertyview.TabContent;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class PropertyField extends TabContent
	{
		public var controlField:ControlField;
		public var nameField:TextField;
		var _readOnly:Bool = false;
		var _prevWidth:Float = 0;
		var splitControl:Sprite = new Sprite();
		var _mouseOrigX:Float = Math.NaN;
		var _splitRatio:Float = 0.5;
		var _access:String;
		var _objRef:ASDictionary<ASAny,ASAny> = new ASDictionary(true);
		var _console:IConsole;
		public function new(console:IConsole, object:ASObject,property:String,type:String,access:String = "readwrite") 
		{
			super(property);
			_console = console;
			_access = access;
			_objRef[0] = object;
			nameField = TextFieldFactory.getLabel(property);
			nameField.textColor = Colors.INSPECTOR_PROPERTY_FIELD_NAME_FG;
			nameField.background = true;
			nameField.backgroundColor = Colors.INSPECTOR_PROPERTY_FIELD_NAME_BG;
			addChild(nameField);
			controlField = new ControlField(console, property, type, access);
			nameField.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			nameField.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			controlField.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			controlField.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			addChild(controlField);
			
			splitControl.buttonMode = true;
			splitControl.addEventListener(MouseEvent.MOUSE_DOWN, onSplitBeginDrag, false, 0, true);
			
			splitControl.x = width * _splitRatio;
			splitControl.graphics.clear();
			splitControl.graphics.beginFill(0, 0.1);
			splitControl.graphics.drawRect(0, 0, -5, GUIUnits.SQUARE_UNIT);
			addChild(splitControl);
			
			if(object!=null){
				if (_access != "writeonly") {
					controlField.value = object[property];
				}
			}
			
			
			_prevWidth = width;
		}
		public function splitToName() {
			splitControl.x = nameField.textWidth;
			_splitRatio = Math.max(.1, Math.min(.9, (splitControl.x / super.width)));
			updateFieldWidths();
		}
		
		function onSplitBeginDrag(e:MouseEvent) 
		{
			_mouseOrigX = mouseX;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSplitDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, onSplitRelease);
		}
		
		function onSplitRelease(e:MouseEvent) 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSplitDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onSplitRelease);
		}
		
		function onSplitDrag(e:MouseEvent) 
		{
			splitRatio = (splitControl.x + mouseX - _mouseOrigX) / _prevWidth;
			_mouseOrigX = mouseX;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		override public function updateFromSource() 
		{
			if (!controlField.hasFocus) {
				if (_access != "writeonly") {
					var t :ASAny= _objRef[0][controlField.targetProperty];
					if (t) controlField.value = t;
				}
			}
		}
		
		function onMouseOut(e:MouseEvent) 
		{
			_console.messaging.send(Notifications.TOOLTIP_HIDE_REQUEST, null, this);
		}
		
		function onMouseOver(e:MouseEvent) 
		{
			var t= "";
			switch(e.currentTarget) {
				case (_ == controlField => true):
				t = controlField.value;
				
				case (_ == nameField => true):
				t = nameField.text;
				

default:
			}
			_console.messaging.send(Notifications.TOOLTIP_SHOW_REQUEST, t, this);
		}
		override function  set_width(value:Float):Float		{
			if (value == _prevWidth) return value;
			graphics.clear();
			graphics.beginFill(Colors.INSPECTOR_PROPERTY_FIELD_BG);
			graphics.drawRect(0, 0, value, GUIUnits.SQUARE_UNIT);
			graphics.endFill();	
			_prevWidth = value;
			updateFieldWidths();
			scrollRect = new Rectangle(0, 0, value, GUIUnits.SQUARE_UNIT);
return value;
		}
		override function  get_width():Float {
			return _prevWidth;
		}
		
		function updateFieldWidths()
		{
			nameField.width = controlField.x = Math.ffloor(_prevWidth * _splitRatio);
			controlField.width = Math.ffloor(_prevWidth * (1-_splitRatio));
			splitControl.x = _prevWidth * _splitRatio;
		}
		
				
		@:flash.property public var readOnly(get,set):Bool;
function  get_readOnly():Bool { return _readOnly; }
function  set_readOnly(value:Bool):Bool		{
			controlField.readOnly = _readOnly = value;
return value;
		}
		
				
		@:flash.property public var splitRatio(get,set):Float;
function  get_splitRatio():Float { return _splitRatio; }
function  set_splitRatio(value:Float):Float		{
			_splitRatio = Math.max(.1, Math.min(.9, value));
			updateFieldWidths();
return value;
		}
		override public function updateAppearance() 
		{
			super.updateAppearance();
			width = _prevWidth;
			nameField.textColor = Colors.INSPECTOR_PROPERTY_FIELD_NAME_FG;
			nameField.backgroundColor = Colors.INSPECTOR_PROPERTY_FIELD_NAME_BG;
			controlField.updateAppearance();
		}
		
	}

