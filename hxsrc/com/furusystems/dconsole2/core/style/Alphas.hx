package com.furusystems.dconsole2.core.style ;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class Alphas {
		public static var CONSOLE_CORE_ALPHA:Float = .9;
		public static var INSPECTOR_ALPHA:Float = .9;
		public static var TREEVIEW_BG_ALPHA:Float = .9;
		
		public static function update(sm:StyleManager) {
			CONSOLE_CORE_ALPHA = ASCompat.toNumber(ASCompat.toString(sm.theme.data.core.alpha));
			INSPECTOR_ALPHA = ASCompat.toNumber(ASCompat.toString(sm.theme.data.inspector.alpha));
			TREEVIEW_BG_ALPHA = ASCompat.toNumber(ASCompat.toString(sm.theme.data.inspector.treeview.alpha));
		}
	}

