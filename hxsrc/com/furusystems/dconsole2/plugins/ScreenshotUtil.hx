package com.furusystems.dconsole2.plugins 
;
	import com.furusystems.dconsole2.IConsole;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.DConsole;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class ScreenshotUtil implements IDConsolePlugin
	{
		final _fileRef:FileReference = new FileReference();
		var _console:IConsole;
		
		public function getScreenshot(target:DisplayObject = null):BitmapData
		{
			var bmd:BitmapData;
			cast(_console, DConsole).isVisible = false;
			if (target == null){
				bmd = new BitmapData(_console.view.stage.stageWidth, _console.view.stage.stageHeight, true, 0);
				bmd.draw(_console.view.stage);
			}else {
				bmd = new BitmapData(Std.int(target.width), Std.int(target.height), true, 0);
				bmd.draw(target);
			}
			cast(_console, DConsole).isVisible = true;
			return bmd;
		}
		
		public function saveScreenshot(target:DisplayObject = null,title:String = "")
		{
			var screenGrab= getScreenshot(target);
			var pngBytes:ByteArray = null; // = PNGEncoder.encode(screenGrab);
			if (title == "") title = "Screenshot";
			_fileRef.save(pngBytes, title + ".png");
		}
		public function getPNG(bitmapData:BitmapData):ByteArray {
			return null; //PNGEncoder.encode(bitmapData);
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager)
		{
			_console = pm.console;
			_console.createCommand("saveScreenshot", saveScreenshot, "ScreenshotUtil", "Grab a png screenshot of the target object (default stage) and save it as PNG");
			_console.createCommand("getScreenshot", getScreenshot, "ScreenshotUtil", "Grab a bitmapdata screenshot of the target object (default stage) and return it");
		}
		
		public function shutdown(pm:PluginManager)
		{
			_console.removeCommand("saveScreenshot");
			_console.removeCommand("getScreenshot");
		}
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String
		{
			return "Enables saving of screenshots of selections or the full stage";
		}
		
				
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> 
		{
			return null;
		}
		
	}

