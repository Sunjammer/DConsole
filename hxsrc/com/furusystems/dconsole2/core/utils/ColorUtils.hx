package com.furusystems.dconsole2.core.utils ;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class ColorUtils {
		public static function gainColor24(input:UInt, gain:Int):UInt {
			return clamp24(input + 0x010101 * gain, 0xFFFFFF);
		}
		
		public static function clamp24(input:UInt, maxValue:UInt):UInt {
			return Std.int(Math.max(0, Math.min(input, maxValue)));
		}
	
	}

