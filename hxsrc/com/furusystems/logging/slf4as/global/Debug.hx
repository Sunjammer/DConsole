package com.furusystems.logging.slf4as.global ;
	import com.furusystems.logging.slf4as.Logging;
final class Debug {
	
	public static function debug( args:Array<ASAny> = null) {
if (args == null) args = [];
		Reflect.callMethod(null, Logging.root.debug, args);
	}
}
