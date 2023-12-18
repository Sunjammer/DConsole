package com.furusystems.logging.slf4as.bindings ;
	
	/**
	 * ...
	 * @author Andreas R�nning
	 */
	 class TraceBinding implements ILogBinding {
		/* INTERFACE com.furusystems.logging.slf4as.bindings.ILogBinding */
		
		static var _lineNumber:Int = 0;
		
		public function print(owner:ASObject, level:String, str:String) {
			trace((_lineNumber++) + "\t" + level + "\t" + owner + "\t" + str);
		}
public function new(){}
	
	}

