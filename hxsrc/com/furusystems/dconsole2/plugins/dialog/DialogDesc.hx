package com.furusystems.dconsole2.plugins.dialog 
;
	/**
	 * Describes a full set of questions/responses for a dialog
	 * @author Andreas Ronning
	 */
	 class DialogDesc 
	{
		public var requests:Array<ASAny> = [];
		public function new(requests:Array<ASAny> = null) 
		{
if (requests == null) requests = [];
			this.requests = requests;
		}
		
	}

