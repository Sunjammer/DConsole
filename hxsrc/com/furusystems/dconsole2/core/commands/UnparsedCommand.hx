package com.furusystems.dconsole2.core.commands ;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	 class UnparsedCommand extends FunctionCallCommand {
		
		public function new(trigger:String, callback:ASFunction, grouping:String = "Application", helpText:String = "") {
			super(trigger, callback, grouping, helpText);
		}
	
	}

