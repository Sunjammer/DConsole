package com.furusystems.dconsole2.plugins 
;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	 class SelectionHistoryUtil implements IDConsolePlugin
	{
		var _pm:PluginManager;
		var _stack:Array<ASAny>;
		var _doingSelection:Bool = false;
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager) 
		{
			_pm = pm;
			pm.console.createCommand("back", stepBack, "Introspection", "Steps back to the previously selected scope");
			_stack = [];
			pm.messaging.addCallback(Notifications.SCOPE_CHANGE_BEGUN, onScopeChangeBegun);
			pm.messaging.addCallback(Notifications.SCOPE_CHANGE_COMPLETE, onScopeChangeComplete);
		}
		
		function onScopeChangeComplete() 
		{
			if (_pm.scopeManager.currentScope.targetObject == _pm.scopeManager.getRoot()) {
				_stack = []; //Hax.
			}
			_doingSelection = false;
		}
		
		function onScopeChangeBegun() 
		{
			if(!_doingSelection){
				_stack.push(_pm.scopeManager.currentScope.targetObject); //Store where we are now
			}
		}
		
		function stepBack() 
		{
			if (_stack.length > 0) {
				_doingSelection = true;
				_pm.scopeManager.setScope(_stack.pop());
			}else {
				_doingSelection = false;
				_pm.scopeManager.selectBaseScope();
			}
		}
		
		public function shutdown(pm:PluginManager) 
		{
			_stack = [];
			pm.console.removeCommand("back");
			pm.messaging.removeCallback(Notifications.SCOPE_CHANGE_BEGUN, onScopeChangeBegun);
			pm.messaging.removeCallback(Notifications.SCOPE_CHANGE_COMPLETE, onScopeChangeComplete);
			_pm = null;
		}
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String 
		{
			return "Stores a linear stack of selections, letting you always step back to the previous selection";
		}
		
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> 
		{
			return null;
		}
		
		@:flash.property public var selectionStack(get,never):Array<ASAny>;
function  get_selectionStack():Array<ASAny> 
		{
			return _stack;
		}
		
	}

