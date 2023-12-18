package com.furusystems.dconsole2.core.errors ;
	
	/**
	 * Generic error used with abstract function definitions
	 * @author Andreas Roenning
	 */
	 class NotImplementedError extends Error {
		
		public function new(message:String = "Not implemented", id:Int = 0) {
			super(message, id);
		}
	
	}

