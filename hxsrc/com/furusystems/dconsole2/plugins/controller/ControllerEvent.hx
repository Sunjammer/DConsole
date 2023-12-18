package com.furusystems.dconsole2.plugins.controller 
;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class ControllerEvent extends Event 
	{
		public static inline final VALUE_CHANGE= "valuechange";
		public function new(type:String, bubbles:Bool=false, cancelable:Bool=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ControllerEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ControllerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
