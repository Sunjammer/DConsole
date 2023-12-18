package com.furusystems.dconsole2.core.interfaces ;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 interface IScrollable {
		function scrollByDelta(x:Float, y:Float):Void;
				@:flash.property var scrollX(get,set):Float;
				@:flash.property var scrollY(get,set):Float;
		@:flash.property var maxScrollX(get,never):Float;
		@:flash.property var maxScrollY(get,never):Float;
		@:flash.property var scrollXEnabled(get,never):Bool;
		@:flash.property var scrollYEnabled(get,never):Bool;
	}

