package com.furusystems.dconsole2.core.introspection.descriptions ;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class AccessorDesc extends NamedDescription {
		//<accessor name="stage" access="readonly" type="flash.display::Stage" declaredBy="flash.display::DisplayObject"/>
		public var access:String;
		public var type:String;
		public var declaredBy:String;
		
		public function new(xml:compat.XML) {
			super();
			name = xml.attribute("name");
			access = xml.attribute("access");
			type = xml.attribute("type");
			declaredBy = xml.attribute("declaredBy");
		}
		
		public function toString():String {
			return "Acc: " + name + ":" + access + ":" + type + ":" + declaredBy;
		}
	
	}

