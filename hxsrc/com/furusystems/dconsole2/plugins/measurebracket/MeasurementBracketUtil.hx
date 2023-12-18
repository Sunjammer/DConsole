package com.furusystems.dconsole2.plugins.measurebracket 
;
	import com.furusystems.dconsole2.IConsole;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import com.furusystems.dconsole2.core.introspection.ScopeManager;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.core.style.BaseColors;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class MeasurementBracketUtil extends Sprite implements IDConsolePlugin
	{
		var _rect:Rectangle = new Rectangle();
		var _rectSprite:Sprite;
		var _initialized:Bool = false;
		var _topLeftCornerHandle:Sprite;
		var _bottomRightCornerHandle:Sprite;
		var _widthField:TextField;
		var _heightField:TextField;
		var _xyField:TextField;
		var _fmt:TextFormat;
		var _currentlyChecking:Sprite;
		var _increment:Float = -1;
		var _console:IConsole;
		var _previousObj:ASObject;
		var _scopeManager:ScopeManager;
		var _selectMode:Bool = false;
		var _currentSpace:DisplayObject;
		public var clickOffset:Point;
		public function new() 
		{
			super();
			visible = false;
		}
		public function invoke(doSelect:Bool = false, space:DisplayObject = null) {
			if (space != null) {
				_currentSpace = space;
			}
			if (doSelect) {
				_selectMode = doSelect;
				visible = true;
				_console.print("	Snap-selection active. Ctrl-drag to bracket AND select underlying objects.", ConsoleMessageTypes.SYSTEM);
			}else {
				toggle();
			}
		}
		function roundTo(num:Float, target:Float):Float {
			return Math.fround(num / target) * target;
		}
		function onVisible() 
		{
			if (!_initialized) {
				_fmt = new TextFormat("_sans", 10, 0);
				_widthField = new TextField();
				_heightField = new TextField();
				_xyField = new TextField();
				_widthField.defaultTextFormat = _heightField.defaultTextFormat = _xyField.defaultTextFormat = _fmt;
				var center= new Point(_console.view.stage.stageWidth / 2, _console.view.stage.stageHeight / 2);
				_rect = new Rectangle(center.x - 20, center.y - 20, 40, 40);
				
				_rectSprite = new Sprite();
				_topLeftCornerHandle = new Sprite();
				_bottomRightCornerHandle = new Sprite();
				
				_topLeftCornerHandle.graphics.beginFill(BaseColors.BLACK);
				_topLeftCornerHandle.graphics.lineStyle(0, 0xFF0000);
				_bottomRightCornerHandle.graphics.beginFill(BaseColors.BLACK);
				_bottomRightCornerHandle.graphics.lineStyle(0, 0xFF0000);
				_topLeftCornerHandle.graphics.drawCircle(0, 0, 4);
				_bottomRightCornerHandle.graphics.drawCircle(0, 0, 4);
				
				_topLeftCornerHandle.addEventListener(MouseEvent.MOUSE_DOWN, startGettingValues, false, 0, true);
				_bottomRightCornerHandle.addEventListener(MouseEvent.MOUSE_DOWN, startGettingValues, false, 0, true);
				_rectSprite.addEventListener(MouseEvent.MOUSE_DOWN, startGettingValues, false, 0, true);
				
				_rectSprite.buttonMode = _topLeftCornerHandle.buttonMode = _bottomRightCornerHandle.buttonMode = true;
				
				addChild(_rectSprite);
				addChild(_topLeftCornerHandle);
				addChild(_bottomRightCornerHandle);
				
				_xyField.mouseEnabled = _widthField.mouseEnabled = _heightField.mouseEnabled = false;
				
				_xyField.autoSize = _widthField.autoSize = _heightField.autoSize = TextFieldAutoSize.LEFT;
				
				addChild(_xyField);
				addChild(_widthField);
				addChild(_heightField);
				
				_initialized = true;
				tabEnabled = tabChildren = false;
			}
			
			blendMode = BlendMode.INVERT;
			render();
		}
		
		function startGettingValues(e:MouseEvent) 
		{
			_currentlyChecking = ASCompat.dynamicAs(e.target , Sprite);
			if (_currentlyChecking == _rectSprite) clickOffset = new Point(mouseX - _rect.x, mouseY - _rect.y);
			_console.view.stage.addEventListener(MouseEvent.MOUSE_MOVE, getValues, false, 0, true);
			_console.view.stage.addEventListener(MouseEvent.MOUSE_UP, stopGettingValues, false, 0, true);
		}
		
		function stopGettingValues(e:MouseEvent) 
		{
			_console.view.stage.removeEventListener(MouseEvent.MOUSE_MOVE, getValues);
			_console.view.stage.removeEventListener(MouseEvent.MOUSE_UP, stopGettingValues);
		}
		
		function setTopLeft(x:Float, y:Float) {
			var prevX= _rect.x;
			var prevY= _rect.y;
			_rect.x = x;
			_rect.y = y;	
			checkSnap();
			var diffX= prevX - _rect.x;
			var diffY= prevY - _rect.y;
			_rect.width += diffX;
			_rect.height += diffY;
			_rect.width = Math.max(0, _rect.width);
			_rect.height = Math.max(0, _rect.height);
			keepOnStage();
			render();
		}
		function setBotRight(x:Float, y:Float) {
			if (x < _rect.x) _rect.x = x;
			if (y < _rect.y) _rect.y = y;
			_rect.width = x - _rect.x;
			_rect.height = y - _rect.y;
			checkSnap();
			keepOnStage();
			render();
		}
		function setCenter(x:Float, y:Float) {
			_rect.x = x-clickOffset.x;
			_rect.y = y-clickOffset.y;	
			checkSnap();
			keepOnStage();
			render();
		}
		
		function keepOnStage()
		{
			_rect.x = Math.max(0, Math.min(_rect.x,_console.view.stage.stageWidth-_rect.width));
			_rect.y = Math.max(0, Math.min(_rect.y,_console.view.stage.stageHeight-_rect.height));
		}
		
		function checkSnap()
		{
			if (increment > 0) {
				_rect.x = roundTo(_rect.x, increment);
				_rect.y = roundTo(_rect.y, increment);
				_rect.width = roundTo(_rect.width, increment);
				_rect.height= roundTo(_rect.height, increment);
			}
		}
		function getValues(e:Event = null)
		{
			var mx= Math.max(0, Math.min(_console.view.stage.mouseX, _console.view.stage.stageWidth));
			var my= Math.max(0, Math.min(_console.view.stage.mouseY, _console.view.stage.stageHeight));
			increment = 1;
			var snap= false;
			var me:MouseEvent = null;
			if (Std.is(e , MouseEvent)) {
				me = Std.downcast(e , MouseEvent);
				if (me.shiftKey) {
					increment = 10;
				}else {
					increment = 1;
				}
				snap = me.ctrlKey;
				try { 
					me.updateAfterEvent();
				}catch (err:Error) { };
			}
			
			if (snap) {
				var snapTarget:Rectangle = null;
				var objects= _console.view.stage.getObjectsUnderPoint(new Point(mx, my));
				var dispObj:DisplayObject;
				var i= objects.length;while (i-- != 0) 
				{
					dispObj = objects[i];
					if (!contains(dispObj)) {
						snapTarget = dispObj.getRect(_console.view.stage);
						if(dispObj!=_previousObj){
							if (_selectMode) {
								_scopeManager.setScope(dispObj);
							}else {
								_console.print("Measure tool bracketing: " + dispObj.name + ":" + dispObj);
							}
							_previousObj = dispObj;
						}
						break;
					}
				}
				if (snapTarget != null) {
					switch(_currentlyChecking) {
						case (_ == _topLeftCornerHandle => true):
						setTopLeft(snapTarget.x, snapTarget.y);
						
						case (_ == _bottomRightCornerHandle => true):
						setBotRight(snapTarget.x+snapTarget.width,snapTarget.y+snapTarget.height);
						
						case (_ == _rectSprite => true):
						setTopLeft(snapTarget.x, snapTarget.y);
						setBotRight(snapTarget.x + snapTarget.width, snapTarget.y + snapTarget.height);
						

default:
					}
				}else {
					switch(_currentlyChecking) {
						case (_ == _topLeftCornerHandle => true):
						setTopLeft(mx, my);
						
						case (_ == _bottomRightCornerHandle => true):
						setBotRight(mx,my);
						
						case (_ == _rectSprite => true):
						setCenter(mx, my);
						

default:
					}
				}
			}else {
				_previousObj = null;
				switch(_currentlyChecking) {
					case (_ == _topLeftCornerHandle => true):
					setTopLeft(mx, my);
					
					case (_ == _bottomRightCornerHandle => true):
					setBotRight(mx,my);
					
					case (_ == _rectSprite => true):
					setCenter(mx, my);
					

default:
				}
			}
			
			render(me.altKey);
		}
		/**
		 * sets x/y and width to the specified display object
		 * @param	displayObject
		 */
		public function bracket(displayObject:DisplayObject) {
			_console.print("Measure tool bracketing: " + displayObject.name + ":" + displayObject);
			visible = true;
			_rect = displayObject.getRect(this);
			render();
			_console.print("Measure tool bracketing: " + displayObject.name + ":" + displayObject);
		}
		public function getMeasurements():String {
			return _rect.toString();
		}
		function render(local:Bool = false)
		{
			_rectSprite.graphics.clear();
			_rectSprite.graphics.beginFill(0, 0.2);
			_rectSprite.graphics.lineStyle(0, 0xFF0000);
			_rectSprite.graphics.drawRect(_rect.x, _rect.y, _rect.width, _rect.height);
				
			_bottomRightCornerHandle.x = _rect.x + _rect.width;
			_bottomRightCornerHandle.y = _rect.y + _rect.height;
			_topLeftCornerHandle.x = _rect.x;
			_topLeftCornerHandle.y = _rect.y;
			
			
			var p= new Point(_rect.x, _rect.y);
			if (_currentSpace != null&&local) {
				p = _currentSpace.globalToLocal(p);
			}
			_xyField.text = "x:" + p.x + " y:" + p.y;
			
			_xyField.x = _rect.x+5;
			_xyField.y = _rect.y - 14;
			_heightField.text = Std.string(_rect.height);
			_heightField.x = _rect.x+_rect.width;
			_heightField.y = _rect.y + _rect.height / 2-_heightField.textHeight/2;
			
			_widthField.text = Std.string(_rect.width);
			_widthField.x = _rect.x+_rect.width/2-_widthField.textWidth/2;
			_widthField.y = _rect.y + _rect.height;
			
		}
		
				
		@:flash.property public var increment(get,set):Float;
function  get_increment():Float { return _increment; }
function  set_increment(value:Float):Float		{
			_increment = value; 
			checkSnap();
return value;
		}
		
		public function toggle()
		{
			visible = !visible;
		}
		override function  get_visible():Bool { return super.visible; }
		
		override function  set_visible(value:Bool):Bool		{
			super.visible = value;
			
			if(visible){
				_console.print("Measuring bracket active", ConsoleMessageTypes.SYSTEM);
				_console.print("	Hold shift to round to values of 10", ConsoleMessageTypes.SYSTEM);
				_console.print("	Hold ctrl to snap to mouse target", ConsoleMessageTypes.SYSTEM);
				_console.print("	Hold alt to display coordinates local to current scope (if it is a DisplayObject)", ConsoleMessageTypes.SYSTEM);
			}else {
				_previousObj = null;
				_currentSpace = null;
			}
return value;
		}
		function startMeasure(selectMode:Bool = false)
		{
			if(Std.is(_scopeManager.currentScope.targetObject , DisplayObject)){
				invoke(selectMode, ASCompat.dynamicAs(_scopeManager.currentScope.targetObject , DisplayObject));
			}else {
				invoke(selectMode, _console.view.stage);
			}
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager)
		{
			_console = pm.console;
			_scopeManager = pm.scopeManager;
			pm.messaging.addCallback(Notifications.CONSOLE_SHOW, onVisible);
			_console.createCommand("measure", startMeasure, "Measurements", "Toggles a scalable measurement bracket and selection widget. If X is true, bracketing an object sets it as scope.");
			pm.botLayer.addChild(this);
		}
		
		
		public function shutdown(pm:PluginManager)
		{
			pm.botLayer.removeChild(this);
			_console.removeCommand("measure");
			pm.messaging.removeCallback(Notifications.CONSOLE_SHOW, onVisible);
			_console = null;
			_scopeManager = null;
		}
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String
		{
			return "Enables a scalable, snapping measurement bracket for accurate pixel measurements";
		}
		
				
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> 
		{
			return null;
		}
		
	}
	
