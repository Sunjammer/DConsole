package com.furusystems.dconsole2.core.style ;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 /*dynamic*/ class ColorCollection {
		var _xml:compat.XML;
		
		public function new() {
		
		}
		
		public function populate(xml:compat.XML) {
			_xml = xml;
		}
		
		public function getColor(name:String):UInt {
			name = name.toLowerCase();
			/*for(var n in _xml) {
				if (n.localName == name) {
					return uint(n.text);
				}
			}*/
			throw new Error("No such color '" + name + "'");
		}
		
				
		@:flash.property public var xml(get,set):compat.XML;
function  get_xml():compat.XML {
			return _xml;
		}
function  set_xml(value:compat.XML):compat.XML{
			populate(value);
return value;
		}
	
	}

