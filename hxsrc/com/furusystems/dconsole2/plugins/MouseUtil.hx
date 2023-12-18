package com.furusystems.dconsole2.plugins 
;
	import flash.ui.Mouse;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class MouseUtil implements IDConsolePlugin
	{
		
		public function new() 
		{
			
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager)
		{
			pm.console.createCommand("showMouse", Mouse.show, "Mouse", "Shows the mouse cursor");
			pm.console.createCommand("hideMouse", Mouse.hide, "Mouse", "Hides the mouse cursor");
		}
		
		public function shutdown(pm:PluginManager)
		{
			pm.console.removeCommand("showMouse");
			pm.console.removeCommand("hideMouse");
		}
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String
		{
			return "Adds command shortcuts for Mouse.show() and Mouse.hide()";
		}
				
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> 
		{
			return null;
		}
		
	}

