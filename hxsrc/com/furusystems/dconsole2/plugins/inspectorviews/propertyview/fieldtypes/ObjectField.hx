package com.furusystems.dconsole2.plugins.inspectorviews.propertyview.fieldtypes
;
	import com.furusystems.dconsole2.DConsole;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class ObjectField extends PropertyField
	{
		
		public function new(console:DConsole, object:ASObject,property:String,type:String, access:String = "readwrite") 
		{
			super(console, object, property, type, access);
		}
		override public function updateFromSource() 
		{
			
		}
		
	}

