package com.furusystems.dconsole2.core.commands ;
	import com.furusystems.dconsole2.core.commands.utils.ArgumentSplitterUtil;
	import com.furusystems.dconsole2.core.errors.CommandError;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.persistence.PersistenceManager;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.core.references.ReferenceManager;
	import com.furusystems.dconsole2.core.text.TextUtils;
	import com.furusystems.dconsole2.DConsole;
	import flash.utils.ByteArray;
	
	/**
	 * Manages command definitions and executions
	 * @author Andreas Roenning
	 */
	 final class CommandManager {
		var _console:DConsole;
		var _persistence:PersistenceManager;
		var _commands:Vector<ConsoleCommand>;
		var _referenceManager:ReferenceManager;
		final _EMPTY_ARGS:Vector<CommandArgument> = new Vector();
		var _pluginManager:PluginManager;
		
		public function new(console:DConsole, persistence:PersistenceManager, referenceManager:ReferenceManager, pluginManager:PluginManager) {
			_pluginManager = pluginManager;
			_persistence = persistence;
			_console = console;
			_referenceManager = referenceManager;
			_commands = new Vector<ConsoleCommand>();
		}
		
		public function addCommand(c:ConsoleCommand, includeInHistory:Bool = true) {
			var i= 0;while (i < _commands.length) {
				if (_commands[i].trigger == c.trigger) {
					throw new ArgumentError("Duplicate command trigger phrase: " + c.trigger + " already in use");
				}
i++;
			}
			c.includeInHistory = includeInHistory;
			_commands.push(c);
			_commands.sort(sortCommands);
		}
		
		public function removeCommand(trigger:String) {
			var i= 0;while (i < _commands.length) {
				if (_commands[i].trigger == trigger) {
					_commands.splice(i, 1);
					return;
				}
i++;
			}
		}
		
		function sortCommands(a:ConsoleCommand, b:ConsoleCommand):Int {
			if (a.grouping == b.grouping)
				return -1;
			return 1;
		}
		
		public function tryCommand(input:String, overrideFunc:ASFunction = null, sub:Bool = false):ASAny {
			var cmdStr= TextUtils.stripWhitespace(input);
			var args:Array<ASAny>;
			try {
				args = ArgumentSplitterUtil.slice(cmdStr);
			} catch (e:Error) {
				throw e;
				return;
			}
			var str:String = args.shift().toLowerCase(); //get the first word in the statement; This is our command
			var val:ASAny;
			var commandObject:ConsoleCommand = null;
			var i= _commands.length;while (i-- != 0) {
				if (_commands[i].trigger.toLowerCase() == str) {
					commandObject = _commands[i];
					break;
				}
			}
			if (commandObject != null) {
				var commandArgs:Vector<CommandArgument>;
				if (Std.is(commandObject , UnparsedCommand)) {
					commandArgs = getUnparsedArgs(args);
				} else {
					commandArgs = getArgs(args, Std.is(commandObject , IntrospectionCommand));
				}
				
				try {
					val = doCommand(commandObject, commandArgs, sub);
					if (!sub) {
						if (commandObject.includeInHistory)
							_persistence.addtoHistory(input);
					}
				} catch (e:Error) {
					throw e;
					return;
				}
				if (!sub && val != null && val != /*undefined*/null){
					if (Std.is(val , ByteArray)) return val;
					_console.print(val);
				}
				return val;
			}
			throw new CommandError("'" + str + "' is not a command.");
		}
		
		function traceVector(commandArgs:Vector<CommandArgument>):String {
			var out= "";
			for (c in commandArgs) {
				out += c.data + ", ";
			}
			return out;
		}
		
		public function getUnparsedArgs(args:Array<ASAny>):Vector<CommandArgument> {
			var commandArgs= new Vector<CommandArgument>();
			var i= 0;while (i < args.length) {
				var c= new CommandArgument("", this, _referenceManager, _pluginManager, false);
				c.data = args[i];
				commandArgs.push(c);
i++;
			}
			return commandArgs;
		}
		
		public function getArgs(args:Array<ASAny>, treatAsIntrospectionCmd:Bool = false):Vector<CommandArgument> {
			var commandArgs= new Vector<CommandArgument>();
			var i= 0;while (i < args.length) {
				commandArgs.push(new CommandArgument(args[i], this, _referenceManager, _pluginManager, treatAsIntrospectionCmd && i == 0));
i++;
			}
			return commandArgs;
		}
		
		public function callMethodWithArgs(func:ASFunction, args:Array<ASAny>):ASAny {
			var c= new FunctionCallCommand("", func);
			var args2= new Vector<CommandArgument>();
			var i= 0;while (i < args.length) {
				var arg= new CommandArgument("", this, _referenceManager, _pluginManager, false);
				arg.data = args[i];
				args2.push(arg);
i++;
			}
			//var args2:Vector.<CommandArgument> = getArgs(args);
			return doCommand(c, args2, true);
		}
		
		public function doCommand(command:ConsoleCommand, commandArgs:Vector<CommandArgument> = null, sub:Bool = false):ASAny {
			if (commandArgs == null)
				commandArgs = _EMPTY_ARGS;
			var args:Array<ASAny> = [];
			var i= 0;while (i < commandArgs.length) {
				args.push(commandArgs[i].data);
i++;
			}
			var val:ASAny;
			if (Std.is(command , FunctionCallCommand)) {
				var func= Std.downcast(command , FunctionCallCommand);
				try {
					val = Reflect.callMethod(this, func.callback, args);
					return val;
				} catch (e:ArgumentError) {
					//try again with all args as string
					try {
						var joint= args.join(" ");
						if (joint.length > 0) {
							val = Reflect.callMethod(this, func.callback, [joint]);
						} else {
							val = Reflect.callMethod(this, func.callback, []);
						}
						return val;
					} catch (e:Error) {
						_console.print(e.message, ConsoleMessageTypes.ERROR);
						return null;
					}
					throw new Error(e.message);
				} catch (e:Error) {
					_console.print(e.getStackTrace(), ConsoleMessageTypes.ERROR);
					return null;
				}
			} else {
				_console.print("Abstract command, no action", ConsoleMessageTypes.ERROR);
				return null;
			}
		}
		
		/**
		 * List available command phrases
		 */
		public function listCommands(searchStr:String = null) {
			var str= "Available commands: ";
			if (ASCompat.stringAsBool(searchStr))
				str += " (search for '" + searchStr + "')";
			_console.print(str, ConsoleMessageTypes.SYSTEM);
			var i= 0;while (i < _commands.length) {
				if (ASCompat.stringAsBool(searchStr)) {
					var joint= _commands[i].grouping + _commands[i].trigger + _commands[i].helpText + _commands[i].returnType;
					if (joint.toLowerCase().indexOf(searchStr) == -1)
{						i++;continue;};
				}
				_console.print("	--> " + _commands[i].grouping + " : " + _commands[i].trigger, ConsoleMessageTypes.SYSTEM);
i++;
			}
		}
		
		public function parseForCommand(str:String):ConsoleCommand {
			var i= _commands.length;while (i-- != 0) {
				if (_commands[i].trigger.toLowerCase() == str.split(" ")[0].toLowerCase()) {
					return _commands[i];
				}
			}
			throw new Error("No command found");
		}
		
		public function parseForSubCommand(arg:String):ASAny {
			
			return arg;
		}
		
		public function doSearch(search:String):Vector<String> {
			var result= new Vector<String>();
			var s= search.toLowerCase();
			var i= 0;while (i < _commands.length) {
				var c= _commands[i];
				if (c.trigger.toLowerCase().indexOf(s, 0) > -1) {
					result.push(c.trigger);
				}
i++;
			}
			return result;
		}
	
	}

