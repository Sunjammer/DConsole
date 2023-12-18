package com.furusystems.dconsole2.plugins ;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class MathUtil implements IDConsolePlugin{
		
		public static function random(from:Float = 0, to:Float = 1, round:Bool = false):Float {
			var v= from + Math.random() * (to - from);
			return round ? Math.fround(v) : v;
		}
		
		public static function add(a:Float, b:Float):Float {
			return a + b;
		}
		
		public static function subtract(a:Float, b:Float):Float {
			return a - b;
		}
		
		public static function divide(a:Float, b:Float):Float {
			return a / b;
		}
		
		public static function multiply(a:Float, b:Float):Float {
			return a * b;
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager) {
			pm.console.createCommand("random", random, "Math", "Return a random value between X and Y, as an int if the third arg is true");
			pm.console.createCommand("add", add, "Math", "Add X to Y");
			pm.console.createCommand("subtract", subtract, "Math", "Subtract Y from X");
			pm.console.createCommand("divide", divide, "Math", "Divide X with Y");
			pm.console.createCommand("multiply", multiply, "Math", "Multiply X with Y");
		}
		
		public function shutdown(pm:PluginManager) {
			pm.console.removeCommand("random");
			pm.console.removeCommand("add");
			pm.console.removeCommand("subtract");
			pm.console.removeCommand("divide");
			pm.console.removeCommand("multiply");
		}
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String {
			return "Basic math functions";
		}
		
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> {
			return new Vector<Class<Dynamic>>();
		}
	
	}

