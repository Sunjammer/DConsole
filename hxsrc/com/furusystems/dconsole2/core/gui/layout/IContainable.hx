package com.furusystems.dconsole2.core.gui.layout ;
	import flash.geom.Rectangle;
	
	/**
	 * Describes an object by a rectangle that can be contained in a layout container and influenced by its layout
	 * @author Andreas Roenning
	 */
	 interface IContainable {
		function onParentUpdate(allotedRect:Rectangle):Void;
		@:flash.property var rect(get,never):Rectangle;
				@:flash.property var x(get,set):Float;
				@:flash.property var y(get,set):Float;
		@:flash.property var minHeight(get,never):Float;
		@:flash.property var minWidth(get,never):Float;
	}

