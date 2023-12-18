package com.furusystems.dconsole2.plugins 
;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.IConsole;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class StageUtil implements IDConsolePlugin
	{
		var _console:IConsole;
		
		public function new() 
		{
			
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String
		{
			return "Adds commands for common stage operations";
		}
		
		public function initialize(pm:PluginManager)
		{
			_console = pm.console;
			_console.createCommand("alignStage", alignStage, "Stage", "Sets stage.align to TOP_LEFT and stage.scaleMode to NO_SCALE");
			_console.createCommand("setFrameRate", setFramerate, "Stage", "Sets stage.frameRate");
			_console.createCommand("toggleFullscreen", toggleFullscreen, "FullscreenUtil", "Toggles stage.displayState between FULL_SCREEN and NORMAL");

		}
		function setFramerate(rate:Int = 60)
		{
			_console.view.stage.frameRate = rate;
			_console.print("Framerate set to " + _console.view.stage.frameRate, ConsoleMessageTypes.SYSTEM);
		}
		function alignStage()
		{
			_console.view.stage.align = StageAlign.TOP_LEFT;
			_console.view.stage.scaleMode = StageScaleMode.NO_SCALE;
			_console.print("StageAlign set to TOP_LEFT, StageScaleMode set to NO_SCALE", ConsoleMessageTypes.SYSTEM);
		}
		function toggleFullscreen() {
			switch(_console.view.stage.displayState) {
				case StageDisplayState.FULL_SCREEN:
				_console.view.stage.displayState = StageDisplayState.NORMAL;
				
				case StageDisplayState.NORMAL:
				_console.view.stage.displayState = StageDisplayState.FULL_SCREEN;
				
			}
		}
		
		public function shutdown(pm:PluginManager)
		{
			_console.removeCommand("alignStage");
			_console.removeCommand("setFrameRate");
			_console.removeCommand("toggleFullscreen");
			_console = null;
		}
		
				
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> 
		{
			return null;
		}
		
	}

