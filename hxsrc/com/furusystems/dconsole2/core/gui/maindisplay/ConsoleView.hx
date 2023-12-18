package com.furusystems.dconsole2.core.gui.maindisplay
;
	// {
	import com.furusystems.dconsole2.core.animation.ConsoleTweener;
	import com.furusystems.dconsole2.core.animation.EasingTween;
	import com.furusystems.dconsole2.core.gui.DockingGuides;
	import com.furusystems.dconsole2.core.gui.layout.HorizontalSplit;
	import com.furusystems.dconsole2.core.gui.layout.IContainable;
	import com.furusystems.dconsole2.core.gui.layout.ILayoutContainer;
	import com.furusystems.dconsole2.core.gui.maindisplay.assistant.Assistant;
	import com.furusystems.dconsole2.core.gui.maindisplay.filtertabrow.FilterTabRow;
	import com.furusystems.dconsole2.core.gui.maindisplay.input.InputField;
	import com.furusystems.dconsole2.core.gui.maindisplay.output.OutputField;
	import com.furusystems.dconsole2.core.gui.maindisplay.sections.HeaderSection;
	import com.furusystems.dconsole2.core.gui.maindisplay.sections.InspectorSection;
	import com.furusystems.dconsole2.core.gui.maindisplay.sections.MainSection;
	import com.furusystems.dconsole2.core.gui.maindisplay.toolbar.ConsoleToolbar;
	import com.furusystems.dconsole2.core.gui.ScaleHandle;
	import com.furusystems.dconsole2.core.inspector.Inspector;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.messaging.pimp.MessageData;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	// }

	/**
	 * Root level of the console main view
	 * @author Andreas Roenning
	 */
	 class ConsoleView extends Sprite implements IContainable implements  ILayoutContainer
	{
		static public inline final SHOW_TIME= 0.4;
		var _console:DConsole;
		var _rect:Rectangle;

		var _mainSection:MainSection; // section containing main console io
		var _inspectorSection:InspectorSection; // section containing display list inspector
		var _headerSection:HeaderSection; // section containing toolbar
		var _children:Array<ASAny> = [];
		var _mainSplit:HorizontalSplit;
		var _mainSplitDragBar:Sprite;
		var _mainSplitClickOffset:Float = Math.NaN;
		var _mainSplitToggled:Bool = false;
		var _inspector:Inspector;
		var _isDragging:Bool = false;

		var _scalePreview:Shape = new Shape();
		var _tempScaleRect:Rectangle = new Rectangle();
		var _prevSplitPos:Int = -1;
		var _texture:BitmapData;
		var _bg:Sprite = new Sprite();
		var _inspectorVisible:Bool = false;

		var _scaleHandle:ScaleHandle;

		var _prevRect:Rectangle = null;
		var _firstRun:Bool = false;

		@:flash.property public var input(get,never):InputField;
function  get_input():InputField
		{
			return _mainSection.input;
		}

		@:flash.property public var output(get,never):OutputField;
function  get_output():OutputField
		{
			return _mainSection.output;
		}

		@:flash.property public var filtertabs(get,never):FilterTabRow;
function  get_filtertabs():FilterTabRow
		{
			return _mainSection.filterTabs;
		}

		@:flash.property public var assistant(get,never):Assistant;
function  get_assistant():Assistant
		{
			return _mainSection.assistant;
		}

		@:flash.property public var inspector(get,never):Inspector;
function  get_inspector():Inspector
		{
			return _inspectorSection.inspector;
		}

		@:flash.property public var toolbar(get,never):ConsoleToolbar;
function  get_toolbar():ConsoleToolbar
		{
			return _headerSection.toolBar;
		}

		@:flash.property public var scaleHandle(get,never):ScaleHandle;
function  get_scaleHandle():ScaleHandle
		{
			return _scaleHandle;
		}

		public function new(console:DConsole = null)
		{
			super();
			_scaleHandle = new ScaleHandle(console);
			visible = false;

			_console = console;

			_texture = new BitmapData(3, 3, true, 0);
			_texture.setPixel32(0, 0, 0xCC000000);

			tabEnabled = tabChildren = false;
			_mainSection = new MainSection(console);
			_inspectorSection = new InspectorSection(console);
			_headerSection = new HeaderSection(console);

			addChild(_bg);
			addChild(_headerSection);

			_mainSplitDragBar = new Sprite();
			_mainSplit = new HorizontalSplit();
			_mainSplit.leftCell.addChild(_inspectorSection);
			_mainSplit.rightCell.addChild(_mainSection);
			_mainSplitDragBar.alpha = 0;
			_mainSplit.splitRatio = 0.2;

			addChild(_mainSplit);
			addChild(_mainSplitDragBar);
			addChild(_scaleHandle);

			_mainSplitDragBar.addEventListener(MouseEvent.MOUSE_DOWN, beginMainSplitDrag);
			_mainSplitDragBar.addEventListener(MouseEvent.MOUSE_OVER, onMainsplitMouseOver);
			_mainSplitDragBar.addEventListener(MouseEvent.MOUSE_OUT, onMainsplitMouseOut);
			_mainSplitDragBar.addEventListener(MouseEvent.DOUBLE_CLICK, toggleMainSplit);
			_mainSplitDragBar.doubleClickEnabled = true;
			_mainSplitDragBar.buttonMode = true;

			scaleHandle.addEventListener(MouseEvent.MOUSE_DOWN, beginScaleDrag);
			scaleHandle.addEventListener(MouseEvent.DOUBLE_CLICK, onScaleDoubleclick);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			tabEnabled = tabChildren = false;

			_console.messaging.addCallback(Notifications.INSPECTOR_VIEW_REMOVED, onInspectorViewCountChange);
			_console.messaging.addCallback(Notifications.INSPECTOR_VIEW_ADDED, onInspectorViewCountChange);

			_console.messaging.addCallback(Notifications.TOOLBAR_DRAG_START, onToolbarDrag);
			_console.messaging.addCallback(Notifications.TOOLBAR_DRAG_STOP, onToolbarDrag);
			_console.messaging.addCallback(Notifications.TOOLBAR_DRAG_UPDATE, onToolbarDrag);

			_console.messaging.addCallback(Notifications.CORNER_DRAG_START, onCornerScale);
			_console.messaging.addCallback(Notifications.CORNER_DRAG_STOP, onCornerScale);
			_console.messaging.addCallback(Notifications.CORNER_DRAG_UPDATE, onCornerScale);

			// setupBloom();
			// addChild(bloom);
		}

		function setupBloom()
		{
			addEventListener(Event.ENTER_FRAME, updateBloom);
			scanlinePattern.setPixel32(0, 0, 0xFF808080);
			scanlinePattern.setPixel32(0, 1, 0xFFeeeeee);
		}

		public function toggleBloom()
		{
			bloomEnabled = !bloomEnabled;
			if (!bloomEnabled)
			{
				if (contains(bloom))
					removeChild(bloom);
				if (contains(scanlines))
					removeChild(scanlines);
			}
		}

		function onCornerScale(md:MessageData)
		{
			switch (md.message)
			{
				case Notifications.CORNER_DRAG_START:
					Mouse.cursor = MouseCursor.HAND;
					
				case Notifications.CORNER_DRAG_STOP:
					Mouse.cursor = MouseCursor.AUTO;
					
				case Notifications.CORNER_DRAG_UPDATE:
					_tempScaleRect.height = Math.fround(Math.max(GUIUnits.SQUARE_UNIT * 5, Math.min(stage.stageHeight - GUIUnits.SQUARE_UNIT, (stage.mouseY - y))) / GUIUnits.SQUARE_UNIT) * GUIUnits.SQUARE_UNIT; // TODO: This is messy as hell!
					_tempScaleRect.width = stage.mouseX - x;
					var r= rect;
					r.height = _tempScaleRect.height;
					r.width = _tempScaleRect.width;
					r.width = Math.fceil(Math.max(150, Math.min(r.width, stage.stageWidth - x)));
					rect = r;
					
			}
		}

		override function  get_x():Float
		{
			return super.x;
		}

		override function  set_x(value:Float):Float		{
			if (super.x == value)
				return value;
			super.x = _console.persistence.consoleX = value;
return value;
		}

		override function  get_y():Float
		{
			return super.y;
		}

		override function  set_y(value:Float):Float		{
			if (super.y == value)
				return value;
			super.y = _console.persistence.consoleY = value;
return value;
		}

		override function  get_height():Float
		{
			return _console.persistence.consoleHeight;
		}

		override function  set_height(value:Float):Float		{
			_console.persistence.consoleHeight = value;
			rect = _console.persistence.rect;
return value;
		}

		override function  get_width():Float
		{
			return _console.persistence.consoleWidth;
		}

		override function  set_width(value:Float):Float		{
			_console.persistence.consoleWidth = value;
			rect = _console.persistence.rect;
return value;
		}

		function onToolbarDrag(md:MessageData)
		{
			switch (md.message)
			{
				case Notifications.TOOLBAR_DRAG_START:
					Mouse.cursor = MouseCursor.HAND;
					
				case Notifications.TOOLBAR_DRAG_STOP:
					Mouse.cursor = MouseCursor.AUTO;
					_console.messaging.send(Notifications.HIDE_DOCKING_GUIDE, null, this);
					updateDocking();
					
				case Notifications.TOOLBAR_DRAG_UPDATE:
					x += md.data.x;
					y += md.data.y;
					x = Std.int(Math.max(0, Math.min(x, stage.stageWidth - _rect.width)));
					y = Std.int(Math.max(0, Math.min(y, stage.stageHeight - _rect.height)));

					scaleHandle.visible = true;
					if (y <= 2)
					{
						_console.messaging.send(Notifications.SHOW_DOCKING_GUIDE, DockingGuides.TOP, this);
						_console.persistence.dockState.value = DConsole.DOCK_TOP;
						_scaleHandle.y = _rect.height;
					}
					else if (y >= stage.stageHeight - _rect.height - 2)
					{
						_console.messaging.send(Notifications.SHOW_DOCKING_GUIDE, DockingGuides.BOT, this);
						_console.persistence.dockState.value = DConsole.DOCK_BOT;
						_scaleHandle.y = -scaleHandle.height;
					}
					else
					{
						_console.messaging.send(Notifications.HIDE_DOCKING_GUIDE, null, this);
						_console.persistence.dockState.value = DConsole.DOCK_WINDOWED;
						scaleHandle.visible = false;
					}
					assistant.cornerHandle.visible = !scaleHandle.visible;
					
			}
		}

		function onInspectorViewCountChange(md:MessageData)
		{
			_mainSplit.splitRatio = _console.persistence.verticalSplitRatio.value;
			doLayout();
		}

		function onAddedToStage(e:Event)
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_firstRun = true;
			initFromPersistence();
			switch (dockingMode)
			{
				case DConsole.DOCK_BOT:
					y = stage.stageHeight + 10;
					
				case DConsole.DOCK_TOP:
					y = -height;
					
			}
			onParentUpdate(_rect);
			_firstRun = false;
		}

		function initFromPersistence()
		{
			_mainSplit.splitRatio = _console.persistence.verticalSplitRatio.value;
			inspector.enabled = _mainSplit.splitRatio > 0;
			rect = _console.persistence.rect;
			x = _console.persistence.consoleX;
			y = _console.persistence.consoleY;
		}

		
		@:flash.property public var splitRatio(get,set):Float;
