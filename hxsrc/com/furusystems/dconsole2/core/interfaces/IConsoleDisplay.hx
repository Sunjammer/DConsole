package com.furusystems.dconsole2.core.interfaces ;
	import com.furusystems.dconsole2.core.output.ConsoleMessage;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 interface IConsoleDisplay {
		@:flash.property var displayObject(get,never):DisplayObject;
				@:flash.property var visible(get,set):Bool;
		function redraw():Rectangle;
		function updateMessages(log:Vector<ConsoleMessage>):Void;
	}

