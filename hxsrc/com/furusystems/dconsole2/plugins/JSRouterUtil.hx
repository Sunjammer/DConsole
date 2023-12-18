package com.furusystems.dconsole2.plugins
;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.messaging.pimp.MessageData;
	import flash.external.ExternalInterface;

	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.output.ConsoleMessage;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;

	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class JSRouterUtil implements IDConsolePlugin
	{

		var _routingToJS:Bool = false;
		var _alertingErrors:Bool = false;
		var _console:IConsole;
		var _logFunction:String;

		/**
		 * Toggle: Route all print statements to javascript console.log through externalinterface
		 */
		function routeToJS(func:String = "console.log")
		{
			_logFunction = func;
			if (ExternalInterface.available)
			{
				_routingToJS = !_routingToJS;
				if (_routingToJS)
				{
					_console.print("Routing console to JS", ConsoleMessageTypes.INFO);
				}
				else
				{
					_console.print("No longer routing console to JS", ConsoleMessageTypes.INFO);
				}
			}
			else
			{
				_console.print("ExternalInterface not available", ConsoleMessageTypes.ERROR);
			}
		}

		/**
		 * Route errors to javascript console.log through externalinterface
		 */
		function alertErrors()
		{
			if (ExternalInterface.available)
			{
				_alertingErrors = !_alertingErrors;
				if (_alertingErrors)
				{
					_console.print("Alerting errors through JS", ConsoleMessageTypes.INFO);
				}
				else
				{
					_console.print("No longer alerting errors through JS", ConsoleMessageTypes.INFO);
				}
			}
			else
			{
				_console.print("ExternalInterface not available", ConsoleMessageTypes.ERROR);
			}
		}

		function onError(md:MessageData)
		{
			var m= ASCompat.dynamicAs(md.data , ConsoleMessage);
			if (_alertingErrors)
			{
				ExternalInterface.call("alert", m.text);
			}
			else if (_routingToJS)
			{
				onNewMessage(md);
			}
		}

		function onNewMessage(md:MessageData)
		{
			var m= ASCompat.dynamicAs(md.data , ConsoleMessage);
			if (_routingToJS)
			{
				ExternalInterface.call(_logFunction, m.type + ":" + m.text);
			}
		}
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */

		public function initialize(pm:PluginManager)
		{
			_console = pm.console;
			pm.messaging.addCallback(Notifications.NEW_CONSOLE_OUTPUT, onNewMessage);
			pm.messaging.addCallback(Notifications.ERROR, onError);
			_console.createCommand("routeToJS", routeToJS, "JavaScript", "Toggles routing of all messages to a given js function X (default 'console.log')");
			_console.createCommand("alertErrors", alertErrors, "JavaScript", "Toggles js-alerting of errors caught by the console");
			if (ExternalInterface.available)
			{
				ExternalInterface.addCallback("execute", execute);
			}
		}

		function execute(command:String)
		{
			_console.executeStatement(command, true);
		}

		public function shutdown(pm:PluginManager)
		{
			_console.removeCommand("routeToJS");
			_console.removeCommand("alertErrors");
			pm.messaging.removeCallback(Notifications.NEW_CONSOLE_OUTPUT, onNewMessage);
			pm.messaging.removeCallback(Notifications.ERROR, onError);
			_console = null;
		}

		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */

		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String
		{
			return "Enables console access to javascript log/alert, and javascript access to console executeStatement";
		}

		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>>
		{
			return null;
		}

	}

