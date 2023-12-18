package com.furusystems.dconsole2.plugins.plugcollections
;
	import com.furusystems.dconsole2.core.plugins.IPluginBundle;
	import com.furusystems.dconsole2.plugins.BatchRunnerUtil;
	import com.furusystems.dconsole2.plugins.BytearrayHexdumpUtil;
	import com.furusystems.dconsole2.plugins.ClassFactoryUtil;
	import com.furusystems.dconsole2.plugins.colorpicker.ColorPickerUtil;
	import com.furusystems.dconsole2.plugins.CommandMapperUtil;
	import com.furusystems.dconsole2.plugins.controller.ControllerUtil;
	import com.furusystems.dconsole2.plugins.dialog.DialogUtil;
	import com.furusystems.dconsole2.plugins.FontUtil;
	import com.furusystems.dconsole2.plugins.inspectorviews.inputmonitor.InputMonitorUtil;
	import com.furusystems.dconsole2.plugins.inspectorviews.propertyview.PropertyViewUtil;
	import com.furusystems.dconsole2.plugins.inspectorviews.treeview.TreeViewUtil;
	import com.furusystems.dconsole2.plugins.invokegesture.InvokeGestureUtil;
	import com.furusystems.dconsole2.plugins.JSONParserUtil;
	import com.furusystems.dconsole2.plugins.JSRouterUtil;
	import com.furusystems.dconsole2.plugins.MathUtil;
	import com.furusystems.dconsole2.plugins.measurebracket.MeasurementBracketUtil;
	import com.furusystems.dconsole2.plugins.mediatester.MediaTesterUtil;
	import com.furusystems.dconsole2.plugins.MouseUtil;
	import com.furusystems.dconsole2.plugins.PerformanceTesterUtil;
	import com.furusystems.dconsole2.plugins.ProductInfoUtil;
	import com.furusystems.dconsole2.plugins.ScreenshotUtil;
	import com.furusystems.dconsole2.plugins.SelectionHistoryUtil;
	import com.furusystems.dconsole2.plugins.StageUtil;
	import com.furusystems.dconsole2.plugins.StatsOutputUtil;
	import com.furusystems.dconsole2.plugins.SystemInfoUtil;
	/**
	 * Collection of all available plugins
	 * @author Andreas Roenning
	 */
	 class AllPlugins implements IPluginBundle
	{
		var _plugins:Vector<Class<Dynamic>>;
		public function new()
		{
			_plugins = Vector.ofArray(([
				BytearrayHexdumpUtil,
				ProductInfoUtil,
				MeasurementBracketUtil,
				ColorPickerUtil,
				ClassFactoryUtil,
				DialogUtil,
				ControllerUtil,
				BatchRunnerUtil,
				MediaTesterUtil,
				ScreenshotUtil,
				FontUtil,
				JSRouterUtil,
				MouseUtil,
				SystemInfoUtil,
				StatsOutputUtil,
				PerformanceTesterUtil,
				CommandMapperUtil,
				JSONParserUtil,
				PropertyViewUtil,
				StageUtil,
				InvokeGestureUtil,
				InputMonitorUtil,
				TreeViewUtil,
				SelectionHistoryUtil,
				MathUtil
			] : Array<Class<Dynamic>>));
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IPluginBundle */
		
		@:flash.property public var plugins(get,never):Vector<Class<Dynamic>>;
function  get_plugins():Vector<Class<Dynamic>>
		{
			return _plugins;
		}
		
	}

