package com.furusystems.dconsole2.core.introspection.descriptions ;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class MethodDesc extends NamedDescription {
		// <method name="hitTestObject" declaredBy="flash.display::DisplayObject" returnType="Boolean">
		public var declaredBy:String;
		public var returnType:String;
		public var params:Vector<ParamDesc> = new Vector();
		
		public function new(xml:compat.XML) {
			super();
			name = xml.attribute("name");
			declaredBy = xml.attribute("declaredBy");
			returnType = xml.attribute("returnType");
			for (n in xml.descendants("parameter")) {
				params.push(new ParamDesc(n));
			}
		}
	
	}

