package com.furusystems.dconsole2.core.helpmanager ;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	 class HelpTopic {
		public var content:String;
		public var title:String;
		
		public function new(title:String, content:String = "") {
			this.content = content;
			this.title = title;
		}
		
		public function toString():String {
			return title + "\n" + content;
		}
	
	}

