package com.furusystems.dconsole2.core.strings ;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class StringCollection {
		var _dictionary:ASDictionary<ASAny,ASAny> = new ASDictionary(false);
		
		public function populate(xml:compat.XML) {
			for (node in xml.child("string")) {
				_dictionary[node.attribute("id")] = node.toString();
			}
		}
		
		public function get(id:String):String {
			if (_dictionary[id] != null) {
				return _dictionary[id];
			}
			return "undefined";
		}
	
	}

