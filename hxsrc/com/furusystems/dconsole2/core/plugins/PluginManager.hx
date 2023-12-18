package com.furusystems.dconsole2.core.plugins ;
	import com.furusystems.dconsole2.core.introspection.ScopeManager;
	import com.furusystems.dconsole2.core.logmanager.DLogManager;
	import com.furusystems.dconsole2.core.output.ConsoleMessage;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.persistence.PersistenceManager;
	import com.furusystems.dconsole2.core.references.ReferenceManager;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class PluginManager {
		var _pluginMap:ASDictionary<ASAny,ASAny>;
		var _updatingPlugins:Vector<IUpdatingDConsolePlugin> = new Vector();
		var _filteringPlugins:Vector<IFilteringDConsolePlugin> = new Vector();
		var _parsers:Vector<IParsingDConsolePlugin> = new Vector();
		var _inspectorViews:Vector<IDConsoleInspectorPlugin> = new Vector();
		var _scopeManager:ScopeManager;
		var _referenceManager:ReferenceManager;
		var _console:DConsole;
		var _topLayer:Sprite;
		var _botLayer:Sprite;
		var _consoleBgLayer:Sprite;
		var _logManager:DLogManager;
		
		public function new(scopeManager:ScopeManager, referenceManager:ReferenceManager, console:DConsole, topLayer:Sprite, botLayer:Sprite, consoleBackgroundLayer:Sprite, logManager:DLogManager) {
			_logManager = logManager;
			_topLayer = topLayer;
			_botLayer = botLayer;
			_consoleBgLayer = consoleBackgroundLayer;
			
			_scopeManager = scopeManager;
			_referenceManager = referenceManager;
			_console = console;
			_pluginMap = new ASDictionary<ASAny,ASAny>();
		}
		
		public function unregisterPlugin(plug:Class<Dynamic>) {
			if (_pluginMap[plug] != null) {
				_pluginMap[plug].shutdown(this);
				if (Std.is(_pluginMap[plug] , IDConsoleInspectorPlugin)) {
					_console.view.inspector.removeView(_pluginMap[plug]);
					_inspectorViews.splice(_inspectorViews.indexOf(_pluginMap[plug]), 1);
				} else if (Std.is(_pluginMap[plug] , IParsingDConsolePlugin)) {
					_parsers.splice(_parsers.indexOf(_pluginMap[plug]), 1);
				} else if (Std.is(_pluginMap[plug] , IFilteringDConsolePlugin)) {
					_filteringPlugins.splice(_filteringPlugins.indexOf(_pluginMap[plug]), 1);
				} else if (Std.is(_pluginMap[plug] , IUpdatingDConsolePlugin)) {
					_updatingPlugins.splice(_updatingPlugins.indexOf(_pluginMap[plug]), 1);
				}
				_pluginMap[plug] = null;
				_pluginMap.remove(plug);
			}
		}
		
		public function registerPlugin(plug:Class<Dynamic>) {
			var obj:ASAny = Type.createInstance(plug, []);
			if (Std.is(obj , IDConsolePlugin)) {
				var plugInstance= ASCompat.dynamicAs(obj , IDConsolePlugin);
				if (_pluginMap[plug] == null) {
					if (plugInstance.dependencies != null) {
						if (plugInstance.dependencies.length > 0) {
							for (c in plugInstance.dependencies) {
								registerPlugin(c);
							}
						}
					}
					plugInstance.initialize(this);
					_pluginMap[plug] = plugInstance;
					if (Std.is(plugInstance , IDConsoleInspectorPlugin)) {
						_inspectorViews.push(plugInstance);
						_console.view.inspector.addView(cast(plugInstance, IDConsoleInspectorPlugin));
					} else if (Std.is(plugInstance , IParsingDConsolePlugin)) {
						_parsers.push(plugInstance);
					} else if (Std.is(plugInstance , IFilteringDConsolePlugin)) {
						_filteringPlugins.push(plugInstance);
					} else if (Std.is(plugInstance , IUpdatingDConsolePlugin)) {
						_updatingPlugins.push(plugInstance);
					}
				}
			} else if (Std.is(obj , IPluginBundle)) {
				var plugBundle= ASCompat.dynamicAs(obj , IPluginBundle);
				var i= 0;while (i < plugBundle.plugins.length) {
					registerPlugin(plugBundle.plugins[i]);
i++;
				}
			} else {
				console.print("Couldn't register plug-in: " + ASCompat.describeType(plug).attribute("name").split("::").pop(), ConsoleMessageTypes.ERROR);
			}
		}
		
		@:flash.property public var numPlugins(get,never):Int;
function  get_numPlugins():Int {
			var count= 0;
			for (_tmp_ in _pluginMap) {
var plug:IDConsolePlugin  = _tmp_;
				++count;
			}
			return count;
		}
		
		public function printPluginInfo() {
			var count= 0;
			for (_tmp_ in _pluginMap) {
var plug:IDConsolePlugin  = _tmp_;
				count++;
				console.print(ASCompat.describeType(plug).attribute("name").split("::").pop(), ConsoleMessageTypes.SYSTEM);
				console.print("\t(" + plug.descriptionText + ")");
			}
			console.print(count + " plugins registered", ConsoleMessageTypes.SYSTEM);
		}
		
		public function runParsers(data:String):ASAny {
			var i= 0;while (i < _parsers.length) {
				var p= _parsers[i];
				var result:ASAny = p.parse(data); //Stops at the first parser that returns a valid response
				if (result != null)
					return result;
i++;
			}
			return data;
		}
		
		public function runFilters(m:ConsoleMessage):Bool {
			
			for (plug in _filteringPlugins) {
				if (!plug.filter(m))
					return false;
			}
			return true;
		}
		
		public function update() {
			for (plug in _updatingPlugins) {
				plug.update(this);
			}
		}
		
		public function getPluginByType(type:Class<Dynamic>):IDConsolePlugin {
			if (_pluginMap[type] != null) {
				return ASCompat.dynamicAs(_pluginMap[type] , IDConsolePlugin);
			}
			return null;
		}
		
		@:flash.property public var persistence(get,never):PersistenceManager;
function  get_persistence():PersistenceManager {
			return _console.persistence;
		}
		
		@:flash.property public var console(get,never):IConsole;
function  get_console():IConsole {
			return _console;
		}
		
		@:flash.property public var scopeManager(get,never):ScopeManager;
function  get_scopeManager():ScopeManager {
			return _scopeManager;
		}
		
		@:flash.property public var referenceManager(get,never):ReferenceManager;
function  get_referenceManager():ReferenceManager {
			return _referenceManager;
		}
		
		@:flash.property public var topLayer(get,never):DisplayObjectContainer;
function  get_topLayer():DisplayObjectContainer {
			return _topLayer;
		}
		
		@:flash.property public var botLayer(get,never):DisplayObjectContainer;
function  get_botLayer():DisplayObjectContainer {
			return _botLayer;
		}
		
		@:flash.property public var consoleBackground(get,never):DisplayObjectContainer;
function  get_consoleBackground():DisplayObjectContainer {
			return _consoleBgLayer;
		}
		
		@:flash.property public var logManager(get,never):DLogManager;
function  get_logManager():DLogManager {
			return _logManager
;		}
		
		@:flash.property public var messaging(get,never):PimpCentral;
function  get_messaging():PimpCentral {
			return _console.messaging;
		}
	}

