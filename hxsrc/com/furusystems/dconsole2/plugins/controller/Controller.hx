package com.furusystems.dconsole2.plugins.controller
;
	import com.furusystems.dconsole2.core.gui.Window;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.core.style.TextFormats;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class Controller extends Window
	{
		public var targetObj:ASAny;
		var paramsField:TextField = new TextField();
		var controlFields:Vector<ControlField> = new Vector();
		var clickOffset:Point;
		var dragArea:Sprite;
		var closeButton:Sprite;
		var manager:ControllerUtil;
		var bg:Shape = new Shape();
		var contents:Sprite = new Sprite();
		public function new(o:ASAny, params:Array<ASAny>,manager:ControllerUtil)
		{
			var dragBarHeight= GUIUnits.SQUARE_UNIT;
			this.manager = manager;
			
			targetObj = o;
			paramsField.defaultTextFormat = TextFormats.windowDefaultFormat;
			contents.addChild(paramsField);
			paramsField.multiline = true;
			paramsField.selectable = false;
			paramsField.mouseEnabled = false;
			paramsField.embedFonts = true;
			paramsField.textColor = 0;
			paramsField.autoSize = TextFieldAutoSize.LEFT;
			paramsField.text = Std.string(o);
			var i= 0;while (i < params.length)
			{
				var cf= new ControlField(params[i], targetObj[params[i]]);
				cf.addEventListener(ControllerEvent.VALUE_CHANGE, onCfChange,false,0,true);
				contents.addChild(cf);
				controlFields.push(cf);
				cf.y = paramsField.textHeight;
				cf.x = 110;
				cf.value = o[params[i]];
				paramsField.appendText("\n" + params[i]);
i++;
			}
			super("" + o.name, new Rectangle(0, 0, contents.width, contents.height), contents);
		}
		
		
		override function onWindowDrag(e:MouseEvent)
		{
			super.onWindowDrag(e);
			update();
		}
		override function onClose(e:MouseEvent)
		{
			super.onClose(e);
			close(e);
		}
		
		function close(e:MouseEvent)
		{
			manager.removeController(this);
		}
		
		function onCfChange(e:Event)
		{
			var t= ASCompat.dynamicAs(e.currentTarget , ControlField);
			targetObj[t.targetProperty] = t.value;
			refresh();
		}
		
		function refresh()
		{
			var i= 0;while (i < controlFields.length)
			{
				if (controlFields[i].hasFocus) {i++;continue;};
				controlFields[i].value = targetObj[controlFields[i].targetProperty];
				if (controlFields[i].targetProperty == "name") {
					setTitle(""+targetObj[controlFields[i].targetProperty]);
				}
i++;
			}
			
		}
		public function update() {
			refresh();
			if (Std.is(targetObj , DisplayObject)) {
				var rect= cast(targetObj, DisplayObject).transform.pixelBounds;
				manager.graphics.moveTo(x, y);
				manager.graphics.lineTo(rect.x, rect.y);
				manager.graphics.drawCircle(rect.x, rect.y, 3);
			}
		}
		
		public function destroy()
		{
			targetObj = null;
			manager = null;
			graphics.clear();
		}
		
	}

