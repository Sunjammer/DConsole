package com.furusystems.messaging.pimp ;
	import flash.display.Shape;
	import flash.events.Event;
	
	/**
	 * Static or instanced Message central allowing app-wide Message broadcast as a complement to the event framework
	 * @author Andreas Rønning
	 */
	 final class PimpCentral {
		//{ statics
		static final _recipientsTable:ASDictionary<ASAny,ASAny> = new ASDictionary(true); //Table of vectors of recipients keyed by Message type
		static final _callbacksTable:ASDictionary<ASAny,ASAny> = new ASDictionary(true); //Table of vectors of callbacks keyed by Message type
		static var _messageQueue:Vector<MessageQueueItem> = new Vector(); //Queue of Messages not yet sent (if delayed and delayed Message is enabled)
		static final _updateSource:Shape = new Shape(); //Shape serving as source for frame update events (used with delay)
		static var _delayEnabled:Bool = false; //Local flag for delay functionality
		
		/**
		 * Dispatch a Message to all listeners for that specific Message object
		 * @param	n
		 * The Message to dispatch
		 * @param	origin
		 * (optional)
		 * The object that dispatched the Message
		 * @param	data
		 * (optional)
		 * Any payload to send along with the Message
		 * @param	delayMS
		 * (optional, dependent on delayEnabled) The number of milliseconds before the Message will be dispatched
		 */
		public static function send(m:Message, data:ASAny = null, origin:ASObject = null, delayMS:Float = -1) {
			var q= new MessageQueueItem();
			q.message = m;
			q.origin = origin;
			q.delayMS = delayMS;
			q.data = data;
			if (delayMS <= 0 || !_delayEnabled) {
				processMessage(q);
				return;
			}
			q.delayMS += flash.Lib.getTimer();
			_messageQueue.push(q);
		
		}
		
		/**
		 * Private handler for individual MessageQueueItems
		 * @param	queueItem
		 */
		static function processMessage(queueItem:MessageQueueItem) {
			var m= queueItem.message;
			var o:ASObject = queueItem.origin;
			var d:ASObject = queueItem.data;
			var tempData= new MessageData();
			var table:ASDictionary<ASAny,ASAny>;
			tempData.message = m;
			tempData.source = queueItem.origin;
			tempData.data = queueItem.data;
			if (_recipientsTable[m] != null) {
				table = _recipientsTable[m];
				for (_tmp_ in table) {
var listener:IMessageReceiver  = _tmp_;
					listener.onMessage(tempData);
				}
			}
			if (_callbacksTable[m] != null) {
				table = _callbacksTable[m];
				for (callback in table) {
					switch (callback.length) {
						case 1:
							callback(tempData);
							
						default:
							callback();
					}
				}
			}
		}
		
		/**
		 * Private handler for frame events, handling delayed items
		 * @param	e
		 */
		static function checkQueue(e:Event = null) {
			if (_messageQueue.length == 0)
				return;
			var time:UInt = flash.Lib.getTimer();
			var i= _messageQueue.length;while (i-- != 0) {
				var n= _messageQueue[i];
				if (n.delayMS <= time) {
					processMessage(n);
					_messageQueue.splice(i, 1); //TODO: may be linked list is better for this
				}
			}
		}
		
		/**
		 * Remove an IMessageReceiver from the receivers list for a specific Message
		 * @param	receiver
		 * The IMessageReceiver that shouldn't receive the Message anymore
		 * @param	Message
		 * The Message type the receiver shouldn't receive anymore
		 */
		public static function removeReceiver(receiver:IMessageReceiver, m:Message) {
			if (_recipientsTable[m] == null)
				return;
			Reflect.deleteField(_recipientsTable[m], receiver);
		}
		
		/**
		 * Add an IMessageReceiver to the receivers list for a specific Message
		 * @param	receiver
		 * The IMessageReceiver that should receive the Message
		 * @param	Message
		 * The Message type the receiver should receive
		 * @parem ...rest
		 * More messages to receiver...
		 */
		public static function addReceiver(receiver:IMessageReceiver, m:Message,  moreMessages:Array<ASAny> = null) {
if (moreMessages == null) moreMessages = [];
			appendReceiver(receiver, m);
			for (_tmp_ in moreMessages) {
m  = _tmp_;
				appendReceiver(receiver, m);
			}
		}
		
		static function appendReceiver(receiver:IMessageReceiver, m:Message) {
			var table:ASDictionary<ASAny,ASAny>;
			if (_recipientsTable[m] != null) {
				table = _recipientsTable[m];
			} else {
				table = _recipientsTable[m] = new ASDictionary<ASAny,ASAny>(true);
			}
			table[receiver] = receiver;
		}
		
		/**
		 * Adds a callback to be executed when a specific notofication is sent
		 * @param	Message
		 * The Message to respond to
		 * @param	callback
		 * The callback function, accepting either none or 1 argument ( an instance of MessageData)
		 * @param ...rest
		 * More messages to respond to with this callback...
		 */
		public static function addCallback(m:Message, callback:ASFunction,  moreMessages:Array<ASAny> = null) {
if (moreMessages == null) moreMessages = [];
			appendCallback(callback, m);
			for (_tmp_ in moreMessages) {
m  = _tmp_;
				appendCallback(callback, m);
			}
		}
		
		static function appendCallback(callback:ASFunction, m:Message) {
			var table:ASDictionary<ASAny,ASAny>;
			if (_callbacksTable[m] != null) {
				table = _callbacksTable[m];
			} else {
				table = _callbacksTable[m] = new ASDictionary<ASAny,ASAny>(true);
			}
			table[callback] = callback;
		}
		
		/**
		 * Remove a callback from the execution list of a specific Message
		 * @param	callback
		 * The callback that should stop receiving the Message
		 * @param	m
		 * The Message that should stop triggering this callback
		 */
		public static function removeCallback(m:Message, callback:ASFunction) {
			if (_callbacksTable[m] == null)
				return;
			Reflect.deleteField(_callbacksTable[m], callback);
		}
		
				
				
				
		@:flash.property public static var delayEnabled(get,set):Bool;
static function  get_delayEnabled():Bool {
			return _delayEnabled;
		}
static function  set_delayEnabled(value:Bool):Bool{
			_delayEnabled = value;
			if (_delayEnabled) {
				_updateSource.addEventListener(Event.ENTER_FRAME, checkQueue);
			} else {
				_updateSource.removeEventListener(Event.ENTER_FRAME, checkQueue);
			}
return value;
		}
		//}
		
		//{ instance
		final _recipientsTable:ASDictionary<ASAny,ASAny> = new ASDictionary(true); //Table of vectors of recipients keyed by Message type
		final _callbacksTable:ASDictionary<ASAny,ASAny> = new ASDictionary(true); //Table of vectors of callbacks keyed by Message type
		var _messageQueue:Vector<MessageQueueItem> = new Vector(); //Queue of Messages not yet sent (if delayed and delayed Message is enabled)
		final _updateSource:Shape = new Shape(); //Shape serving as source for frame update events (used with delay)
		var _delayEnabled:Bool = false; //Local flag for delay functionality
		
		/**
		 * Dispatch a Message to all listeners for that specific Message object
		 * @param	n
		 * The Message to dispatch
		 * @param	origin
		 * (optional)
		 * The object that dispatched the Message
		 * @param	data
		 * (optional)
		 * Any payload to send along with the Message
		 * @param	delayMS
		 * (optional, dependent on delayEnabled) The number of milliseconds before the Message will be dispatched
		 */
		public function send(m:Message, data:ASAny = null, origin:ASObject = null, delayMS:Float = -1) {
			var q= new MessageQueueItem();
			q.message = m;
			q.origin = origin;
			q.delayMS = delayMS;
			q.data = data;
			if (delayMS <= 0 || !_delayEnabled) {
				processMessage(q);
				return;
			}
			q.delayMS += flash.Lib.getTimer();
			_messageQueue.push(q);
		
		}
		
		/**
		 * Private handler for individual MessageQueueItems
		 * @param	queueItem
		 */
		function processMessage(queueItem:MessageQueueItem) {
			var m= queueItem.message;
			var o:ASObject = queueItem.origin;
			var d:ASObject = queueItem.data;
			var tempData= new MessageData();
			var table:ASDictionary<ASAny,ASAny>;
			tempData.message = m;
			tempData.source = queueItem.origin;
			tempData.data = queueItem.data;
			if (_recipientsTable[m] != null) {
				table = _recipientsTable[m];
				for (_tmp_ in table) {
var listener:IMessageReceiver  = _tmp_;
					listener.onMessage(tempData);
				}
			}
			if (_callbacksTable[m] != null) {
				table = _callbacksTable[m];
				for (callback in table) {
					switch (callback.length) {
						case 1:
							callback(tempData);
							
						default:
							callback();
					}
				}
			}
		}
		
		/**
		 * Private handler for frame events, handling delayed items
		 * @param	e
		 */
		function checkQueue(e:Event = null) {
			if (_messageQueue.length == 0)
				return;
			var time:UInt = flash.Lib.getTimer();
			var i= _messageQueue.length;while (i-- != 0) {
				var n= _messageQueue[i];
				if (n.delayMS <= time) {
					processMessage(n);
					_messageQueue.splice(i, 1); //TODO: may be linked list is better for this
				}
			}
		}
		
		/**
		 * Remove an IMessageReceiver from the receivers list for a specific Message
		 * @param	receiver
		 * The IMessageReceiver that shouldn't receive the Message anymore
		 * @param	Message
		 * The Message type the receiver shouldn't receive anymore
		 */
		public function removeReceiver(receiver:IMessageReceiver, m:Message) {
			if (_recipientsTable[m] == null)
				return;
			Reflect.deleteField(_recipientsTable[m], receiver);
		}
		
		/**
		 * Add an IMessageReceiver to the receivers list for a specific Message
		 * @param	receiver
		 * The IMessageReceiver that should receive the Message
		 * @param	Message
		 * The Message type the receiver should receive
		 * @parem ...rest
		 * More messages to receiver...
		 */
		public function addReceiver(receiver:IMessageReceiver, m:Message,  moreMessages:Array<ASAny> = null) {
if (moreMessages == null) moreMessages = [];
			appendReceiver(receiver, m);
			for (_tmp_ in moreMessages) {
m  = _tmp_;
				appendReceiver(receiver, m);
			}
		}
		
		function appendReceiver(receiver:IMessageReceiver, m:Message) {
			var table:ASDictionary<ASAny,ASAny>;
			if (_recipientsTable[m] != null) {
				table = _recipientsTable[m];
			} else {
				table = _recipientsTable[m] = new ASDictionary<ASAny,ASAny>(true);
			}
			table[receiver] = receiver;
		}
		
		/**
		 * Adds a callback to be executed when a specific notofication is sent
		 * @param	Message
		 * The Message to respond to
		 * @param	callback
		 * The callback function, accepting either none or 1 argument ( an instance of MessageData)
		 * @param ...rest
		 * More messages to respond to with this callback...
		 */
		public function addCallback(m:Message, callback:ASFunction,  moreMessages:Array<ASAny> = null) {
if (moreMessages == null) moreMessages = [];
			appendCallback(callback, m);
			for (_tmp_ in moreMessages) {
m  = _tmp_;
				appendCallback(callback, m);
			}
		}
		
		function appendCallback(callback:ASFunction, m:Message) {
			var table:ASDictionary<ASAny,ASAny>;
			if (_callbacksTable[m] != null) {
				table = _callbacksTable[m];
			} else {
				table = _callbacksTable[m] = new ASDictionary<ASAny,ASAny>(true);
			}
			table[callback] = callback;
		}
		
		/**
		 * Remove a callback from the execution list of a specific Message
		 * @param	callback
		 * The callback that should stop receiving the Message
		 * @param	m
		 * The Message that should stop triggering this callback
		 */
		public function removeCallback(m:Message, callback:ASFunction) {
			if (_callbacksTable[m] == null)
				return;
			Reflect.deleteField(_callbacksTable[m], callback);
		}
function  get_delayEnabled():Bool {
			return _delayEnabled;
		}
function  set_delayEnabled(value:Bool):Bool{
			_delayEnabled = value;
			if (_delayEnabled) {
				_updateSource.addEventListener(Event.ENTER_FRAME, checkQueue);
			} else {
				_updateSource.removeEventListener(Event.ENTER_FRAME, checkQueue);
			}
return value;
		}
public function new(){}
	
		//}
	}
