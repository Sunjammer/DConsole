package com.furusystems.dconsole2.core.helpmanager ;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	 class HelpManager {
		var topics:ASDictionary<ASAny,ASAny> = new ASDictionary();
		
		public function new(messaging:PimpCentral) {
			messaging.addCallback(Notifications.HELP_TOPIC_ADD_REQUEST, onHelpAddRequest);
			messaging.addCallback(Notifications.HELP_TOPIC_REMOVE_REQUEST, onHelpRemoveRequest);
		}
		
		function onHelpRemoveRequest(md:MessageData) {
			topics.remove(md.data.title.toLowerCase());
		}
		
		function onHelpAddRequest(md:MessageData) {
			topics[md.data.title.toLowerCase()] = md.data;
		}
		
		public function addTopic(title:String, content:String) {
			topics[title.toLowerCase()] = new HelpTopic(title, content);
		}
		
		public function getTopic(topic:String):String {
			if (topics[topic.toLowerCase()] != null) {
				return cast(topics[topic.toLowerCase()], HelpTopic).toString();
			} else {
				return "No such topic '" + topic + "'";
			}
		}
		
		public function getToc():String {
			var out= "Table of contents:\n";
			var sorted:Array<ASAny> = [];
			for (_tmp_ in topics.keys()) {
var title:String  = _tmp_;
				sorted.push(topics[title]);
			}
			//sorted.sortOn("title");
			var i= sorted.length;while (i-- != 0) {
				out += "\t" + sorted[i].title;
			}
			return out;
		}
	
	}