function  get_splitRatio():Float
		{
			return _mainSplit.splitRatio;
		}
function  set_splitRatio(n:Float):Float		{
			return _mainSplit.splitRatio = n;
		}

		function onScaleDoubleclick(e:MouseEvent)
		{
			var r= rect;
			if (r.height < 50)
			{
				r.height = stage.stageHeight * .8;
			}
			else
			{
				r.height = 0;
			}
			rect = r;
		}

		function beginScaleDrag(e:MouseEvent)
		{
			Mouse.cursor = MouseCursor.HAND;
			scaleHandle.dragging = true;
			_scalePreview.visible = true;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onScaleUpdate);
			stage.addEventListener(MouseEvent.MOUSE_UP, completeScale);
			onScaleUpdate(e);
		}

		function completeScale(e:MouseEvent)
		{
			Mouse.cursor = MouseCursor.AUTO;
			scaleHandle.dragging = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onScaleUpdate);
			stage.removeEventListener(MouseEvent.MOUSE_UP, completeScale);
			doLayout();
		}

		function onScaleUpdate(e:MouseEvent)
		{
			Mouse.cursor = MouseCursor.HAND;
			var r= rect;
			switch (dockingMode)
			{
				case DConsole.DOCK_BOT:
					_tempScaleRect.height = Math.fround(Math.max(GUIUnits.SQUARE_UNIT * 1, Math.min(stage.stageHeight - GUIUnits.SQUARE_UNIT, stage.stageHeight - stage.mouseY - 8)) / GUIUnits.SQUARE_UNIT) * GUIUnits.SQUARE_UNIT;
					if (r.height != _tempScaleRect.height)
					{
						r.height = height = _tempScaleRect.height;
						rect = r;
						y = stage.stageHeight - r.height;
					}
					
				default:
					_tempScaleRect.height = Math.fround(Math.max(GUIUnits.SQUARE_UNIT * 1, Math.min(stage.stageHeight - GUIUnits.SQUARE_UNIT, stage.mouseY - 8)) / GUIUnits.SQUARE_UNIT) * GUIUnits.SQUARE_UNIT;
					if (r.height != _tempScaleRect.height)
					{
						r.height = height = _tempScaleRect.height;
						rect = r;
					}
			}
		}

		function showInspector()
		{
			if (!_inspectorVisible || _firstRun)
			{
				_mainSplit.setSplitPos(_prevSplitPos);
				_inspectorVisible = true;
				inspector.enabled = _prevSplitPos > 0;
			}
		}

		function hideInspector()
		{
			if (_inspectorVisible || _firstRun)
			{
				_inspectorVisible = inspector.enabled = false;
				_prevSplitPos = _mainSplit.getSplitPos();
				_mainSplit.setSplitPos(0);
			}
		}

		public function setHeaderText(text:String)
		{
			_headerSection.toolBar.setTitle(text);
		}

		function doLayout()
		{
			if (_prevRect != null)
			{
				if (_prevRect.equals(_rect))
					return;
			}
			var r= _rect.clone();
			_headerSection.onParentUpdate(r);
			if (_headerSection.visible)
			{
				r.y = GUIUnits.SQUARE_UNIT;
				r.height -= GUIUnits.SQUARE_UNIT;
			}
			else
			{
				// if there is no header, move us up a spot
			}
			_mainSplit.rect = r;
			_mainSplitDragBar.graphics.clear();
			if (rect.height < 128 || !inspector.viewsAdded)
			{
				hideInspector();
				_mainSplit.setSplitPos(0);
			}
			else
			{
				showInspector();
				_mainSplitDragBar.graphics.beginFill(0, 0.1);
				_mainSplitDragBar.graphics.drawRect(0, 0, 8, r.height);
				_mainSplitDragBar.x = Std.int(_mainSplit.splitRatio * r.width - 4);
				_mainSplitDragBar.y = _mainSplit.y;
			}
			r.height = GUIUnits.SQUARE_UNIT;

			switch (dockingMode)
			{
				case DConsole.DOCK_BOT:
					r.y = -scaleHandle.height;
					scaleHandle.onParentUpdate(r);
					
				default:
					r.y = _rect.height;
					scaleHandle.onParentUpdate(r);
			}

			_prevRect = r.clone();
		}

		function onMainsplitMouseOut(e:MouseEvent)
		{
			if (_isDragging)
				return;
			_mainSplitDragBar.alpha = 0;
			_mainSplitDragBar.blendMode = BlendMode.NORMAL;
			Mouse.cursor = MouseCursor.AUTO;
		}

		function onMainsplitMouseOver(e:MouseEvent)
		{
			if (_isDragging)
				return;
			_mainSplitDragBar.alpha = 1;
			_mainSplitDragBar.blendMode = BlendMode.INVERT;
			Mouse.cursor = MouseCursor.HAND;
		}

		function toggleMainSplit(e:MouseEvent)
		{
			if (_mainSplit.getSplitPos() > 30)
			{
				_inspectorVisible = false;
				_prevSplitPos = _mainSplit.getSplitPos();
				_mainSplit.setSplitPos(0);
				hideInspector();
			}
			else
			{
				_inspectorVisible = true;
				_mainSplit.setSplitPos(_prevSplitPos = 300);
				showInspector();
			}
			doLayout();
		}

		function beginMainSplitDrag(e:MouseEvent)
		{
			_isDragging = true;
			_mainSplitDragBar.alpha = 1;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, updateMainSplitDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopMainSplitDrag);
		}

		function stopMainSplitDrag(e:MouseEvent)
		{
			_isDragging = false;
			_mainSplitDragBar.alpha = 0;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, updateMainSplitDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopMainSplitDrag);
			Mouse.cursor = MouseCursor.AUTO;
		}

		function updateMainSplitDrag(e:MouseEvent)
		{
			Mouse.cursor = MouseCursor.HAND;
			var p= Std.int(Math.max(0, Math.min(_rect.width / 2, mouseX)));
			if (p < 30)
				p = 0;

			inspector.enabled = p > 0;
			_mainSplit.setSplitPos(p);

			_console.persistence.verticalSplitRatio.value = _mainSplit.splitRatio;
			doLayout();
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			children.push(child);
			return super.addChild(child);
		}

		/* INTERFACE com.furusystems.dconsole2.core.gui.layout.IContainable */

		public function onParentUpdate(allotedRect:Rectangle)
		{
			allotedRect.height = Math.ffloor(allotedRect.height);
			allotedRect.width = Math.fround(allotedRect.width);
			rect = allotedRect;
		}

		public function show()
		{
			visible = output.visible = true;
			switch (dockingMode)
			{
				case DConsole.DOCK_WINDOWED:
					onShown();
					
				case DConsole.DOCK_BOT:
					ConsoleTweener.tween(this, "y", stage.stageHeight - height, SHOW_TIME, onShown, EasingTween);
					
				default:
					ConsoleTweener.tween(this, "y", 0, SHOW_TIME, onShown, EasingTween);
			}
		}

		function onShown()
		{
			_console.messaging.send(Notifications.CONSOLE_VIEW_TRANSITION_COMPLETE, true);
		}

		public function hide()
		{

			if (stage == null)
			{
				onHidden();
				return;
			}
			switch (dockingMode)
			{
				case DConsole.DOCK_WINDOWED:
					onHidden();
					
				case DConsole.DOCK_BOT:
					ConsoleTweener.tween(this, "y", stage.stageHeight + 10, SHOW_TIME, onHidden, EasingTween);
					
				default:
					ConsoleTweener.tween(this, "y", -height, SHOW_TIME, onHidden, EasingTween);
			}
		}

		public function maximize()
		{
			var r:Rectangle;
			switch (dockingMode)
			{
				case DConsole.DOCK_WINDOWED:
					dockingMode = DConsole.DOCK_TOP;
					maximize();
					
				default:
					r = _rect;
					r.height = stage.stageHeight - GUIUnits.SQUARE_UNIT;
					r.width = stage.stageWidth;
					rect = r;
					updateDocking();
					output.drawMessages();
			}
		}

		public function minimize()
		{
			var r= _rect;
			switch (dockingMode)
			{
				case DConsole.DOCK_WINDOWED:
					r.height = 5 * GUIUnits.SQUARE_UNIT;
					rect = r;
					
				default:
					r.height = GUIUnits.SQUARE_UNIT;
					// r.width = stage.stageWidth;
					updateDocking();
					rect = r;
			}
			output.drawMessages();
		}

		public function consolidateView()
		{
			var r= _console.persistence.rect;
			x = r.x;
			y = r.y;
			width = r.width;
			height = r.height;
			updateDocking();
		}

		function onHidden()
		{
			visible = output.visible = false;
			_console.messaging.send(Notifications.CONSOLE_VIEW_TRANSITION_COMPLETE, false);
		}

		@:flash.property public var children(get,never):Array<ASAny>;
