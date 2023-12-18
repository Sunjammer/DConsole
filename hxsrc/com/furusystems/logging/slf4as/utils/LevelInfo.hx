package com.furusystems.logging.slf4as.utils ;
	import com.furusystems.logging.slf4as.constants.Levels;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	 class LevelInfo {
		public static function getID(level:String):Int {
			var u= level.toUpperCase();
			if ((Levels : ASAny)[u]) {
				return (Levels : ASAny)[u];
			}
			return Levels.DEBUG;
		}
		
		public static function getName(id:Int):String {
			switch (id) {
				case 0:
					return "ALL";
				case 1:
					return "DEBUG";
				case 2:
					return "INFO";
				case 3:
					return "WARN";
				case 4:
					return "ERROR";
				case 5:
					return "FATAL";
				default:
					return "NONE";
			}
		}
	}

