package com.furusystems.dconsole2.plugins 
;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class ClassFactoryUtil implements IDConsolePlugin
	{
		
		public function new() 
		{
			
		}
		
		public function getClassByName(str:String):Class<Dynamic> {
			return Type.resolveClass(str) ;
		}
		function make(className:String, args:Array<ASAny> = null):ASAny{
if (args == null) args = [];
			var c= getClassByName(className);
			switch (args.length)
			{
				case 1:
				return Type.createInstance(c, [args[0]]);
				case 2:
				return Type.createInstance(c, [args[0], args[1]]);
				case 3:
				return Type.createInstance(c, [args[0], args[1], args[2]]);
				case 4:
				return Type.createInstance(c, [args[0], args[1], args[2], args[3]]);
				case 5:
				return Type.createInstance(c, [args[0], args[1], args[2], args[3], args[4]]);
				case 6:
				return Type.createInstance(c, [args[0], args[1], args[2], args[3], args[4], args[5]]);
				case 7:
				return Type.createInstance(c, [args[0], args[1], args[2], args[3], args[4], args[5], args[6]]);
				case 8:
				return Type.createInstance(c, [args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]]);
				case 9:
				return Type.createInstance(c, [args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]]);
				case 10:
				return Type.createInstance(c, [args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]]);
				case 11:
				return Type.createInstance(c, [args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10]]);
				case 12:
				return Type.createInstance(c, [args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11]]);
				case 13:
				return Type.createInstance(c, [args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12]]);
				case 14:
				return Type.createInstance(c, [args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13]]);
				case 15:
				return Type.createInstance(c, [args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14]]);
				case 16:
				return Type.createInstance(c, [args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15]]);
				case 17:
				return Type.createInstance(c, [args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16]]);
				case 18:
				return Type.createInstance(c, [args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17]]);
				case 19:
				return Type.createInstance(c, [args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18]]);
				case 20:
				return Type.createInstance(c, [args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19]]);
				default:
				return Type.createInstance(c, []);
			}
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager)
		{
			pm.console.createCommand("new", make, "ClassFactoryUtil", "Creates a new instance of a specified class by its qualified name (ie package.ClassName). Hard capped to 20 args.");
			pm.console.createCommand("getClass", getClassByName, "ClassFactoryUtil", "Returns a reference to the Class object of the specified classname");
		}
		
		public function shutdown(pm:PluginManager)
		{
			pm.console.removeCommand("new");
			pm.console.removeCommand("getClass");
		}
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String
		{
			return "Enables the creation of class instances, and access to class types from 'getDefinitionByName'";
		}
		
				
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> 
		{
			return null;
		}
		
	}

