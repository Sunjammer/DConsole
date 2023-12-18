package com.furusystems.dconsole2.plugins.dialog 
;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.logging.slf4as.ILogger;
	import com.furusystems.logging.slf4as.Logging;
	import com.furusystems.messaging.pimp.IMessageReceiver;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.plugins.dialog.DialogDesc;
	/**
	 * ...
	 * @author Andreas Ronning
	 */
	 class DialogUtil implements IDConsolePlugin implements  IMessageReceiver
	{
		static final L:ILogger = Logging.getLogger(DialogUtil);
		var _currentDialog:DialogSequence;
		var _console:IConsole;
		public function new() 
		{
			
		}
		
		function abortDialog() 
		{
			_currentDialog = null;
			_console.print("Dialog aborted", ConsoleMessageTypes.SYSTEM);
			_console.clearOverrideCallback();
			_console.messaging.send(DialogNotifications.ABORT_DIALOG, null, this);
			PimpCentral.removeReceiver(this, Notifications.ESCAPE_KEY);
		}
		
		function startDialog(dialog:DialogDesc) 
		{
			_currentDialog = new DialogSequence(_console, dialog);
			_currentDialog.next();
			PimpCentral.addReceiver(this, Notifications.ESCAPE_KEY);
		}
		
		
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String 
		{
			return "Offers a scripted request/response system for querying the user for data";
		}
		
		public function initialize(pm:PluginManager) 
		{
			pm.messaging.addReceiver(this, DialogNotifications.START_DIALOG);
			_console = pm.console;
		}
		
		public function shutdown(pm:PluginManager) 
		{
			pm.messaging.removeReceiver(this, DialogNotifications.START_DIALOG);
			pm.messaging.removeReceiver(this, Notifications.ESCAPE_KEY);
		}
		
		/* INTERFACE com.furusystems.messaging.pimp.IMessageReceiver */
		
		public function onMessage(md:MessageData) 
		{
			switch(md.message) {
				case DialogNotifications.START_DIALOG:
					var dialog= ASCompat.dynamicAs(md.data , DialogDesc);
					startDialog(dialog);
				
				case Notifications.ESCAPE_KEY:
					abortDialog();
				
			}
		}
		
				
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> 
		{
			return null;
		}
		
	}

