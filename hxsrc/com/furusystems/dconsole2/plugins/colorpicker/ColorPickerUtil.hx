package com.furusystems.dconsole2.plugins.colorpicker
;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.core.style.TextFormats;
	import com.furusystems.dconsole2.IConsole;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Mouse;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class ColorPickerUtil extends Sprite implements IDConsolePlugin
	{
		var colorPickerTF:TextField;
		var _color:UInt = 0;
		var sampleBMD:BitmapData = new BitmapData(3, 3, false);
		var sampleBMDDisplay:Bitmap = new Bitmap(sampleBMD);
		var clipRect:Rectangle = new Rectangle(0, 0, 3, 3);
		var matrix:Matrix;
		var _console:IConsole;
		var shiftPos:Point;
		var _prevHeight:Float = Math.NaN;
		public function new() 
		{
			super();
			colorPickerTF = new TextField();
			addChild(colorPickerTF);
			colorPickerTF.defaultTextFormat = TextFormats.windowDefaultFormat;
			colorPickerTF.text = "Colorpicker";
			colorPickerTF.background = true;
			colorPickerTF.embedFonts = true;
			colorPickerTF.border = true;
			colorPickerTF.autoSize = TextFieldAutoSize.LEFT;
			colorPickerTF.y = -colorPickerTF.height;
			addChild(sampleBMDDisplay);
			sampleBMDDisplay.height = colorPickerTF.height;
			sampleBMDDisplay.width = 10;
			sampleBMDDisplay.x = 3;
			sampleBMDDisplay.y = -sampleBMDDisplay.height;
			colorPickerTF.x = sampleBMDDisplay.x + sampleBMDDisplay.width;
			matrix = new Matrix();
			visible = false;
			
			//TODO: Add single-pixel cursor
		}
		
		function onClick(e:MouseEvent) 
		{
			e.stopPropagation();
			e.stopImmediatePropagation();
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, "0x" + color);
			_console.print("Color sent to clipboard: 0x" + color);
			deactivate();
		}
		
		function onMouseMove(e:MouseEvent = null) 
		{
			if(e!=null){
				if (e.shiftKey) {
					Mouse.hide();
					if (shiftPos == null) shiftPos = new Point(_console.view.stage.mouseX, _console.view.stage.mouseY);
					var diffX= shiftPos.x - _console.view.stage.mouseX;
					var diffY= shiftPos.y - _console.view.stage.mouseY;
					x = shiftPos.x-diffX*.25;
					y = shiftPos.y-diffY*.25;
				}else {
					Mouse.show();
					shiftPos = null;
					x = _console.view.stage.mouseX;
					y = _console.view.stage.mouseY;
				}
				e.updateAfterEvent();
			}else {
				shiftPos = null;
				x = _console.view.stage.mouseX;
				y = _console.view.stage.mouseY;
			}
			matrix.identity();
			matrix.translate(-x, -y);
			sample();
		}
		
		function sample()
		{
			try{
				sampleBMD.lock();
				sampleBMD.fillRect(sampleBMD.rect, 0x00000000);
				sampleBMD.draw(stage, matrix, null, null, clipRect);
				sampleBMD.unlock();
				_color = sampleBMD.getPixel(1, 1);
				colorPickerTF.text = "0x" + color;
			}catch (e:Error) {
				
			}
		}
		@:flash.property public var color(get,never):String;
function  get_color():String {
			var str= ASCompat.toRadix(_color, 16).toUpperCase();
			str = ASCompat.allocArray(7 - str.length).join("0") + str;
			return str;
		}
		public function deactivate() {
			visible = false;
			Mouse.show();
			_console.view.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_console.view.stage.removeEventListener(MouseEvent.CLICK, onClick);
			_console.view.height = _prevHeight;
		}
		public function activate() {
			_color = 0x00000000;
			_prevHeight = _console.view.height;
			_console.view.height = 2 * GUIUnits.SQUARE_UNIT;
			visible = true;
			_console.view.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_console.view.stage.addEventListener(MouseEvent.CLICK, onClick, false, 99999999);
			_console.print("Click anywhere to copy that color value to the clipboard", ConsoleMessageTypes.SYSTEM);
			onMouseMove();
		}
		
		function toggle()
		{
			visible?deactivate():activate();
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager)
		{
			_console = pm.console;
			pm.topLayer.addChild(this);
			_console.createCommand("colorpicker", toggle, "ColorPickerUtil", "Toggles a utility that grabs and outputs a color off the stage on a mouseclick");
		}
		
		public function shutdown(pm:PluginManager)
		{
			pm.topLayer.removeChild(this);
			_console.removeCommand("colorpicker");
		}
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String
		{
			return "Adds a color picker utility for sampling colors from the stage";
		}
		
				
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> 
		{
			return null;
		}
		
	}

