package com.furusystems.dconsole2.core.search ;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class DisplayListSearch {
		/**
		 * Looks down the display tree and looks for a parent of a certain type
		 * @param	type
		 * The class type to look for
		 * @param	start
		 * The child object to start the search from
		 * @return
		 */
		public static function getParentObjectByType(type:Class<Dynamic>, start:DisplayObject):ASAny {
			var found= false;
			var searching= true;
			var currentObject= start.parent;
			while (currentObject != start.root && currentObject.parent != null) {
				if (Std.is(currentObject , type))
					return currentObject;
				currentObject = currentObject.parent;
			}
			throw new Error("No such parent type found");
		}
		
		public static function getChildObjectsByType(type:Class<Dynamic>, start:DisplayObjectContainer):Array<ASAny> {
			var result:Array<ASAny> = [];
			
			return result;
		}
	
	}

