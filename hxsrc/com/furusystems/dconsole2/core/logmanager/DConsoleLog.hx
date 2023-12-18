package com.furusystems.dconsole2.core.logmanager ;
	import com.furusystems.dconsole2.core.output.ConsoleMessage;
	
	/**
	 * Encapsulates a vector of messages, grouped
	 * @author Andreas Roenning
	 */
	 class DConsoleLog {
		var _messages:Vector<ConsoleMessage> = new Vector();
		var _name:String;
		var _dirty:Bool = true;
		var _manager:DLogManager;
		var _destroyed:Bool = false;
		var _prevMessage:ConsoleMessage = null;
		
		public function new(name:String, manager:DLogManager) {
			_name = name;
			_manager = manager;
		}
		
		public function toString():String {
			var out= "";
			var i= 0;while (i < _messages.length) 
			{
				out += _messages[i].toString() + "\r\n";
i++;
			}
			return out;
		}
		
		@:flash.property public var messages(get,never):Vector<ConsoleMessage>;
function  get_messages():Vector<ConsoleMessage> {
			return _messages;
		}
		
		@:flash.property public var name(get,never):String;
function  get_name():String {
			return _name;
		}
		
		@:flash.property public var prevMessage(get,never):ConsoleMessage;
function  get_prevMessage():ConsoleMessage {
			if (messages.length > 0){

				return messages[messages.length - 1];
			}
			else{

				return null;
			}
		}
		
		public function destroy() {
			if (_destroyed)
				return;
			_manager.removeLog(name);
			_manager = null;
			_destroyed = true;
		}
		
		@:flash.property public var length(get,never):Int;
function  get_length():Int {
			return messages.length;
		}
		
		public function clear() {
			_messages = new Vector<ConsoleMessage>();
			_dirty = true;
		}
		
		@:flash.property public var dirty(get,never):Bool;
function  get_dirty():Bool {
			return _dirty;
		}
		
		@:flash.property public var manager(get,never):DLogManager;
function  get_manager():DLogManager {
			return _manager;
		}
		
		public function addMessage(m:ConsoleMessage) {
			_messages.push(m);
			_dirty = true;
		}
		
		public function setClean() {
			_dirty = false;
		}
		
		public function setDirty() {
			_dirty = true;
		}
	
	}

