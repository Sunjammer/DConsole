package com.furusystems.logging.slf4as.global ;
	import com.furusystems.logging.slf4as.Logging;
final class Info {
	
	public static function info( args:Array<ASAny> = null) {
if (args == null) args = [];
		Reflect.callMethod(null, Logging.root.info, args);
	}
}
