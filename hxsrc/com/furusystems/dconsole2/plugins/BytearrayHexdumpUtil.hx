package com.furusystems.dconsole2.plugins ;
	import com.furusystems.messaging.pimp.MessageData;
	import flash.utils.ByteArray;
	
	import com.furusystems.dconsole2.core.introspection.ScopeManager;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	
	 class BytearrayHexdumpUtil implements IDConsolePlugin {
		public static var useUpperCase:Bool = false;
		
		var chars:Array<ASAny>;
		
		public function dumpByteArray(byteArray:ByteArray, startIndex:UInt = 0, endIndex:Int = -1, tab:String = ""):String {
			var i:Int, j:Int, len:Int = byteArray.length;
			var line:String, result:String;
			var byte:UInt;
			
			if (endIndex == -1 || endIndex > len) {
				endIndex = len;
			}
			
			if ((startIndex < 0) || (startIndex > (len : UInt))) {
				throw new RangeError("Start Index Is Out of Bounds: " + startIndex + "/" + len);
			}
			
			if ((endIndex < 0) || (endIndex > len) || ((endIndex : UInt) < startIndex)) {
				throw new RangeError("End Index Is Out of Bounds: " + endIndex + "/" + len);
			}
			
			j = 1;
			result = line = "";
			
			for (_tmp_ in startIndex...endIndex) {
i = _tmp_;
				
				if (j == 1) {
					line += tab + padLeft(ASCompat.toRadix(i, 16), 8, "0") + "  ";
					chars = [];
				}
				
				byte = byteArray[i];
				chars.push(byte);
				line += padLeft(ASCompat.toRadix(byte, 16), 2, "0") + " ";
				
				if ((j % 4) == 0) {
					line += " ";
				}
				
				j++;
				
				if (j == 17) {
					line += dumpChars();
					result += (line + "\n");
					j = 1;
					line = "";
				}
			}
			
			if (j != 1) {
				line = padRight(line, 61, " ") + " " + dumpChars();
				result += line + "\n";
			}
			
			result = result.substr(0, result.length - 1);
			
			return useUpperCase ? result.toUpperCase() : result;
		}
		
		function dumpChars():String {
			var byte:UInt;
			var result= "";
			while (chars.length != 0) {
				byte = chars.shift();
				if (byte >= 32 && byte <= 126) { // Only show printable characters
					result += String.fromCharCode(byte);
				} else {
					result += ".";
				}
			}
			return result;
		}
		
		function padLeft(value:String, digits:UInt, pad:String):String {
			return ASCompat.allocArray(digits - value.length + 1).join(pad) + value;
		}
		
		function padRight(value:String, digits:UInt, pad:String):String {
			return value + ASCompat.allocArray(digits - value.length + 1).join(pad);
		}
		var _hexDumpPos:UInt = 0;
		var _scopeManager:ScopeManager;
		
		public function hexDump(startIndex:String = "", len:String = ""):String {
			var _startIndex:Int, _endIndex:Int, _len:Int;
			var b= ASCompat.dynamicAs(_scopeManager.currentScope.targetObject , ByteArray);
			var result:String;
			
			if (b != null) {
				try {
					_startIndex = ((startIndex == "") ? _hexDumpPos : Std.parseInt(startIndex));
					_len = ((len == "") ? -1 : Std.parseInt(len));
					
					if (Math.isNaN(_startIndex) || Math.isNaN(_len)) {
						throw new Error();
					}
					_endIndex = (_len == -1) ? (_startIndex + 160) : (_startIndex + _len);
					result = dumpByteArray(b, _startIndex, _endIndex);
					_hexDumpPos = _endIndex;
				} catch (e:Error) {
					//trace(e);
					throw new Error("Parameters are invalid");
				}
				
				return result;
			} else {
				throw new Error("Current scope is not a byte array");
			}
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager) {
			_scopeManager = pm.scopeManager;
			pm.console.createCommand("hexDump", hexDump, "HexUtil", "(if the current scope is a byte array) outputs the scope in paged hexadecimal view ");
			pm.messaging.addCallback(Notifications.SCOPE_CHANGE_COMPLETE, onScopeChange);
		}
		
		function onScopeChange(md:MessageData) {
			_hexDumpPos = 0;
		}
		
		public function shutdown(pm:PluginManager) {
			pm.messaging.removeCallback(Notifications.SCOPE_CHANGE_COMPLETE, onScopeChange);
			_scopeManager = null;
			pm.console.removeCommand("hexDump");
		}
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String {
			return "Enables the reading of ByteArrays as paged, tabulated hexadecimal";
		}
		
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> {
			return null;
		}
	}
