package com.furusystems.dconsole2.plugins.plugcollections 
;
	import com.furusystems.dconsole2.core.plugins.IPluginBundle;
	import com.furusystems.dconsole2.plugins.*;
	import com.furusystems.dconsole2.plugins.measurebracket.MeasurementBracketUtil;
	/**
	 * Collection of all basic plugins
	 * @author Andreas Roenning
	 */
	 class BasicPlugins implements IPluginBundle
	{
		
		var _plugins:Vector<Class<Dynamic>>;
		public function new() 
		{
			_plugins = Vector.ofArray(([
				BytearrayHexdumpUtil,
				ProductInfoUtil,
				ClassFactoryUtil,
				ScreenshotUtil,
				FontUtil,
				JSRouterUtil,
				MeasurementBracketUtil,
				MouseUtil,
				SystemInfoUtil,
				StatsOutputUtil,
				JSONParserUtil,
				StageUtil,
				SelectionHistoryUtil
			] : Array<Class<Dynamic>>));
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IPluginBundle */
		
		@:flash.property public var plugins(get,never):Vector<Class<Dynamic>>;
function  get_plugins():Vector<Class<Dynamic>>
		{
			return _plugins;
		}
		
	}

