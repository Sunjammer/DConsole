package com.furusystems.dconsole2.core.introspection.descriptions ;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class ParamDesc {
		//<parameter index="1" type="flash.display::DisplayObject" optional="false"/>
		public var index:Int = 0;
		public var type:String;
		public var optional:Bool = false;
		
		public function new(xml:compat.XML) {
			index = ASCompat.toInt(xml.attribute("index"));
			type = xml.attribute("type");
			optional = ASCompat.stringAsBool(xml.attribute("optional"));
		}
	
	}

