package com.furusystems.logging.slf4as ;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	 interface ILogger {
		function info( args:Array<ASAny> = null):Void;
		function debug( args:Array<ASAny> = null):Void;
		function error( args:Array<ASAny> = null):Void;
		function warn( args:Array<ASAny> = null):Void;
		function fatal( args:Array<ASAny> = null):Void;
		function log(level:Int,  args:Array<ASAny> = null):Void;
		function setPatternType(type:Int):Void;
		function getPatternType():Int;
		
				@:flash.property var enabled(get,set):Bool;
	}

