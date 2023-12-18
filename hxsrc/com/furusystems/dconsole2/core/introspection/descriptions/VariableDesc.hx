package com.furusystems.dconsole2.core.introspection.descriptions ;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class VariableDesc extends NamedDescription {
		public var type:String;
		
		public function new(xml:compat.XML) {
			super();
			this.name = xml.attribute("name");
			this.type = xml.attribute("type");
		}
	
	}

