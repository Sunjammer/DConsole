package com.furusystems.dconsole2.core.style ;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	 class TextColors {
		public static var TEXT_USER:UInt = 0x859900;
		public static var TEXT_SYSTEM:UInt = 0x859900;
		public static var TEXT_DEBUG:UInt = 0x859900;
		public static var TEXT_INFO:UInt = 0x859900;
		public static var TEXT_WARNING:UInt = 0x859900;
		public static var TEXT_ERROR:UInt = 0x859900;
		public static var TEXT_FATAL:UInt = 0x859900;
		public static var TEXT_AUX:UInt = 0x859900;
		
		public static var TEXT_ASSISTANT:UInt = 0x859900;
		public static var TEXT_INPUT:UInt = 0x859900;
		public static var TEXT_TAG:UInt = 0;
		
		public static function update(sm:StyleManager) {
			TEXT_USER = sm.theme.data.output.text.user;
			TEXT_SYSTEM = sm.theme.data.output.text.system;
			TEXT_DEBUG = sm.theme.data.output.text.debug;
			TEXT_INFO = sm.theme.data.output.text.info;
			TEXT_WARNING = sm.theme.data.output.text.warning;
			TEXT_ERROR = sm.theme.data.output.text.error;
			TEXT_FATAL = sm.theme.data.output.text.fatal;
			TEXT_AUX = sm.theme.data.output.text.aux;
			TEXT_TAG = sm.theme.data.output.text.tag;
			
			TEXT_ASSISTANT = sm.theme.data.assistant.fore;
			TEXT_INPUT = sm.theme.data.input.fore;
		}
	
	}

