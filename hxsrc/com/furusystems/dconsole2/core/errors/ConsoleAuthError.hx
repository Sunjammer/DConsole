package com.furusystems.dconsole2.core.errors ;
	
	/**
	 * Error type used when prohibited access is attempted
	 * @author Andreas Roenning
	 */
	 class ConsoleAuthError extends Error {
		
		public function new(message:String = "Not authenticated", id:Int = 0) {
			super(message, id);
		}
	
	}

