package com.furusystems.dconsole2.plugins.inspectorviews.inputmonitor 
;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	 class KeyboardAccumulator 
	{
		var _keys:ASDictionary<ASAny,ASAny> = new ASDictionary();
		var _stage:Stage;
		public function new(stage:Stage)
		{
			this._stage = stage;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, ASCompat.MAX_INT);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, ASCompat.MAX_INT);
		}
		
		function onKeyUp(e:KeyboardEvent) 
		{
			_keys.remove("" + e.keyCode);
		}
		
		function onKeyDown(e:KeyboardEvent) 
		{
			_keys[""+e.keyCode] = e.charCode;
		}
		public function toString():String {
			var count= 0;
			var out= "Active keys:\n";
			for (_tmp_ in _keys.keys()) {
var key:String  = _tmp_;
				count++;
				out += "\tkc"+key + " / " + "cc "+_keys[key] + "\n";
			}
			if (count > 0) return out;
			return "";
		}
		
		public function dispose() 
		{
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
	}

