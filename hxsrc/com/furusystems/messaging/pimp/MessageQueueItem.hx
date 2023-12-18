package com.furusystems.messaging.pimp ;
	
	/**
	 * Message queue item used by PimpCentral to manage the message buffer
	 * @author Andreas Rønning
	 */
	/*internal*/ final class MessageQueueItem {
		
		public var message:Message; //The queued Message
		public var origin:ASObject; //The notification origin
		public var data:ASObject; //The notification payload
		public var delayMS:Float = -1; //The notification delay in milliseconds (only valid if PimpCentral.delayEnabled is true)
public function new(){}
	}
