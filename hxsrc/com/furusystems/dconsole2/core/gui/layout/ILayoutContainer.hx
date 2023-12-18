package com.furusystems.dconsole2.core.gui.layout ;
	
	/**
	 * Describes a layout container that has an array of child IContainables
	 * @author Andreas Roenning
	 */
	 interface ILayoutContainer extends IContainable {
		@:flash.property var children(get,never):Array<ASAny>;
	}

