package com.furusystems.dconsole2.plugins.inspectorviews.treeview.dfs
;
	import flash.display.DisplayObject;
	import com.furusystems.dconsole2.plugins.inspectorviews.treeview.noderenderers.ListNode;
	 class DFS
	{
		public static function search(destination:DisplayObject, origin:ListNode):ListNode {
			if (destination == origin.displayObject) return origin;
			var closedList= new Vector<ListNode>();
			var openList= new Vector<ListNode>();
			openList.push(origin);
			while (openList.length != 0) {
				var n= openList.shift();
				if (n.displayObject == destination) {
					return n;
				}
				if (n.childNodes == null) n.buildChildren();
				n.expanded = false;
				var neighbors= n.childNodes;
				var nLength= neighbors.length;
				
				for (i in 0...nLength) {
					openList.unshift(neighbors[nLength - i - 1]);
				}
				
				closedList.push(n);
			}
			return null;
		}
	}

