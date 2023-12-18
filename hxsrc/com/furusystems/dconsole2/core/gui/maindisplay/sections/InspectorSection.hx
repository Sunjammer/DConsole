package com.furusystems.dconsole2.core.gui.maindisplay.sections ;
	import com.furusystems.dconsole2.core.inspector.Inspector;
	import com.furusystems.dconsole2.IConsole;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class InspectorSection extends ConsoleViewSection {
		
		public var inspector:Inspector;
		
		public function new(console:IConsole) {
			super();
			inspector = new Inspector(console, new Rectangle(0, 0, 50, 50));
			addChild(inspector);
		}
		
		override public function onParentUpdate(allotedRect:Rectangle) {
			inspector.onParentUpdate(allotedRect);
		}
	
	}

