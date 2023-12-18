package com.furusystems.dconsole2.core.persistence ;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.DConsole;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class PersistenceManager {
		var _persistenceDataSO:SharedObject;
		var _console:DConsole;
		public static inline final MAX_HISTORY= 10;
		
		public var verticalSplitRatio:PersistentProperty;
		public var dockState:PersistentProperty;
		public var previousCommands:PersistentProperty;
		var _width:PersistentProperty;
		var _height:PersistentProperty;
		var _x:PersistentProperty;
		var _y:PersistentProperty;
		var _commandIndex:Int = 0;
		
		public function toString():String {
			var out= "Persistence:\n";
			out += "\t" + verticalSplitRatio + "\n";
			out += "\t" + dockState + "\n";
			out += "\t" + previousCommands + "\n";
			out += "\t" + _x + "\n";
			out += "\t" + _y + "\n";
			out += "\t" + _width + "\n";
			out += "\t" + _height + "\n";
			return out;
		}
		
				
		@:flash.property public var consoleX(get,set):Float;
function  get_consoleX():Float {
			return _x.value;
		}
function  set_consoleX(n:Float):Float{
			_x.value = n;
return n;
		}
		
				
		@:flash.property public var consoleY(get,set):Float;
function  get_consoleY():Float {
			return _y.value;
		}
function  set_consoleY(n:Float):Float{
			_y.value = n;
return n;
		}
		
				
		@:flash.property public var consoleWidth(get,set):Float;
function  get_consoleWidth():Float {
			return _width.value;
		}
function  set_consoleWidth(n:Float):Float{
			_width.value = n;
return n;
		}
		
				
		@:flash.property public var consoleHeight(get,set):Float;
function  get_consoleHeight():Float {
			return _height.value;
		}
function  set_consoleHeight(n:Float):Float{
			_height.value = n;
return n;
		}
		
		@:flash.property public var rect(get,never):Rectangle;
function  get_rect():Rectangle {
			return new Rectangle(consoleX, consoleY, consoleWidth, consoleHeight);
		}
		
		public function new(console:DConsole) {
			_console = console;
			_persistenceDataSO = SharedObject.getLocal("consoleHistory");
			verticalSplitRatio = new PersistentProperty(_persistenceDataSO, "verticalSplitRatio", .25);
			dockState = new PersistentProperty(_persistenceDataSO, "dockState", 0);
			previousCommands = new PersistentProperty(_persistenceDataSO, "previousCommands", []);
			_width = new PersistentProperty(_persistenceDataSO, "width", 800);
			_height = new PersistentProperty(_persistenceDataSO, "height", 13 * GUIUnits.SQUARE_UNIT);
			_x = new PersistentProperty(_persistenceDataSO, "xPosition", 0);
			_y = new PersistentProperty(_persistenceDataSO, "yPosition", 0);
			_commandIndex = previousCommands.value.length;
		}
		
		public function clearHistory() {
			previousCommands.returnToDefault();
		}
		
		public function clearAll() {
			_x.returnToDefault();
			_y.returnToDefault();
			previousCommands.returnToDefault();
			dockState.returnToDefault();
			verticalSplitRatio.returnToDefault();
			_width.returnToDefault();
			_height.returnToDefault();
			_commandIndex = 0;
		}
		
		public function historyUp():String {
			var a:Array<ASAny> = previousCommands.value;
			if (a.length > 0) {
				_commandIndex = Std.int(Math.max(_commandIndex -= 1, 0));
				return a[_commandIndex];
			}
			return "";
		}
		
		public function historyDown():String {
			var a:Array<ASAny> = previousCommands.value;
			if (_commandIndex < a.length - 1) {
				_commandIndex = Std.int(Math.min(_commandIndex += 1, a.length - 1));
				return a[_commandIndex];
			}
			_commandIndex = a.length;
			return "";
		}
		
		public function addtoHistory(cmdStr:String):Bool {
			var a:Array<ASAny> = previousCommands.value;
			if (a[a.length - 1] != cmdStr) {
				a.push(cmdStr);
				if (a.length > MAX_HISTORY) {
					a.shift();
				}
			}
			_commandIndex = a.length;
			return true;
		}
	
	}

