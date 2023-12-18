package com.furusystems.dconsole2.core.introspection 
;
	import com.furusystems.dconsole2.core.introspection.descriptions.ChildScopeDesc;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class TreeUtils
	{
		
		public function new() 
		{
			
		}
		public static function getChildren(o:ASAny):Vector<ChildScopeDesc> {
			var out= new Vector<ChildScopeDesc>();
			//if we're in a DisplayObjectContainer, add first level children
			var c:ChildScopeDesc;
			if (Std.is(o , DisplayObjectContainer)) {
				var d= ASCompat.dynamicAs(o , DisplayObjectContainer);
				var cd:DisplayObject;
				var n= d.numChildren;
				n > 0;while (n-- != 0) {
					cd = d.getChildAt(n);
					c = new ChildScopeDesc();
					c.object = cd;
					c.name = cd.name;
					c.type = cd.toString();
					out.push(c);
				}
			}
			return out;
		}
		
	}

