package com.furusystems.dconsole2.plugins 
;
	import flash.system.System;
	import com.furusystems.dconsole2.core.gui.maindisplay.assistant.Assistant;
	import com.furusystems.dconsole2.core.plugins.IUpdatingDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	/**
	 * ...
	 * @author Andreas Roenning, Mr.doob
	 */
	 class StatsOutputUtil implements IUpdatingDConsolePlugin
	{
		var _assistant:Assistant;

		var _timer : UInt = 0;
		var _fps : UInt = 0;
		var _ms : UInt = 0;
		var _ms_prev : UInt = 0;
		var _mem : Float = Math.NaN;
		var _mem_max : Float = Math.NaN;
		var _fpsStat:Float = 0;
		public function new() 
		{
			
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String
		{
			return "Outputs memory use and FPS to idle Assistant";
		}
		
		public function initialize(pm:PluginManager)
		{
			_assistant = pm.console.view.assistant;
			_fpsStat;
		}
		
		public function shutdown(pm:PluginManager)
		{
			_assistant = null;
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IUpdatingDConsolePlugin */
		
		public function update(pm:PluginManager)
		{
			if (!_assistant.visible) return;
			var out= getStats();
			if (_assistant.idle) {
				_assistant.setWeakText(out);
			}
		}
		
		/**
		 * Cannibalized from hires stats
		 */
		function getStats():String
		{
			var output= "";
			_timer = flash.Lib.getTimer();
			if( _timer - 1000 > _ms_prev )
			{
				_ms_prev = _timer;
				_mem = ASCompat.toNumber(ASCompat.toFixed((System.totalMemory * 0.000000954), 3));
				_mem_max = _mem_max > _mem ? _mem_max : _mem;
				_fpsStat = _fps;
				_fps = 0;
			}
			_fps++;
			
			output += "FPS: " + _fpsStat + "/" + _assistant.stage.frameRate;
			output += " MS: " + (_timer - _ms);
			output += " MEM(mb): " + _mem + "/" + _mem_max;
			_ms = _timer;
			
			return output;
		}
		
				
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> 
		{
			return null;
		}
		
	}

