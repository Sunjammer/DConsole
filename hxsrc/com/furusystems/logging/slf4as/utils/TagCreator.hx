package com.furusystems.logging.slf4as.utils ;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	 class TagCreator {
		static public function getTag(owner:ASObject):String {
			/*if (owner is Class) {
				return describeType(owner).@name.split("::").pop();
			} else {*/
				return "" + owner;
			//}
		}
	
	}

