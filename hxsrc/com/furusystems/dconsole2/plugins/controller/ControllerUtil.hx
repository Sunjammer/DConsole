package com.furusystems.dconsole2.plugins.controller 
;
	import com.furusystems.dconsole2.core.commands.UnparsedCommand;
	import com.furusystems.dconsole2.core.introspection.ScopeManager;
	import com.furusystems.dconsole2.core.plugins.IUpdatingDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.DConsole;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class ControllerUtil extends Sprite implements IUpdatingDConsolePlugin
	{
		var _controllers:Vector<Controller> = new Vector();
		var _scopeManager:ScopeManager;
		
		@:allow(com.furusystems.dconsole2.plugins.controller) function addController(object:ASAny, properties:Array<ASAny>,x:Float = 0,y:Float = 0) {
			var c= new Controller(object, properties, this);
			c.x = Math.max(0, Math.min(x, stage.stageWidth - c.width));
			c.y = Math.max(0, Math.min(y, stage.stageHeight - c.height));
			_controllers.push(Std.downcast(addChild(c) , Controller));
		}
		@:allow(com.furusystems.dconsole2.plugins.controller) function removeController(c:Controller) {
			var i= 0;while (i < _controllers.length) 
			{
				if (_controllers[i] == c) {
					_controllers[i].destroy();
					_controllers.splice(i, 1);
					removeChild(c);
					break;
				}
i++;
			}
		}
		
		function createController(properties:Array<ASAny> = null)
		{
if (properties == null) properties = [];
			var x:Float = 0;
			var y:Float = 0;
			if (Std.is(_scopeManager.currentScope.targetObject , DisplayObject)) {
				var r= cast(_scopeManager.currentScope.targetObject, DisplayObject).transform.pixelBounds;
				x = r.x + r.width;
				y = r.y + r.height;
			}
			addController(_scopeManager.currentScope.targetObject, properties, x, y);
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager)
		{
			pm.topLayer.addChild(this);
			var cmd= new UnparsedCommand("createController", createController, "Controller", "Create a widget for changing properties on the current scope (createController width height for instance)");
			cast(pm.console, DConsole).addCommand(cmd);
			_scopeManager = pm.scopeManager;
		}
		
		public function shutdown(pm:PluginManager)
		{
			pm.topLayer.removeChild(this);
			pm.console.removeCommand("createController");
			_scopeManager = null;
		}
		
		public function update(pm:PluginManager)
		{
			graphics.clear();
			graphics.lineStyle(0, 0x808080);
			for (c in _controllers) {
				c.update();
			}
		}
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String
		{
			return "Enables the creation of GUI widgets for interactive alteration of properties";
		}
		
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> 
		{
			return null;
		}
		
	}

