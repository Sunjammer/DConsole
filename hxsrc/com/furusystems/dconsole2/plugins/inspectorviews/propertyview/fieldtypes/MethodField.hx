package com.furusystems.dconsole2.plugins.inspectorviews.propertyview.fieldtypes
;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import com.furusystems.dconsole2.core.gui.TextFieldFactory;
	import com.furusystems.dconsole2.core.introspection.descriptions.MethodDesc;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.plugins.inspectorviews.propertyview.TabContent;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class MethodField extends TabContent
	{
		var nameField:TextField;
		var _prevWidth:Float = Math.NaN;
		var _messaging:PimpCentral;
		
		public function new(messaging:PimpCentral, desc:MethodDesc) 
		{
			_messaging = messaging;
			nameField = TextFieldFactory.getLabel(desc.name);
			super(desc.name);
			addChild(nameField);
			buttonMode = true;
			nameField.textColor = Colors.INSPECTOR_PROPERTY_CONTROL_FIELD_FG;
			doubleClickEnabled = true;
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick, false, 0, true);
		}
		
		function onMouseOver(e:MouseEvent) 
		{
			_messaging.send(Notifications.TOOLTIP_SHOW_REQUEST, nameField.text, this);
		}
		function onMouseOut(e:MouseEvent) 
		{
			_messaging.send(Notifications.TOOLTIP_HIDE_REQUEST, null, this);
		}
		function onDoubleClick(e:MouseEvent) 
		{
			_messaging.send(Notifications.EXECUTE_STATEMENT, "call " + nameField.text, this);
		}
		
		function onClick(e:MouseEvent) 
		{
			_messaging.send(Notifications.CONSOLE_INPUT_LINE_CHANGE_REQUEST, "call " + nameField.text, this);
		}
		override function  set_width(value:Float):Float		{
			nameField.width = value;
			graphics.clear();
			graphics.beginFill(Colors.INSPECTOR_PROPERTY_CONTROL_FIELD_BG);
			graphics.drawRect(0, 0, value, GUIUnits.SQUARE_UNIT);
			graphics.endFill();	
			return _prevWidth = value;
		}
		override public function updateAppearance() 
		{
			super.updateAppearance();
			nameField.textColor = Colors.INSPECTOR_PROPERTY_CONTROL_FIELD_FG;
			width = _prevWidth;
		}
		override public function updateFromSource() 
		{
			
		}
		
	}

