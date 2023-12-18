package com.furusystems.dconsole2.core.input ;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	 final class KeyHandlerResult {
		
		public function reset() {
			swallowEvent = false;
			autoCompleted = false;
		}
		public var swallowEvent:Bool = false;
		public var autoCompleted:Bool = false;
public function new(){}
	
	}

