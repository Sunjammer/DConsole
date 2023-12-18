package com.furusystems.dconsole2.core.inspector ;
	import com.furusystems.dconsole2.core.gui.layout.IContainable;
	import com.furusystems.dconsole2.core.inspector.buttons.ModeSelector;
	import com.furusystems.dconsole2.core.interfaces.IThemeable;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.plugins.IDConsoleInspectorPlugin;
	import com.furusystems.dconsole2.core.style.Alphas;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Andreas Ronning
	 */
	 class Inspector extends Sprite implements IContainable implements  IThemeable {
		var posClicked:Point;
		var dragging:Bool = false;
		var vScrollBar:Shape;
		var hScrollBar:Shape;
		var _modeSelector:ModeSelector;
		var _dims:Rectangle;
		var _currentView:AbstractInspectorView;
		var prevPos:Point = new Point();
		var _viewContainer:Sprite = new Sprite();
		var _enabled:Bool = true;
		var _views:Vector<AbstractInspectorView> = new Vector();
		var _messaging:PimpCentral;
		
		public function new(console:IConsole, dims:Rectangle) {
			super();
			_messaging = console.messaging;
			_dims = dims;
			graphics.clear();
			graphics.beginFill(Colors.INSPECTOR_BG);
			graphics.drawRect(0, 0, dims.width, dims.height);
			
			_modeSelector = new ModeSelector(console);
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
			vScrollBar = new Shape();
			hScrollBar = new Shape();
			vScrollBar.blendMode = hScrollBar.blendMode = BlendMode.INVERT;
			_viewContainer.y = vScrollBar.y = hScrollBar.y = GUIUnits.SQUARE_UNIT;
			vScrollBar.visible = hScrollBar.visible = false;
			
			addChild(_viewContainer);
			addChild(_modeSelector);
			addChild(vScrollBar);
			addChild(hScrollBar);
			_messaging.addCallback(Notifications.THEME_CHANGED, onThemeChange);
			_messaging.addCallback(Notifications.INSPECTOR_MODE_CHANGE, onModeChanged);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function addView(v:IDConsoleInspectorPlugin) {
			v.associateWithInspector(this);
			_viewContainer.addChild(v.view);
			_modeSelector.addOption(v);
			_views.push(v.view);
			setCurrentView(v.view);
			v.view.resize();
			_messaging.send(Notifications.INSPECTOR_VIEW_ADDED, v, this);
		}
		
		public function setCurrentView(v:AbstractInspectorView) {
			_modeSelector.setCurrentMode(v);
		}
		
		public function removeView(v:IDConsoleInspectorPlugin) {
			if (_viewContainer.contains(v.view)) {
				_viewContainer.removeChild(v.view);
				_modeSelector.removeButton(v);
				_views.splice(_views.indexOf(v.view), 1);
				if (v.view == _currentView) {
					if (viewsAdded)
						setCurrentView(_views[0]);
				}
			}
			_messaging.send(Notifications.INSPECTOR_VIEW_REMOVED, v, this);
			//TODO: Test. This will cause SOME damn issue.
		}
		
		function onAddedToStage(e:Event) {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//tv.populate(stage);
		}
		
		public function onFrameUpdate(e:Event = null) {
			if (_currentView != null && _enabled) {
				_currentView.onFrameUpdate(e);
			}
		}
		
		function onModeChanged(md:MessageData) {
			if (_currentView == md.data)
				return;
			if (_currentView != null)
				_viewContainer.removeChild(_currentView);
			_currentView = ASCompat.dynamicAs(md.data , AbstractInspectorView);
			_viewContainer.addChild(_currentView);
		}
		
		function renderBars() {
			vScrollBar.graphics.clear();
			hScrollBar.graphics.clear();
			if (_currentView.scrollYEnabled) {
				var y= _currentView.scrollY / _currentView.maxScrollY * (_dims.height - 6);
				vScrollBar.graphics.beginFill(Colors.SCROLLBAR_FG);
				vScrollBar.graphics.drawRect(_dims.width - 3, y, 3, 3);
			}
			if (_currentView.scrollXEnabled) {
				var x= _currentView.scrollX / _currentView.maxScrollX * (_dims.width - 3);
				hScrollBar.graphics.beginFill(Colors.SCROLLBAR_FG);
				hScrollBar.graphics.drawRect(x, _dims.height - 16, 3, 3);
			}
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.gui.layout.IContainable */
		
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
		
		public function onParentUpdate(allotedRect:Rectangle) {
			var rect= allotedRect.clone();
			x = rect.x;
			y = rect.y;
			rect.x = rect.y = 0;
			scrollRect = rect;
			dims = rect;
			drawBackground();
		}
		
		function drawBackground() {
			graphics.clear();
			graphics.beginFill(Colors.INSPECTOR_BG, Alphas.INSPECTOR_ALPHA);
			graphics.drawRect(0, 0, _dims.width, _dims.height);
			graphics.endFill();
		}
		
				
		@:flash.property public var dims(get,set):Rectangle;
function  get_dims():Rectangle {
			return _dims;
		}
function  set_dims(value:Rectangle):Rectangle{
			_dims = value;
			var i= 0;while (i < _views.length) {
				_views[i].resize();
i++;
			}
return value;
		}
		
		@:flash.property public var viewsAdded(get,never):Bool;
function  get_viewsAdded():Bool {
			return _views.length > 0;
		}
		
				
		@:flash.property public var enabled(get,set):Bool;
function  get_enabled():Bool {
			return _enabled && _views.length > 0;
		}
function  set_enabled(value:Bool):Bool{
			return _enabled = value;
		}
		
		function onMouseUp(e:MouseEvent) {
			if (dragging) {
				_currentView.stopDragging();
			}
			dragging = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			vScrollBar.visible = hScrollBar.visible = false;
		}
		
		function mouseDown(e:MouseEvent) {
			if (_currentView == null)
				return;
			posClicked = new Point(mouseX, mouseY);
			if (posClicked.y <= GUIUnits.SQUARE_UNIT)
				return;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			prevPos.x = mouseX;
			prevPos.y = mouseY;
		}
		
		function onMouseMove(e:MouseEvent) {
			if (Point.distance(new Point(mouseX, mouseY), posClicked) > 5) {
				beginDragging();
			}
			var deltaX= mouseX - prevPos.x;
			var deltaY= mouseY - prevPos.y;
			if (dragging) {
				if (e.shiftKey) {
					_currentView.scrollByDelta(deltaX * 2, deltaY * 2);
				} else {
					_currentView.scrollByDelta(deltaX, deltaY);
				}
				renderBars();
			}
			prevPos.x = mouseX;
			prevPos.y = mouseY;
		}
		
		function beginDragging() {
			vScrollBar.visible = hScrollBar.visible = true;
			dragging = true;
			_currentView.beginDragging();
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.interfaces.IThemeable */
		
		public function onThemeChange(md:MessageData) {
			drawBackground();
		}
	
	}

