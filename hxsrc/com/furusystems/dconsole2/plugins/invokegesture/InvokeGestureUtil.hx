package com.furusystems.dconsole2.plugins.invokegesture 
;
	import com.furusystems.dconsole2.IConsole;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	
	/**
	 * ...
	 * @author Andreas Ronning
	 */
	 class InvokeGestureUtil implements IDConsolePlugin 
	{
		var _console:IConsole;
		var _stage:Stage;
		var _tl:Rectangle = new Rectangle(0, 0, 30, 30);
		var _tr:Rectangle = new Rectangle(0, 0, 30, 30);
		var _bl:Rectangle = new Rectangle(0, 0, 30, 30);
		var _br:Rectangle = new Rectangle(0, 0, 30, 30);
		
		var _rects:Vector<Rectangle> = Vector.ofArray([_tl, _tr, _br, _bl]);
		var _sequence:Vector<UInt> = new Vector();
		
		public function new() 
		{
			
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String 
		{
			return "Enables a clockwise tap in each screen corner to show/hide the console";
		}
		
		public function initialize(pm:PluginManager) 
		{
			pm.console.view.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_console = pm.console;
			if (_console.view.stage != null) onAddedToStage(); 
		}
		
		function onAddedToStage(e:Event = null) 
		{
			_console.view.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_stage = _console.view.stage;
			_stage.addEventListener(Event.RESIZE, onStageResize);
			onStageResize();
			setupGesture();
		}
		
		public function shutdown(pm:PluginManager) 
		{
			_stage.removeEventListener(Event.RESIZE, onStageResize);
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_console = null;
			_stage = null;
		}
		
		function setupGesture() 
		{
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		function onMouseDown(e:MouseEvent) 
		{
			var mp= new Point(_stage.mouseX, _stage.mouseY);
			
			for (r in _rects) {
				if (r.containsPoint(mp)) {
					addToSequence(r);
					return;
				}
			}
		}
		function addToSequence(r:Rectangle) {
			if (_sequence.length > 4)_sequence.shift();
			switch(r) {
				case (_ == _tl => true):
					_sequence.push(0);
				
				case (_ == _tr => true):
					_sequence.push(1);
				
				case (_ == _br => true):
					_sequence.push(2);
				
				case (_ == _bl => true):
					_sequence.push(3);
				

default:
			}
			evaluateSequence();
		}
		
		function evaluateSequence() 
		{
			var sequenceString= _sequence.join("");
			sequenceString = sequenceString + sequenceString; //full cycle
			if (sequenceString.indexOf("0123") > -1) {
				_console.toggleDisplay();
				_sequence = new Vector<UInt>();
			}
		}
		
		function onStageResize(e:Event = null) 
		{
			moveTapRects();
		}
		
		function moveTapRects() 
		{
			_tl.x = _tl.y = _tr.y = _bl.x = 0;
			_tr.x = _br.x = _stage.stageWidth - _tr.width;
			_bl.y = _br.y = _stage.stageHeight - _bl.height;
		}
		
				
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> 
		{
			return null;
		}
		
		
	}

