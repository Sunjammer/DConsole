package com.furusystems.dconsole2.plugins 
;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class PerformanceTesterUtil implements IDConsolePlugin
	{
		static inline final commandString= "testMethods";
		var _console:IConsole;
		public function new() 
		{
			
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String
		{
			return "Adds a performance test command for comparing execution time for a set of methods";
		}
		
		public function initialize(pm:PluginManager)
		{
			_console = pm.console;
			_console.createCommand(commandString, doFunctionTest, "Performance", "Runs a set of methods [...x] and returns a table of execution times in milliseconds");
		}
		
		function doFunctionTest(functions:Array<ASAny> = null)
		{
if (functions == null) functions = [];
			if (functions.length < 1) {
				throw new Error("A list of function references must be passed");
			}
			var validEntries:Array<ASAny> = [];
			for (_tmp_ in functions) 
			{
var f:ASFunction  = _tmp_;
				validEntries.push(f);
			}
			var out= "Results:\n";
			var i= 0;while (i < validEntries.length) 
			{
				out += i + "\t" + test(validEntries[i]) + "\n";
i++;
			}
			_console.print(out);
		}
		function test(f:ASFunction):Float {
			var btime:Float = flash.Lib.getTimer();
			f();
			return flash.Lib.getTimer() - btime;
		}
		
		public function shutdown(pm:PluginManager)
		{
			pm.console.removeCommand(commandString);
			_console = null;
		}
		
				
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> 
		{
			return null;
		}
		
	}

