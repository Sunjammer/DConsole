package com.furusystems.dconsole2.core.gui.maindisplay.sections ;
	import com.furusystems.dconsole2.core.DSprite;
	import com.furusystems.dconsole2.core.gui.layout.IContainable;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class ConsoleViewSection extends DSprite implements IContainable {
		
		public function new() {
			super();
		
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.gui.layout.IContainable */
		
		public function onParentUpdate(allotedRect:Rectangle) {
		
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.gui.layout.IContainable */
		
		@:flash.property public var minHeight(get,never):Float;
function  get_minHeight():Float {
			return 0;
		}
		
		@:flash.property public var minWidth(get,never):Float;
function  get_minWidth():Float {
			return 0;
		}
		
		@:flash.property public var rect(get,never):Rectangle;
function  get_rect():Rectangle {
			return getRect(parent);
		}
	
	}

