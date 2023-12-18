package com.furusystems.dconsole2.plugins.dialog 
;
	import com.furusystems.dconsole2.IConsole;
	
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	/**
	 * Describes an individual dialog request
	 * @author Andreas Ronning
	 */
	 class DialogRequest 
	{
		var _question:String;
		var _sequence:DialogSequence;
		var _console:IConsole;
		
		public function new(console:IConsole, question:String,sequence:DialogSequence) 
		{
			_console = console;
			_sequence = sequence;
			_question = question;
		}
		public function execute() {
			_console.print(_question, ConsoleMessageTypes.SYSTEM);
			_console.messaging.send(Notifications.ASSISTANT_MESSAGE_REQUEST, _question + " (Type your response and hit enter)");
			_console.setOverrideCallback(handleResponse);
		}
		
		function handleResponse(response:String) 
		{
			var parsed:ASAny = null;
			var tlc= response.toLowerCase();
			
			if (tlc == "yes" || tlc == "true") {
				parsed = true;
			}else if (tlc == "no" || tlc == "false") {
				parsed = false;
			}else {
				parsed = response;
			}
			_sequence.addResult(parsed);
			_console.messaging.send(Notifications.ASSISTANT_CLEAR_REQUEST);
			_console.clearOverrideCallback();
			_sequence.next();
		}
		
	}

