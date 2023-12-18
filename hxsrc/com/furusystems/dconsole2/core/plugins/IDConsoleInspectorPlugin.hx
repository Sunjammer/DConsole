package com.furusystems.dconsole2.core.plugins ;
	import com.furusystems.dconsole2.core.inspector.AbstractInspectorView;
	import com.furusystems.dconsole2.core.inspector.Inspector;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 interface IDConsoleInspectorPlugin extends IUpdatingDConsolePlugin {
		@:flash.property var view(get,never):AbstractInspectorView;
		function associateWithInspector(inspector:Inspector):Void;
		@:flash.property var title(get,never):String;
	}

