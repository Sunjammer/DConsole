package com.furusystems.dconsole2.plugins.monitoring
;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.furusystems.dconsole2.core.introspection.ScopeManager;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.DConsole;

	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class MonitorManager
	{

		var monitors:Vector<Monitor> = new Vector();
		var monitorTimer:Timer = new Timer(300);
		var console:DConsole;
		var scopeManager:ScopeManager;
		public function new(console:DConsole, scopeMgr:ScopeManager)
		{
			this.console = console;
			this.scopeManager = scopeMgr;
			monitorTimer.addEventListener(TimerEvent.TIMER, update);
		}
				@:flash.property public var interval(get,set):Int;
function  set_interval(n:Int):Int		{
			if (n < 1000 / console.stage.frameRate)
			{
				n = Std.int(1000 / console.stage.frameRate);
			}
			monitorTimer.delay = n;
return n;
		}
function  get_interval():Int
		{
			return Std.int(monitorTimer.delay);
		}
		public function start()
		{
			monitorTimer.start();
		}
		public function stop()
		{
			monitorTimer.stop();
		}
		public function addMonitor(scope:ASObject, properties:Array<ASAny> = null):Monitor
		{
if (properties == null) properties = [];
			var m:Monitor = null;
			var i= 0;while (i < monitors.length)
			{
				if (monitors[i].scope == scope)
				{
					m = monitors[i];
					var j= 0;while (j < properties.length)
					{
						var found :ASAny= false;
						var k= 0;while (k < monitors[i].properties.length)
						{
							if (properties[j] == monitors[i].properties[k])
							{
								found = true;
								break;
							}
k++;
						}
						if (found)
							monitors[i].properties.push(properties[j]);
j++;
					}
					console.print("Existing monitor found, appending properties", ConsoleMessageTypes.SYSTEM);
					m.update(true);
				}
i++;
			}
			if (m == null)
			{
				m = new Monitor(this, scope, properties);
				monitors.push(m);
				// console.pluginContainer.addChild(m);
				console.print("New monitor created", ConsoleMessageTypes.SYSTEM);
			}
			return m;

		}
		public function removeMonitor(scope:ASObject):Bool
		{
			var i= 0;while (i < monitors.length)
			{
				if (monitors[i].scope == scope)
				{
					// console.pluginContainer.removeChild(monitors[i]);
					monitors.splice(i, 1);
					return true;
				}
i++;
			}
			return false;
		}
		function update(e:TimerEvent = null)
		{
			var i= 0;while (i < monitors.length)
			{
				monitors[i].update();
i++;
			}
		}

		public function destroyMonitors()
		{
			var count= 0;
			var i= 0;while (i < monitors.length)
			{
				// console.pluginContainer.removeChild(monitors[i]);
				count++;
i++;
			}
			monitors = new Vector<Monitor>();
			console.print(count + " monitors destroyed", ConsoleMessageTypes.SYSTEM);
		}

		public function destroyMonitor()
		{
			if (removeMonitor(scopeManager.currentScope.targetObject))
			{
				console.print("Removed", ConsoleMessageTypes.SYSTEM);
			}
			else
			{
				console.print("No such monitor", ConsoleMessageTypes.ERROR);
			}
		}

		public function createMonitor(properties:Array<ASAny> = null)
		{
if (properties == null) properties = [];
			properties.unshift(scopeManager.currentScope.targetObject);
			Reflect.callMethod(this, addMonitor, properties);
		}
		public function setMonitorInterval(i:Int = 300):Int
		{
			if (i < 0)
				i = 0;
			monitorTimer.delay = i;
			return Std.int(monitorTimer.delay);
		}

	}

