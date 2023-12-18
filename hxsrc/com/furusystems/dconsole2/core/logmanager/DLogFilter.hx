package com.furusystems.dconsole2.core.logmanager ;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class DLogFilter {
		public var term:String;
		public var tag:String;
		
		public function new(term:String = "", tag:String = "") {
			this.term = term;
			this.tag = tag;
		}
		
		@:flash.property public var id(get,never):String;
function  get_id():String {
			return term + tag;
		}
	
	}

