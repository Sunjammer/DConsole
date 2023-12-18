package com.furusystems.dconsole2.core.style.themes ;
	import com.furusystems.dconsole2.core.style.StyleManager;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class ConsoleTheme {
		var _xml:compat.XML;
		var _styleManager:StyleManager;
		var _themeData:ASObject;
		
		public function new(styleManager:StyleManager) {
			_styleManager = styleManager;
		}
		
		public function populate(xml:compat.XML) {
			_xml = xml;
			_themeData = populateFromNode(_xml);
		}
		
		function populateFromNode(node:compat.XML):ASObject {
			var o:ASObject = null;
			if (node.child("text" )!= /*undefined*/null) {
				try {
					o = _styleManager.colors.getColor(node.toString());
				} catch (e:Error) {
					//color lookup failed, so assume the theme file has a hex color
					o = ASCompat.toNumber(node.toString());
				}
			} else if (node.child("everything").length() > 0) {
				o = {};
				for (n in node.child("everything")) {
					o[n.localName()] = populateFromNode(n);
				}
			}
			return o;
		}
		
		@:flash.property public var data(get,never):ASObject;
function  get_data():ASObject {
			return _themeData;
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

