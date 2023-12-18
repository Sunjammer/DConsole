package com.furusystems.dconsole2.core.utils ;
	
	/**
	 * Stop watch
	 *
	 * @author Cristobal Dabed
	 */
	 final class StopWatch {
		var _startTime:Int = 0;
		var _stopTime:Int = 0;
		var _running:Bool = false;
		
		public function new() {
		}
		
		/**
		 * Start
		 *
		 * @param reset Optional reset flag, wether to reset the timer on start.
		 */
		public function start(reset:Bool = false) {
			if (reset) {
				this.reset();
			}
			_startTime = flash.Lib.getTimer();
			_running = true;
		}
		
		/**
		 * Stop
		 */
		public function stop() {
			_stopTime = flash.Lib.getTimer();
			_running = false;
		}
		
		/**
		 * Reset
		 */
		public function reset() {
			_startTime = 0;
			_stopTime = 0;
			_running = false;
		}
		
		/**
		 * @readonly startTime
		 */
		@:flash.property public var startTime(get,never):Int;
function  get_startTime():Int {
			return _startTime;
		}
		
		/**
		 * @readonly stopTime
		 */
		@:flash.property public var stopTime(get,never):Int;
function  get_stopTime():Int {
			return _stopTime;
		}
		
		/**
		 * @readonly elapsedTime
		 */
		@:flash.property public var elapsedTime(get,never):Int;
function  get_elapsedTime():Int {
			var value= stopTime - startTime;
			if (_running) {
				value = flash.Lib.getTimer() - startTime;
			}
			return value;
		}
		
		/**
		 * @readonly elapsedTimeSeconds
		 */
		@:flash.property public var elapsedTimeSeconds(get,never):Float;
function  get_elapsedTimeSeconds():Float {
			return elapsedTime / 1000;
		}
	}
