package com.furusystems.dconsole2.core.input ;
	import flash.events.KeyboardEvent;
	
	/**
	 * KeyboardList Interface
	 *
	 * @author Cristobal Dabed
	 * @version 0.1
	 */
	/*internal*/ interface KeyboardList {
		function onKeyUp(event:KeyboardEvent):Bool;
		function onKeyDown(event:KeyboardEvent):Bool;
		function removeAll():Void;
		function isEmpty():Bool;
	}
