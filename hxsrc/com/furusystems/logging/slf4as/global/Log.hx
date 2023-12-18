package com.furusystems.logging.slf4as.global ;
	
	import com.furusystems.logging.slf4as.Logging;
final class Log {
	
	public static function log(level:String,  args:Array<ASAny> = null) {
if (args == null) args = [];
		Reflect.callMethod(null, Logging.root.log, [level].concat(args));
	}
}
