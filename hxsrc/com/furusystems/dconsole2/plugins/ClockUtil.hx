package com.furusystems.dconsole2.plugins 
;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	/**
	 * ...
	 * @author Andreas Ronning
	 */
	 class ClockUtil implements IDConsolePlugin
	{
		
		public function new() 
		{
			
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String 
		{
			return "Adds a simple command for getting the current time";
		}
		
		public function initialize(pm:PluginManager) 
		{
		}
		
		public function shutdown(pm:PluginManager) 
		{
			
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> 
		{
			return null;
		}
		
	}

