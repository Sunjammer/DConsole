package com.furusystems.dconsole2.plugins 
;
	import com.furusystems.dconsole2.core.plugins.IParsingDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class JSONParserUtil implements IParsingDConsolePlugin
	{
		
		public function new() 
		{
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IParsingDConsolePlugin */
		
		public function parse(data:String):ASAny
		{
			var firstChar= data.charAt(0);
			switch(firstChar) {
				case "["
				   | "{":
					try {
						var ret:ASAny = null;//com.adobe.serialization.json.JSON.decode(data);
						return ret;
					}catch (e:Error) {
						return null;
					}
				
			}
			return null;
		}
		
		public function initialize(pm:PluginManager)
		{
			
		}
		
		public function shutdown(pm:PluginManager)
		{
			
		}
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String
		{
			return "Adds JSON parsing of command arguments";
		}
		
				
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> 
		{
			return null;
		}
		
	}

