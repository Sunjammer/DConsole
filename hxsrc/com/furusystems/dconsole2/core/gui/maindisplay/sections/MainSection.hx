package com.furusystems.dconsole2.core.gui.maindisplay.sections ;
	import com.furusystems.dconsole2.core.gui.maindisplay.assistant.Assistant;
	import com.furusystems.dconsole2.core.gui.maindisplay.filtertabrow.FilterTabRow;
	import com.furusystems.dconsole2.core.gui.maindisplay.input.InputField;
	import com.furusystems.dconsole2.core.gui.maindisplay.output.OutputField;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.messaging.pimp.MessageData;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class MainSection extends ConsoleViewSection {
		
		public var assistant:Assistant;
		public var filterTabs:FilterTabRow;
		public var input:InputField;
		public var output:OutputField;
		var _console:DConsole;
		var _r:Rectangle;
		var _originalRect:Rectangle;
		
		public function new(console:DConsole) {
			super();
			_console = console;
			filterTabs = new FilterTabRow(console);
			output = new OutputField(console);
			input = new InputField(console);
			assistant = new Assistant(console);
			addChild(filterTabs);
			addChild(output);
			addChild(assistant);
			addChild(input);
			_console.messaging.addCallback(Notifications.NEW_LOG_CREATED, onLogCountChange, [Notifications.LOG_DESTROYED]);
		}
		
		function onLogCountChange(md:MessageData) {
			_r = _originalRect.clone();
			update();
		}
		
		override public function onParentUpdate(allotedRect:Rectangle) {
			_originalRect = allotedRect.clone();
			_r = _originalRect.clone();
			update();
		}
		
		public function update() {
			if (_r == null)
				return;
			var totalH= _r.height;
			var totalW= _r.width;
			var h= 0, w:Float = 0;
			var offsetX= _r.x;
			var offsetY= _r.y;
			x = offsetX;
			y = offsetY;
			
			filterTabs.visible = output.visible = assistant.visible = false;
			
			_r.x = _r.y = 0;
			
			assistant.visible = totalH > 2 * GUIUnits.SQUARE_UNIT;
			
			if (totalH > 3 * GUIUnits.SQUARE_UNIT && _console.logs.logsActive > 1) {
				//filtertabs enabled
				filterTabs.visible = true;
				filterTabs.onParentUpdate(_r);
				h += GUIUnits.SQUARE_UNIT;
			}
			if (totalH > 1 * GUIUnits.SQUARE_UNIT) {
				//output enabled
				output.visible = true;
				_r.y = h;
				var m= 3;
				if (!filterTabs.visible)
					m--;
				if (!assistant.visible)
					m--;
				//var m:int = filterTabs.visible?3:2;
				_r.height = totalH - m * GUIUnits.SQUARE_UNIT;
				output.onParentUpdate(_r);
				h += Std.int(output.height);
			}
			
			//input always enabled
			if (!assistant.visible) {
				h = Std.int(totalH - GUIUnits.SQUARE_UNIT);
			}
			_r.y = h;
			input.onParentUpdate(_r);
			h += Std.int(input.height);
			
			if (assistant.visible) {
				//assistant enabled
				_r.y = h;
				assistant.onParentUpdate(_r);
			}
		}
	
	}

