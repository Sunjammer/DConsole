package com.furusystems.dconsole2.plugins.monitoring 
;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 final class GraphValue
	{
		
		public var next:GraphValue = null;
		public var value:Float = 0;
		public var creationTime:Int = 0;
		public function new() 
		{
			
		}
	}

