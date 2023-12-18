package com.furusystems.dconsole2.core.inspector ;
	import com.furusystems.dconsole2.core.interfaces.IScrollable;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 interface IInspectorView extends IScrollable {
				@:flash.property var visible(get,set):Bool;
		function beginDragging():Void;
		function stopDragging():Void;
		function onFrameUpdate(e:Event = null):Void;
		function resize():Void;
	}

