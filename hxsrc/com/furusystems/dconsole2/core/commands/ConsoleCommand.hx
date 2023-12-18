package com.furusystems.dconsole2.core.commands ;
	
	/**
	 * Absdtract console command VO
	 * @author Andreas Roenning
	 */
	 class ConsoleCommand {
		public var trigger:String;
		public var helpText:String = "";
		public var returnType:String = "";
		public var grouping:String = "Application";
		public var includeInHistory:Bool = true;
		
		public function new(trigger:String) {
			this.trigger = trigger;
		}
	
	}

