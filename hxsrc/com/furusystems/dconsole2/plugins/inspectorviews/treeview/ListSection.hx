package com.furusystems.dconsole2.plugins.inspectorviews.treeview 
;
	import flash.display.Sprite;
	import com.furusystems.dconsole2.plugins.inspectorviews.treeview.noderenderers.ListNode;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class ListSection extends Sprite implements IRenderable
	{
		var items:Vector<ListNode> = new Vector();
		var _level:Int = 0;
		var _parent:ListNode;
		public var expanded:Bool = false;
		public function new(parent:ListNode,level:Int = 0) 
		{
			super();
			this._parent = parent;
			_level = level;
			
		}
		public function render() {
			
		}
		//public function clear():void;
		
				
		@:flash.property public var level(get,set):Int;
function  get_level():Int { return _level; }
function  set_level(value:Int):Int		{
			return _level = value;
		}
		
	}