function  get_children():Array<ASAny>
		{
			return _children;
		}

		/* INTERFACE com.furusystems.dconsole2.core.gui.layout.ILayoutContainer */

		
		@:flash.property public var rect(get,set):Rectangle;
function  set_rect(r:Rectangle):Rectangle		{
			// if (_rect) {
			// if (_rect.equals(r)) return;
			// }
			_rect = r;
			_rect.x = _rect.y = 0;
			_rect.height = Math.ffloor(Math.max(minHeight, _rect.height) / GUIUnits.SQUARE_UNIT) * GUIUnits.SQUARE_UNIT;
			_rect.width = Std.int(Math.max(minWidth, _rect.width));
			_bg.graphics.clear();
			_bg.graphics.lineStyle(0, Colors.CORE);
			// _bg.graphics.beginBitmapFill(_texture, null, true);
			_bg.graphics.drawRect(0, 0, _rect.width, _rect.height);
			_bg.graphics.endFill();
			// scrollRect = _rect;

			_console.persistence.consoleWidth = _rect.width;
			_console.persistence.consoleHeight = _rect.height;
			doLayout();
return r;
		}
function  get_rect():Rectangle
		{
			return _console.persistence.rect;
		}

		@:flash.property public var minHeight(get,never):Float;
function  get_minHeight():Float
		{
			return 32;
		}

		@:flash.property public var minWidth(get,never):Float;
