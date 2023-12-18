package com.furusystems.dconsole2.plugins 
;
	import com.furusystems.dconsole2.IConsole;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class BatchRunnerUtil implements IDConsolePlugin
	{
		var _console:IConsole;
		
		public function new() 
		{
			
		}
		public function runBatch(batch:String):Bool {
            _console.print("Starting batch", ConsoleMessageTypes.SYSTEM);
			_console.lockOutput();
            var split:Array<ASAny> = (cast batch.split("\n").join("\r").split("\r\r").join("\r").split("\r"));
            var result= true;
            var i= 0;while (i < split.length) 
            {
				try{
					var commandResult:ASAny = _console.executeStatement(split[i]);
				}catch (e:Error) {
					_console.print("Batch: error executing '" + split[i] + "'", ConsoleMessageTypes.ERROR);
				}
i++;
            }
            if (result) {
                _console.print("Batch completed", ConsoleMessageTypes.SYSTEM);
            }else {
                _console.print("Batch completed with errors", ConsoleMessageTypes.ERROR);
            }
			_console.unlockOutput();
            return result;
        }
		public function runBatchFromUrl(url:String) {
			var batchLoader= new URLLoader(new URLRequest(url));
			batchLoader.addEventListener(Event.COMPLETE, onBatchLoaded, false, 0, true);
		}
		function onBatchLoaded(e:Event) 
		{
			runBatch(e.target.data);
			e.target.removeEventListener(Event.COMPLETE, onBatchLoaded);
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager)
		{
			_console = pm.console;
			_console.createCommand("runBatch", runBatch, "Batch", "Interpret a string of commands and execute them in order");
			_console.createCommand("runBatchFromURL", runBatchFromUrl, "Batch", "Load a text file of commands and execute them in order");
		}
		
		public function shutdown(pm:PluginManager)
		{
			_console = null;
			_console.removeCommand("runBatch");
			_console.removeCommand("runBatchFromURL");
		}
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String
		{
			return "Enables batch running of console statements from file";
		}
		
				
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> 
		{
			return null;
		}
		
	}

