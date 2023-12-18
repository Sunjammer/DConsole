package com.furusystems.dconsole2.core.commands ;
	
	/**
	 * Concrete command for calling a function
	 * @author Andreas Roenning
	 */
	 class FunctionCallCommand extends ConsoleCommand {
		var _callbackDict:ASDictionary<ASAny,ASAny>;
		
		/**
		 * Creates a callback command, which calls a function when triggered
		 * @param	trigger
		 * The trigger phrase
		 * @param	callback
		 * The function to call
		 */
		public function new(trigger:String, callback:ASFunction, grouping:String = "Application", helpText:String = "") {
			_callbackDict = new ASDictionary<ASAny,ASAny>(true);
			_callbackDict["callback"] = callback; //Safing it. Do instance method referenced in a variable get GC'd? In this case they should, right?
			super(trigger);
			this.grouping = grouping;
			this.helpText = helpText;
		}
		
		@:flash.property public var callback(get,never):ASFunction;
function  get_callback():ASFunction {
			return ASCompat.asFunction(_callbackDict["callback"] );
		}
	
	}

