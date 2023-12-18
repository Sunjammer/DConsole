package com.furusystems.dconsole2.plugins.inspectorviews.inputmonitor 
;
	import com.furusystems.dconsole2.core.inspector.AbstractInspectorView;
	import com.furusystems.dconsole2.core.interfaces.IThemeable;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.core.style.TextFormats;
	import com.furusystems.messaging.pimp.MessageData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class InputMonitorUtil extends AbstractInspectorView implements IThemeable
	{
		
		var kbm:KeyboardAccumulator = null;
		var output:TextField;
		var mouseDown:Bool = false;
		var pm:PluginManager;
		
		public function new() 
		{
			super("Input");
			scrollXEnabled = scrollYEnabled = false;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			output = new TextField();
			output.defaultTextFormat = TextFormats.consoleTitleFormat;
			output.embedFonts = true;
			//output.background = true;
			//output.backgroundColor = 0xFF0000;
			output.text = "";
			content.addChild(output);
		}
		
		function onAddedToStage(e:Event) 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			kbm = new KeyboardAccumulator(stage);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			resize();
		}
		
		function onMouseUp(e:MouseEvent) 
		{
			mouseDown = false;
		}
		
		function onMouseDown(e:MouseEvent) 
		{
			mouseDown = true;
		}
		public override function shutdown(pm:PluginManager) 
		{
			super.shutdown(pm);
			pm.messaging.removeCallback(Notifications.THEME_CHANGED, onThemeChange);
			this.pm = null;
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			kbm.dispose();
			
		}
		override public function onFrameUpdate(e:Event = null) 
		{
			if (kbm == null) return;
			var out= "Stage mouse:\n";
			out += "\tx: " + stage.mouseX+"\n";
			out += "\ty: " + stage.mouseY+"\n";
			out += "\tLMB: " + mouseDown + "\n";
			if (Std.is(pm.scopeManager.currentScope.targetObject , DisplayObject)) {
				var d= cast(pm.scopeManager.currentScope.targetObject, DisplayObject);
				out += "Local mouse:\n";
				out += "\tx: " + d.mouseX + "\n";
				out += "\ty: " + d.mouseY + "\n";
				if(mouseDown){
					var hitTestResult= d.hitTestPoint(stage.mouseX, stage.mouseY, false);
					var hitTestResult2= d.hitTestPoint(stage.mouseX, stage.mouseY, true);
					out += "\thitTest: " + hitTestResult + "\n";
					out += "\thitTestShape: " + hitTestResult2 + "\n";
				}
			}
			out += "\n"+kbm.toString();
			output.text = out;
			//_tabs.updateTabs();
		}
		public override function initialize(pm:PluginManager) 
		{
			super.initialize(pm);
			
			pm.messaging.addCallback(Notifications.THEME_CHANGED, onThemeChange);
			this.pm = pm;
		}
		override public function populate(object:ASObject) 
		{
		}
		override public function resize() 
		{
			if (inspector == null) return;
			var rect= inspector.dims.clone();
			output.width = rect.width;
			output.height = rect.height;
			rect.height -= GUIUnits.SQUARE_UNIT;
			//_tabs.width = rect.width;
			var r= scrollRect;
			r.width = rect.width;
			r.height = rect.height;
			scrollRect = r;
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.interfaces.IThemeable */
		
		public function onThemeChange(md:MessageData)
		{
		}
		
		override function  get_descriptionText():String { 
			return "Adds a dynamically updating table of current mouse and keyboard inputs";
		}
		
		
	}

