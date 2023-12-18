package com.furusystems.dconsole2.core.plugins ;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 interface IDConsolePlugin {
		/**
		 * Called to initialize the plugin, instantiate it on stage, register event listeners etc
		 * @param	pm
		 */
		function initialize(pm:PluginManager):Void;
		/**
		 * Called to shut down the plugin, remove it from stage, unregister event listeners etc
		 * @param	pm
		 */
		function shutdown(pm:PluginManager):Void;
		/**
		 * Should return a short text describing this plugin
		 */
		@:flash.property var descriptionText(get,never):String;
		
		/**
		 * Returns a list of plugin types this plugin requires
		 */
		@:flash.property var dependencies(get,never):Vector<Class<Dynamic>>;
	}

