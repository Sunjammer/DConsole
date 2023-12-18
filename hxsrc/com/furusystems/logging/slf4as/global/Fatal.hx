package com.furusystems.logging.slf4as.global ;
	import com.furusystems.logging.slf4as.Logging;
final class Fatal {
	
	public static function fatal( args:Array<ASAny> = null) {
if (args == null) args = [];
		Reflect.callMethod(null, Logging.root.fatal, args);
	}
}

