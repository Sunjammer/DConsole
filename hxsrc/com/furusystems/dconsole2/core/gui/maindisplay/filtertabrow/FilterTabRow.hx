package com.furusystems.dconsole2.core.gui.maindisplay.filtertabrow ;
	import com.furusystems.dconsole2.core.DSprite;
	import com.furusystems.dconsole2.core.gui.layout.IContainable;
	import com.furusystems.dconsole2.core.interfaces.IThemeable;
	import com.furusystems.dconsole2.core.logmanager.DLogManager;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.messaging.pimp.MessageData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * A row of buttons letting you select the currently focused tag
	 * @author Andreas Roenning
	 */
	 class FilterTabRow extends Sprite implements IContainable implements  IThemeable {
		var _rect:Rectangle = new Rectangle();
		
		var _filters:Vector<String> = new Vector();
		var _logManager:DLogManager;
		var _buttonContainer:DSprite = new DSprite();
		var _scrollPos:Float = 0;
		var _clickOffsetX:Float = 0;
		var _scrolling:Bool = false;
		var _buttons:Array<ASAny>;
		var _console:IConsole;
		
		public function new(console:IConsole) {
			super();
			_console = console;
			_console.messaging.addCallback(Notifications.THEME_CHANGED, onThemeChange);
			_console.messaging.addCallback(Notifications.NEW_LOG_CREATED, onLogCreated);
			_console.messaging.addCallback(Notifications.LOG_DESTROYED, onLogDestroyed);
			_console.messaging.addCallback(Notifications.CURRENT_LOG_CHANGED, onCurrentLogChange);
			addChild(_buttonContainer);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		function onMouseDown(e:MouseEvent) {
			if (!scrollEnabled)
				return;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_clickOffsetX = mouseX;
		}
		
		function onMouseMove(e:MouseEvent) {
			var dx= mouseX - _clickOffsetX;
			if (Math.sqrt(dx * dx) > 5) {
				_scrolling = true;
				_buttonContainer.mouseEnabled = _buttonContainer.mouseChildren = false;
			}
			if (_scrolling)
				updateScroll();
		}
		
		function updateScroll() {
			var deltaX= mouseX - _clickOffsetX;
			_clickOffsetX = mouseX;
			_buttonContainer.x += deltaX;
			consolidateScrollPos();
		}
		
		@:flash.property var scrollEnabled(get,never):Bool;
function  get_scrollEnabled():Bool {
			var rect= _buttonContainer.transform.pixelBounds;
			var diffX= (rect.width - scrollRect.width);
			return diffX > 0;
		}
		
		function consolidateScrollPos() {
			var rect= _buttonContainer.transform.pixelBounds;
			var diffX= (rect.width - scrollRect.width);
			_buttonContainer.x = Math.max(-diffX, Math.min(_buttonContainer.x, 0));
		}
		
		function onMouseUp(e:MouseEvent) {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_buttonContainer.mouseEnabled = _buttonContainer.mouseChildren = true;
		}
		
		function onCurrentLogChange(md:MessageData) {
			_logManager = ASCompat.dynamicAs(md.source , DLogManager);
			var a= _buttonContainer.getChildren();
			for (_tmp_ in a) {
var btn:FilterTabButton  = _tmp_;
				btn.active = btn.logName.toLowerCase() == _logManager.currentLog.name.toLowerCase();
			}
		}
		
		function onLogDestroyed(md:MessageData) {
			_logManager = ASCompat.dynamicAs(md.source , DLogManager);
			updateButtons();
		}
		
		function updateButtons() {
			_buttonContainer.removeChildren();
			var btnNames= _logManager.getLogNames();
			_buttons = [];
			var i= 0;while (i < btnNames.length) {
				var btn= new FilterTabButton(_console, btnNames[i]);
				if (btn.logName.toLowerCase() == _logManager.currentLog.name.toLowerCase()) {
					btn.active = true;
				}
				_buttons.push(btn);
i++;
			}
			_buttonContainer.addChildren(_buttons, 0);
		}
		
		function onLogCreated(md:MessageData) {
			_logManager = ASCompat.dynamicAs(md.source , DLogManager);
			updateButtons();
		}
		
		public function redraw(width:Float) {
			graphics.clear();
			graphics.beginFill(Colors.FILTER_BG);
			graphics.drawRect(0, 0, width, GUIUnits.SQUARE_UNIT);
			scrollRect = new Rectangle(0, 0, width, GUIUnits.SQUARE_UNIT);
			for (_tmp_ in _buttons) {
var b:FilterTabButton  = _tmp_;
				b.redraw();
			}
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.gui.layout.IContainable */
		
		public function onParentUpdate(allotedRect:Rectangle) {
			_rect = allotedRect;
			y = _rect.y;
			x = _rect.x;
			redraw(_rect.width);
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.interfaces.IThemeable */
		
		public function onThemeChange(md:MessageData) {
			redraw(_rect.width);
		}
		
		@:flash.property public var rect(get,never):Rectangle;
function  get_rect():Rectangle {
			return getRect(parent);
		}
		
		@:flash.property public var minHeight(get,never):Float;
function  get_minHeight():Float {
			return 0;
		}
		
		@:flash.property public var minWidth(get,never):Float;
function  get_minWidth():Float {
			return 0;
		}
	
	}

