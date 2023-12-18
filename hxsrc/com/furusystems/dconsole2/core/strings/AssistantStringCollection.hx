package com.furusystems.dconsole2.core.strings ;

	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class AssistantStringCollection extends StringCollection {
		var StringXML:Class<Dynamic>;

		public function new() {
			populate(new compat.XML(Type.createInstance(StringXML, [])));
		}
		
		public static inline final SCALE_HANDLE_ID= "scalehandle";
		public static inline final CORNER_HANDLE_ID= "cornerhandle";
		public static inline final HEADER_BAR_ID= "headerbar";
		public static inline final DEFAULT_ID= "default";

	}

