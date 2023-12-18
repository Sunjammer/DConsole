package com.furusystems.logging.slf4as.global ;
	import com.furusystems.logging.slf4as.Logging;
final class Error {
	
	public static function error( args:Array<ASAny> = null) {
if (args == null) args = [];
		Reflect.callMethod(null, Logging.root.error, args);
	}
}
