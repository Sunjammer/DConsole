package com.furusystems.dconsole2.core.errors ;
	
	/**
	 * Error type used when commands result in errors
	 * @author Andreas Roenning
	 */
	 class CommandError extends Error {
		
		public function new(msg:String) {
			super(msg);
		}
	
	}

