package com.furusystems.dconsole2.plugins.inspectorviews.propertyview 
;
	import com.furusystems.dconsole2.core.inspector.AbstractInspectorView;
	import com.furusystems.dconsole2.core.interfaces.IThemeable;
	import com.furusystems.dconsole2.core.introspection.IntrospectionScope;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.dconsole2.plugins.inspectorviews.propertyview.fieldtypes.*;
	import com.furusystems.dconsole2.plugins.inspectorviews.propertyview.tabs.*;
	import com.furusystems.messaging.pimp.MessageData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class PropertyViewUtil extends AbstractInspectorView implements IThemeable
	{
		
		var _tabs:TabCollection;
		var _console:IConsole;
		public function new() 
		{
			super("Properties");
			_tabs = new TabCollection();
			_tabs.addEventListener(Event.CHANGE, onTabLayoutChange,false,0,true);
			content.addChild(_tabs);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			scrollXEnabled = false;
		}
		
		
		function onMouseWheel(e:MouseEvent) 
		{
			if(ControlField.FOCUSED_FIELD == null){
				scrollByDelta(0, e.delta * 5);7
;			}else {
				
			}
		}
		public override function shutdown(pm:PluginManager) 
		{
			super.shutdown(pm);
			
			pm.messaging.removeCallback(Notifications.SCOPE_CHANGE_COMPLETE, onScopeChange);
			pm.messaging.removeCallback(Notifications.THEME_CHANGED, onThemeChange);
		}
		override public function initialize(pm:PluginManager) 
		{
			super.initialize(pm);
			_console = pm.console;
			pm.messaging.addCallback(Notifications.SCOPE_CHANGE_COMPLETE, onScopeChange);
			pm.messaging.addCallback(Notifications.THEME_CHANGED, onThemeChange);
			populate(pm.scopeManager.currentScope);
		}
		override public function onFrameUpdate(e:Event = null) 
		{
			_tabs.updateTabs();
		}
		override public function populate(object:ASObject) 
		{
			super.populate(object);
			var scope= cast(object, IntrospectionScope);
			_tabs.clear();
			var t:PropertyTab;
			var i:Int;
			t = new OverviewTab(_console, scope);
			_tabs.add(t);
			t = new InheritanceTab(_console, scope);
			_tabs.add(t);
			if (Std.is(scope.targetObject , DisplayObject)) {
				t = new TransformTab(_console, scope);
				_tabs.add(t);
				t.averageSplits();
			}
			if(scope.children.length>0){
				t = new PropertyTab("Children");
				i = 0;while (i < scope.children.length) 
				{
					var cd= scope.children[i];
					t.addField(new ChildField(_console, cd));
i++;
				}
				_tabs.add(t);
			}
			if(scope.methods.length>0){
				t = new PropertyTab("Methods");
				i = 0;while (i < scope.methods.length) 
				{
					var md= scope.methods[i];
					t.addField(new MethodField(_console.messaging,md));
i++;
				}
				t.sortFields();
				_tabs.add(t);
			}
			if(scope.variables.length>0){
				t = new PropertyTab("Variables");
				i = 0;while (i < scope.variables.length) 
				{
					var vd= scope.variables[i];
					t.addField(new PropertyField(_console, scope.targetObject, vd.name, vd.type)).width = scrollRect.width;
i++;
				}
				t.sortFields();
				_tabs.add(t);
				t.averageSplits();
			}
			if(scope.accessors.length>0){
				t = new PropertyTab("Accessors");
				i = 0;while (i < scope.accessors.length) 
				{
					var ad= scope.accessors[i];
					var f:PropertyField;
					//if (ad.access == "writeonly") continue;
					f = new PropertyField(_console, scope.targetObject, ad.name, ad.type, ad.access);
					t.addField(f);
i++;
				}
				t.sortFields();
				_tabs.add(t);
				t.averageSplits();
			}
			scrollY = 0;
			resize();
		}
		function onTabLayoutChange(e:Event) 
		{
			scrollByDelta(0, 0);
		}
		function onScopeChange(md:MessageData)
		{
			var scope= ASCompat.dynamicAs(md.data , IntrospectionScope);
			populate(scope);
		}
		override public function resize() 
		{
			if (inspector == null) return;
			var rect= inspector.dims.clone();
			rect.height -= GUIUnits.SQUARE_UNIT;
			_tabs.width = rect.width;
			var r= scrollRect;
			r.width = rect.width;
			r.height = rect.height;
			scrollRect = r;
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.interfaces.IThemeable */
		
		public function onThemeChange(md:MessageData)
		{
			_tabs.update(true);
		}
		
		override function  get_descriptionText():String { 
			return "Adds a dynamically updating table of editable properties for the current scope";
		}
		
	}

