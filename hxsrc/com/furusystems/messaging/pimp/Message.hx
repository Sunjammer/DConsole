package com.furusystems.messaging.pimp ;
	
	/**
	 * Basic marker Message type. May be swapped out for string or int pointers later
	 * if we don't wind up adding any properties to it.
	 * @author Andreas Rønning
	 */
	 class Message {
		static var idPool:UInt = 0;
		public var id:Int = idPool++;
public function new(){}
	}

