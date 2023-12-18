package com.furusystems.dconsole2.plugins 
;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class LoadingUtil implements IDConsolePlugin
	{
		
		public function new() 
		{
			
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String
		{
			return "Adds generic commands for loading external data";
		}
		
		public function initialize(pm:PluginManager)
		{
			pm.console.createCommand("loadString", loadString);
			pm.console.createCommand("loadBinary", loadBinary);
			pm.console.createCommand("loadDisplayObject", loadDisplayObject);
		}
		
		function loadDisplayObject()
		{
			
		}
		
		function loadBinary()
		{
			
		}
		
		function loadString()
		{
			
		}
		
		public function shutdown(pm:PluginManager)
		{
			pm.console.removeCommand("loadString");
			pm.console.removeCommand("loadBinary");
			pm.console.removeCommand("loadDisplayObject");
		}
		
				
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> 
		{
			return null;
		}
		
	}

