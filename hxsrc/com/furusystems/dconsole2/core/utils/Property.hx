package com.furusystems.dconsole2.core.utils ;
	
	 class Property {
		var _previousValue:ASAny = null;
		
		public function new(value:ASAny = null) {
			_value = _previousValue = value;
		}
		var _value:ASAny = null;
		var _dirty:Bool = false;
		
				
		@:flash.property public var value(get,set):ASAny;
function  get_value():ASAny {
			return _value;
		}
function  set_value(value:ASAny):ASAny{
			_value = value;
			_dirty = _value != _previousValue;
return value;
		}
		
		@:flash.property public var dirty(get,never):Bool;
function  get_dirty():Bool {
			return _dirty;
		}
		
		public function setClean() {
			_previousValue = _value;
			_dirty = false;
		}
		
		public function revert() {
			_value = _previousValue;
			_dirty = false;
		}
		
		public function toString():String {
			return "" + value + " (prev '" + _previousValue + "')";
		}
		
		public function dispose() {
			_value = _previousValue = null;
		}
	
	}

