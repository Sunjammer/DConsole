package com.furusystems.logging.slf4as.loggers ;
	import com.furusystems.logging.slf4as.constants.Levels;
	import com.furusystems.logging.slf4as.constants.PatternTypes;
	import com.furusystems.logging.slf4as.ILogger;
	import com.furusystems.logging.slf4as.Logging;
	import com.furusystems.logging.slf4as.utils.LevelInfo;
	import com.furusystems.logging.slf4as.utils.PatternResolver;
	import com.furusystems.logging.slf4as.utils.TagCreator;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	 class Logger implements ILogger {
		var _owner:Class<Dynamic>;
		var _tag:String;
		var _patternType:Int = PatternTypes.NONE;
		var _inheritPattern:Bool = true;
		var _useAppName:Bool = false;
		var _enabled:Bool = true;
		
		public function new(owner:ASAny) {
			_owner = owner;
			if (_owner == Logging && Logging.getDefaultLoggerTag() != Logging.DEFAULT_APP_NAME) {
				_useAppName = true;
			} else {
				_tag = TagCreator.getTag(owner);
			}
		}
		
		/* INTERFACE com.furusystems.logging.slf4as.ILogger */
		
		public function info( args:Array<ASAny> = null) {
if (args == null) args = [];
			Reflect.callMethod(this, log, [Levels.INFO].concat(args));
		}
		
		public function debug( args:Array<ASAny> = null) {
if (args == null) args = [];
			Reflect.callMethod(this, log, [Levels.DEBUG].concat(args));
		}
		
		public function error( args:Array<ASAny> = null) {
if (args == null) args = [];
			Reflect.callMethod(this, log, [Levels.ERROR].concat(args));
		}
		
		public function warn( args:Array<ASAny> = null) {
if (args == null) args = [];
			Reflect.callMethod(this, log, [Levels.WARN].concat(args));
		}
		
		public function fatal( args:Array<ASAny> = null) {
if (args == null) args = [];
			Reflect.callMethod(this, log, [Levels.FATAL].concat(args));
		}
		
		public function log(level:Int,  args:Array<ASAny> = null) {
if (args == null) args = [];
			if (Logging.getLevel() > level || !_enabled)
				return;
			var time:Float = flash.Lib.getTimer();
			var levelStr= LevelInfo.getName(level);
			var out= PatternResolver.resolve(getPatternType(), args);
			Logging.print(getTag(), levelStr, out);
		}
		
		function getTag():String {
			if (_useAppName) {
				return Logging.getDefaultLoggerTag();
			}
			return _tag;
		}
		
		public function setPatternType(type:Int) {
			_patternType = type;
			_inheritPattern = false;
		}
		
		public function getPatternType():Int {
			if (_inheritPattern) {
				return Logging.getPatternType();
			}
			return _patternType;
		}
		
		/* INTERFACE com.furusystems.logging.slf4as.ILogger */
		
				
		@:flash.property public var enabled(get,set):Bool;
function  get_enabled():Bool {
			return _enabled;
		}
function  set_enabled(value:Bool):Bool{
			return _enabled = value;
		}
	
	}

