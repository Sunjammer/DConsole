package com.furusystems.dconsole2.core.utils ;
	import com.furusystems.dconsole2.core.utils.LLNode;
	import com.furusystems.logging.slf4as.ILogger;
	import com.furusystems.logging.slf4as.Logging;
	
	 final class ListIterator {
		var _list:LLNode;
		public var currentNode:LLNode;
		static final L:ILogger = Logging.getLogger(ListIterator);
		
		public function new(list:LLNode = null) {
			if (list == null)
				return;
			this.list = list;
		}
		
		public function next():ASAny {
			if (currentNode == null)
				return null;
			currentNode = currentNode.next;
			if (currentNode == null)
				return null;
			return currentNode.data;
		}
		
		@:flash.property public var data(get,never):ASAny;
function  get_data():ASAny {
			if (currentNode == null)
				return null;
			return currentNode.data;
		}
		
				
		@:flash.property public var list(get,set):LLNode;
function  set_list(list:LLNode):LLNode{
			_list = list;
			currentNode = list.getHead();
return list;
		}
		
		public function remove():ASAny {
			currentNode.remove();
		}
function  get_list():LLNode {
			return _list;
		}
	}
