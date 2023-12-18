package com.furusystems.dconsole2.core.logmanager ;
	import com.furusystems.dconsole2.core.output.ConsoleMessage;
	
	/**
	 * ...
	 * @author Andreas Ronning
	 */
	 class DLogIterator {
		var _log:DConsoleLog;
		var _index:Int = 0;
		var _vec:Vector<ConsoleMessage> = new Vector();
		
		public function new(log:DConsoleLog) {
			_log = log;
			_index = -1;
			countVisibleItems();
		}
		
		function countVisibleItems() {
			for (m in _log.messages) {
				if (m.visible) {
					_vec.push(m);
				}
			}
		}
		
		@:flash.property public var length(get,never):Int;
function  get_length():Int {
			return _vec.length;
		}
		
		public function hasNext():Bool {
			return _index < length;
		}
		
		public function next():ConsoleMessage {
			_index++;
			return _log.messages[_index];
		}
		
		public function getFilteredVector():Vector<ConsoleMessage> {
			return _vec;
		}
	
	}

