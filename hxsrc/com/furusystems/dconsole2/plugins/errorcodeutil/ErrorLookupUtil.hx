package com.furusystems.dconsole2.plugins.errorcodeutil 
;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.messaging.pimp.MessageData;
/**
 * ...
 * @author Andreas Rønning
 */
	 class ErrorLookupUtil implements IDConsolePlugin
	{
		static var ERROR_CODE_XML:Class<Dynamic>;
		var _errorCodes:compat.XML;
		var _lastErrorDescribed:Int = 0;
		var _pm:PluginManager;
		var _autoDescribe:Bool = false;
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String 
		{
			return "Offers an error code lookup and additional error info when they occur";
		}
		
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> 
		{
			return null;
		}
		
		public function initialize(pm:PluginManager) 
		{
			_pm = pm;
			_lastErrorDescribed = -1;
			_errorCodes = new compat.XML(Type.createInstance(ERROR_CODE_XML, []));
			pm.messaging.addCallback(Notifications.NEW_CONSOLE_OUTPUT, onNewConsoleOutput);
			pm.console.createCommand("describeError", describeError, "ErrorLookupUtil", "Pass in an error code [x] and, if it exists, get a description of it. For verbose output, append 'true' as [y]");
			pm.console.createCommand("toggleAutoErrorDescribe", toggleAutoErrorDescription, "ErrorLookupUtil", "Toggles a behavior, defaulting to off, where the console will spit out error descriptions when errors are encountered");
		}
		
		function toggleAutoErrorDescription() 
		{
			_autoDescribe = !_autoDescribe;
		}
		
		function describeError(codeQuery:Int, verboseMode:Bool = false ) 
		{
			var out:String = null;
			var list= _errorCodes.child("everything").child("where").child("code").child("is").child("codeQuery");
			if (list.length() > 0) {
				out = list[0].message;
				if(verboseMode)	out = "\n"+list[0].description;
			}
			if (out != null) {
				_pm.console.print(out, ConsoleMessageTypes.SYSTEM, "ErrorLookup");
			}
		}
		
		function onNewConsoleOutput(md:MessageData) 
		{
			//trace(md.data);
			if (!_autoDescribe) return;
			//if (String(md.data).indexOf("Error #") > -1) {
				//
			//}
		}
		
		public function shutdown(pm:PluginManager) 
		{
			_errorCodes = null;
			pm.messaging.removeCallback(Notifications.NEW_CONSOLE_OUTPUT, onNewConsoleOutput);
			pm.console.removeCommand("describeError");
			_pm = null;
		}

	}


