package com.furusystems.logging.slf4as.bindings ;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	 interface ILogBinding {
		function print(owner:ASObject, level:String, str:String):Void;
	}

