package com.furusystems.dconsole2.core.plugins ;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 interface IPluginBundle {
		@:flash.property var plugins(get,never):Vector<Class<Dynamic>>;
	}

