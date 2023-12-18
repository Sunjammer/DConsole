package com.furusystems.logging.slf4as.global ;
	import com.furusystems.logging.slf4as.Logging;
final class Warn {
	
	public static function warn( args:Array<ASAny> = null) {
if (args == null) args = [];
		Reflect.callMethod(null, Logging.root.warn, args);
	}
}
