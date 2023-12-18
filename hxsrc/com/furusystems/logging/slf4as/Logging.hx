package com.furusystems.logging.slf4as ;
	import com.furusystems.logging.slf4as.bindings.ILogBinding;
	import com.furusystems.logging.slf4as.bindings.TraceBinding;
	import com.furusystems.logging.slf4as.constants.Levels;
	import com.furusystems.logging.slf4as.constants.PatternTypes;
	import com.furusystems.logging.slf4as.loggers.Logger;
	import com.furusystems.logging.slf4as.utils.TagCreator;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	 class Logging {
		public static inline final DEFAULT_APP_NAME= "Log";
		
		static var _root:ILogger;
		static var _logBinding:ILogBinding = new TraceBinding();
		
		static var _patternType:Int = PatternTypes.SLF;
		static var _appName:String = "Log";
		static var _minLevel:Int = Levels.ALL;
		static var _whitelist:ASDictionary<ASAny,ASAny>;
		static var _blankWhiteList:Bool = true;
		
		static var _nativeTrace:Bool = false;
		static var _traceLineNumber:Int = 0;
		
		@:flash.property public static var root(get,never):ILogger;
static function  get_root():ILogger {
			if (_root == null) {
				_root = new Logger(Logging);
			}
			return _root;
		}
		
				
		@:flash.property public static var logBinding(get,set):ILogBinding;
static function  get_logBinding():ILogBinding {
			return _logBinding;
		}
static function  set_logBinding(binding:ILogBinding):ILogBinding{
			return _logBinding = binding;
		}
		
				
		@:flash.property public static var useNativeTrace(get,set):Bool;
static function  get_useNativeTrace():Bool {
			return _nativeTrace;
		}
static function  set_useNativeTrace(value:Bool):Bool{
			return _nativeTrace = value;
		}
		
		static public function print(owner:ASObject, level:String, str:String) {
			if (_logBinding != null) {
				if (_blankWhiteList) {
					_logBinding.print(owner, level, str);
				} else {
					if (_whitelist[owner] != null) {
						_logBinding.print(owner, level, str);
					}
				}
			}
			if (_nativeTrace) {
				trace(owner + "\t[" + level + "]\t" + str);
			}
		}
		
		public static function setPatternType(type:Int) {
			_patternType = type;
		}
		
		public static function getPatternType():Int {
			return _patternType;
		}
		
		static public function getDefaultLoggerTag():String {
			return _appName;
		}
		
		static public function setDefaultLoggerTag(name:String) {
			_appName = name.split(" ").join("_");
		}
		
		public static function getLogger(owner:ASAny):ILogger {
			return new Logger(owner);
		}
		
		static public function setLevel(minlevel:Int) {
			_minLevel = minlevel;
		}
		
		static public function getLevel():Int {
			return _minLevel;
		}
		
		static public function whitelist( owners:Array<ASAny> = null) {
if (owners == null) owners = [];
			_whitelist = new ASDictionary<ASAny,ASAny>();
			var i= owners.length;while (i-- != 0) {
				if (Std.is(owners[i] , Class)) {
					owners[i] = TagCreator.getTag(owners[i]);
				}
				_whitelist[owners[i]] = true;
			}
			_blankWhiteList = owners.length == 0;
		}
		
		public static function isWhitelisted(tag:String):Bool {
			return _whitelist[tag] != null;
		}
	
	}

