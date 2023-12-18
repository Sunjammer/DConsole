package com.furusystems.dconsole2.plugins 
;
	import com.furusystems.dconsole2.IConsole;
	import flash.text.Font;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class FontUtil implements IDConsolePlugin
	{
		var _console:IConsole;
		
		function printFonts(c:IConsole) {
			var fnts= Font.enumerateFonts();
			if (fnts.length < 1) {
				c.print("Only system fonts available");
			}
			var i= 0;while (i < fnts.length) 
			{
				c.print("	" + fnts[i].fontName);
i++;
			}
		}
		function listFonts()
		{
			printFonts(_console);
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager)
		{
			_console = pm.console;
			_console.createCommand("listFonts", listFonts, "FontUtil", "Prints a list of all embedded fonts (excluding system fonts)");
		}
		
		public function shutdown(pm:PluginManager)
		{
			_console = null;
			_console.removeCommand("listFonts");
		}
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String
		{
			return "Enables readouts of embedded fonts";
		}
		
				
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> 
		{
			return null;
		}
		
	}

