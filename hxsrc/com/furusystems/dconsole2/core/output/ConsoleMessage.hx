package com.furusystems.dconsole2.core.output ;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 final class ConsoleMessage {
		public var applicationTimeMS:Int = 0;
		public var timestamp:String = "";
		public var text:String = "";
		public var repeatcount:Int = 0;
		public var type:String;
		public var tag:String;
		public var truncated:Bool = false;
		public var visible:Bool = true;
		
		public function new(text:String, timestamp:String, type:String = "Info", tag:String = "") {
			this.tag = tag;
			this.text = text;
			this.timestamp = timestamp;
			this.type = type;
			applicationTimeMS = flash.Lib.getTimer();
		}
		
		public function toString():String {
			var out= type+":\t";
			out += text;
			return out;
		}
	
	}

