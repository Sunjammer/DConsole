package com.furusystems.dconsole2.core.logmanager ;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.output.ConsoleMessage;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class DLogManager {
		var _logMap:ASDictionary<ASAny,ASAny> = new ASDictionary(true);
		var _activeFilters:ASDictionary<ASAny,ASAny> = new ASDictionary();
		var _currentLog:DConsoleLog;
		var _rootLog:DConsoleLog;
		var _filtersActive:Int = 0;
		var _logsActive:Int = 0;
		var _messaging:PimpCentral;
		static inline final TAG= "DConsole";
		
		public function new(console:DConsole) {
			_messaging = console.messaging;
			_rootLog = _currentLog = addLog(TAG);
			_messaging.addCallback(Notifications.LOG_BUTTON_CLICKED, onLogButtonClick);
		}
		
		function onLogButtonClick(md:MessageData) {
			setCurrentLog(md.data);
		}
		
		public function clearAll() {
			for (_tmp_ in _logMap) {
var log:DConsoleLog  = _tmp_;
				log.clear();
			}
		}
		
		public function addMessage(msg:ConsoleMessage, log:DConsoleLog = null) {
			if (log == null)
				log = _currentLog;
			validateFilters(msg);
			log.addMessage(msg);
		}
		
		public function getLog(name:String, createIfNotFound:Bool = true):DConsoleLog {
			if (_logMap[name.toLowerCase()] != null) {
				var log:DConsoleLog = _logMap[name.toLowerCase()];
				return log;
			}
			if (createIfNotFound) {
				return addLog(name);
			}
			throw new ArgumentError("No such log '" + name + "'");
		}
		
		public function addLog(name:String):DConsoleLog {
			var log= new DConsoleLog(name, this);
			_logMap[name.toLowerCase()] = log;
			_logsActive++;
			_messaging.send(Notifications.NEW_LOG_CREATED, log, this);
			return log;
		}
		
		public function removeLog(name:String):DConsoleLog {
			if (_logMap[name.toLowerCase()] != null) {
				var log:DConsoleLog = _logMap[name.toLowerCase()];
				log.destroy();
				_logMap.remove(name.toLowerCase());
				_logsActive--;
				_messaging.send(Notifications.LOG_DESTROYED, log, this);
				return log;
			}
			throw new ArgumentError("No such log: " + name);
		}
		
		public function setCurrentLog(name:String):DConsoleLog {
			if (_logMap[name.toLowerCase()] != null) {
				_currentLog = _logMap[name.toLowerCase()];
			}
			_messaging.send(Notifications.CURRENT_LOG_CHANGED, _currentLog, this);
			return _currentLog;
		}
		
		public function addFilter(filter:DLogFilter) {
			_activeFilters[filter.id] = filter;
			_filtersActive++;
			doFilter();
		}
		
		public function removeFilter(filter:DLogFilter) {
			_activeFilters.remove(filter.id);
			_filtersActive--;
			doFilter();
		}
		
		public function clearFilters() {
			_activeFilters = new ASDictionary<ASAny,ASAny>();
			_filtersActive = 0;
			doFilter();
		}
		
		function doFilter() {
			for (_tmp_ in _logMap) {
var log:DConsoleLog  = _tmp_;
				for (m in log.messages) {
					validateFilters(m);
				}
				_messaging.send(Notifications.LOG_CHANGED, log, this);
			}
		}
		
		function validateFilters(msg:ConsoleMessage) {
			msg.visible = true;
			for (_tmp_ in _activeFilters) {
var filter:DLogFilter  = _tmp_;
				var v= true;
				if (filter.term != "") {
					v = msg.text.toLowerCase().indexOf(filter.term.toLowerCase()) > -1;
				}
				if (filter.tag != "") {
					v = msg.tag.toLowerCase() == filter.tag.toLowerCase();
				}
				msg.visible = v;
			}
		}
		
		@:flash.property public var currentLog(get,never):DConsoleLog;
function  get_currentLog():DConsoleLog {
			return _currentLog;
		}
		
		@:flash.property public var filtersActive(get,never):Int;
function  get_filtersActive():Int {
			return _filtersActive;
		}
		
		@:flash.property public var rootLog(get,never):DConsoleLog;
function  get_rootLog():DConsoleLog {
			return _rootLog;
		}
		
		@:flash.property public var logsActive(get,never):Int;
function  get_logsActive():Int {
			return _logsActive;
		}
		
		/**
		 * Searches the current log for a message containing the term and returns the message index
		 * @param	term
		 * @return
		 * the message index
		 */
		public function searchCurrentLog(term:String):Int {
			var i= 0;while (i < currentLog.length) {
				if (currentLog.messages[i].text.toLowerCase().indexOf(term.toLowerCase()) > -1) {
					return i;
				}
i++;
			}
			return -1;
		}
		
		/**
		 * Searches all logs for a message containing the term, switches to that log and returns the message index
		 * @param	term
		 * @return
		 */ /*public function searchLogs(term:String):int {
		   for (var i:int = 0; i < logs.length; i++)
		   {
		   var log:DConsoleLog = logs[i];
		   for (var j:int = 0; j < log.length; j++)
		   {
		   if (log.messages[j].text.toLowerCase().indexOf(term.toLowerCase()) > -1) {
		   _currentLog = logs[i];
		   return j;
		   }
		   }
		   }
		   return -1;
		 }*/
		
		public function getLogNames():Vector<String> {
			var vec= new Vector<String>();
			for (_tmp_ in _logMap) {
var l:DConsoleLog  = _tmp_;
				if (l != _rootLog)
					vec.push(l.name);
			}
			vec.sort(sortStrings);
			vec.unshift(_rootLog.name);
			return vec;
		}
		
		function sortStrings(a:String, b:String):Int {
			if (a > b)
				return 1;
			if (a < b)
				return -1;
			return 0;
		}
		
		public function hasFilterForTag(tag:String):Bool {
			return _activeFilters[tag] != null;
		}
		
		public function hasFilterForSearch(term:String):Bool {
			return _activeFilters[term] != null;
		}
		
		public function hasFilter(filter:DLogFilter):Bool {
			return _activeFilters[filter.id] != null;
		}
	
	}

