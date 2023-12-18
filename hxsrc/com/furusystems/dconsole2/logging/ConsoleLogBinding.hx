package com.furusystems.dconsole2.logging ;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.logging.slf4as.bindings.ILogBinding;
	import com.furusystems.logging.slf4as.constants.Levels;
	import com.furusystems.logging.slf4as.Logging;
	import com.furusystems.logging.slf4as.utils.LevelInfo;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class ConsoleLogBinding implements ILogBinding {
		
		public function new() {
			DConsole.createCommand("setLoggingLevel", setLoggingLevel, "Logging", "Set the current logging level (ERROR,FATAL,INFO,WARN,DEBUG)");
			DConsole.createCommand("getLoggingLevel", getLoggingLevel, "Logging", "Print the current logging level");
		}
		
		function getLoggingLevel() {
			DConsole.addSystemMessage("Current logging level is '" + LevelInfo.getName(Logging.getLevel()) + "'");
		}
		
		function setLoggingLevel(level:String = "ALL") {
			
			Logging.setLevel(LevelInfo.getID(level));
			getLoggingLevel();
		}
		
		/* INTERFACE com.furusystems.logging.slf4as.bindings.ILogBinding */
		
		public function print(owner:ASObject, level:String, str:String) {
			if (ASCompat.toString(owner) == "Logging")
				owner = DConsole.TAG;
			var l= ConsoleMessageTypes.DEBUG;
			switch (LevelInfo.getID(level)) {
				case Levels.ERROR:
					l = ConsoleMessageTypes.ERROR;
					
				case Levels.FATAL:
					l = ConsoleMessageTypes.FATAL;
					
				case Levels.INFO:
					l = ConsoleMessageTypes.INFO;
					
				case Levels.WARN:
					l = ConsoleMessageTypes.WARNING;
					
				default:
					l = ConsoleMessageTypes.DEBUG;
			}
			DConsole.print(str, l, ASCompat.toString(owner));
		}
	
	}

