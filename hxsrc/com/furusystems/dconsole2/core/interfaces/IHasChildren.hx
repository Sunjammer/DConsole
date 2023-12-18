package com.furusystems.dconsole2.core.interfaces ;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 interface IHasChildren {
		@:flash.property var children(get,never):Array<ASAny>;
	}

