package com.furusystems.dconsole2.plugins.dialog 
;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.logging.slf4as.ILogger;
	import com.furusystems.logging.slf4as.Logging;
	import com.furusystems.messaging.pimp.PimpCentral;
	
	/**
	 * Describes a sequence of dialog requests
	 * @author Andreas Ronning
	 */
	 class DialogSequence 
	{
		static final L:ILogger = Logging.getLogger(DialogSequence);
		var _requests:Vector<DialogRequest> = new Vector();
		var _results:DialogResult = new DialogResult();
		var _messaging:PimpCentral;
		public function new(console:IConsole, desc:DialogDesc) 
		{
			_messaging = console.messaging;
			for (_tmp_ in desc.requests) {
var question:String  = _tmp_;
				var request= new DialogRequest(console, question, this);
				addRequest(request);
			}
		}
		public function addRequest(request:DialogRequest) {
			_requests.push(request);
		}
		public function next() {
			if(_requests.length>0){
				_requests.shift().execute();
			}else {
				_messaging.send(DialogNotifications.DIALOG_COMPLETE, _results, this);
			}
		}
		
		public function addResult(response:String) 
		{
			_results.addResult(response);
		}
		
	}

