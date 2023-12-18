package com.furusystems.dconsole2.plugins 
;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class CommandMapperUtil implements IDConsolePlugin
	{
		var _console:IConsole;
		var methodsCreated:ASDictionary<ASAny,ASAny> = new ASDictionary();
		var _pm:PluginManager;
		public function new() 
		{
			
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String
		{
			return "Offers fast automatic mapping of public methods to commands";
		}
		
		public function initialize(pm:PluginManager)
		{
			_console = pm.console;
			_pm = pm;
			pm.console.createCommand("quickmap", doMap,"CommandMapperUtil","Maps every method of the current scope to a command if possible");
		}
		
		function doMap()
		{
			var target= _pm.scopeManager.currentScope;
			var i= 0;while (i < target.methods.length) 
			{
				_console.createCommand(target.methods[i].name, target.targetObject[target.methods[i].name], Std.string(target.targetObject));
				methodsCreated[target.methods[i].name] = 1;
i++;
			}
		}
		
		public function shutdown(pm:PluginManager)
		{
			pm.console.removeCommand("quickmap");
			for(_tmp_ in methodsCreated.keys()) {
var m:String  = _tmp_;
				pm.console.removeCommand(m);
			}
			_console = null;
			_pm = null;
		}
		
				
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> 
		{
			return null;
		}
		
	}

