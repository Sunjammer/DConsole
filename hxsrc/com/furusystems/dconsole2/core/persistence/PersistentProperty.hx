package com.furusystems.dconsole2.core.persistence ;
	import com.furusystems.dconsole2.core.utils.Property;
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author Andreas Ronning
	 */
	 class PersistentProperty extends Property {
		var _sharedObject:SharedObject;
		var _fieldName:String;
		var _initValue:ASAny;
		var _synced:Bool = false;
		
		public function new(sharedObject:SharedObject, fieldName:String, initValue:ASAny = null) {
			super(initValue);
			_initValue = initValue;
			_fieldName = fieldName;
			_sharedObject = sharedObject;
		}
		
		public function returnToDefault() {
			value = _initValue;
		}
		
		override function  get_value():ASAny {
			if (!_synced) {
				consolidate();
			}
			return _sharedObject.data[_fieldName];
		}
		
		override function  set_value(value:ASAny):ASAny{
			//if (!_synced) {
				//consolidate();
			//}
			_synced = false;
			super.value = value;
			_sharedObject.data[_fieldName] = super.value;
return value;
		}
		
		override public function toString():String {
			return _fieldName + " : " + super.toString();
		}
		
		function consolidate() {
			if (_sharedObject.data[_fieldName]) {
				super.value = _sharedObject.data[_fieldName];
			} else {
				super.value = _initValue;
				_sharedObject.data[_fieldName] = _initValue;
			}
			setClean();
			_synced = true;
		}
	
	}