function  get_minWidth():Float
		{
			return 0;
		}

		@:flash.property public var mainSection(get,never):MainSection;
function  get_mainSection():MainSection
		{
			return _mainSection;
		}

		
		@:flash.property public var dockingMode(get,set):Int;
function  get_dockingMode():Int
		{
			return _console.persistence.dockState.value;
		}
function  set_dockingMode(value:Int):Int		{
			_console.persistence.dockState.value = value;
			updateDocking();
return value;
		}

		function updateDocking()
		{
			scaleHandle.visible = true;
			switch (dockingMode)
			{
				case DConsole.DOCK_TOP:
					_rect.width = stage.stageWidth;
					rect = _rect;
					x = 0;
					y = 0;
					
				case DConsole.DOCK_BOT:
					_rect.width = stage.stageWidth;
					_scaleHandle.y = -scaleHandle.height;
					rect = _rect;
					y = stage.stageHeight - _rect.height;
					x = 0;
					
				case DConsole.DOCK_WINDOWED:
					rect = _rect;
					scaleHandle.visible = false;
					
			}
			assistant.cornerHandle.visible = !scaleHandle.visible;
		}

		var bloomBmp:BitmapData;
		var bloom:Bitmap = new Bitmap();
		var scanlines:Shape = new Shape();
		var scanlinePattern:BitmapData = new BitmapData(1, 3, true, 0);
		var bloomEnabled:Bool = false;

		function updateBloom(e:Event = null)
		{
			if (!bloomEnabled)
				return;
			scanlines.graphics.clear();
			scanlines.graphics.beginBitmapFill(scanlinePattern, null, true, false);
			scanlines.graphics.drawRect(0, 0, output.width, output.height);
			scanlines.graphics.endFill();
			scanlines.blendMode = BlendMode.MULTIPLY;
			if (bloomBmp != null)
			{
				bloomBmp.dispose();
			}
			if (contains(bloom))
				removeChild(bloom);
			if (contains(scanlines))
				removeChild(scanlines);
			bloom.blendMode = BlendMode.ADD;
			bloomBmp = new BitmapData(Std.int(output.width), Std.int(output.height), true, 0);
			bloomBmp.lock();
			bloomBmp.draw(output);

			bloomBmp.applyFilter(bloomBmp, bloomBmp.rect, new Point(), new BlurFilter(16, 16, 1));
			bloomBmp.applyFilter(bloomBmp, bloomBmp.rect, new Point(), new BlurFilter(16, 16, 1));
			bloomBmp.colorTransform(bloomBmp.rect, new ColorTransform(1, 2, 1));
			bloomBmp.unlock();
			bloom.bitmapData = bloomBmp;

			addChild(bloom);
			addChild(scanlines);

			var p= new Point(output.x, output.y);
			p = output.parent.localToGlobal(p);
			bloom.x = scanlines.x = p.x - x;
			bloom.y = scanlines.y = p.y - y;
		}
	}

