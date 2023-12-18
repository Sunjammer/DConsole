package com.furusystems.dconsole2.core.gui ;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.TextFormats;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class Window extends Sprite {
		public static inline final BAR_HEIGHT= 12;
		public static inline final SCALE_HANDLE_SIZE= 10;
		static final GRADIENT_MATRIX:Matrix = new Matrix();
		var _contents__com_furusystems_dconsole2_core_gui_Window/*redefined private*/:Sprite = new Sprite();
		var _chrome:Sprite = new Sprite();
		var _outlines:Shape = new Shape();
		var _header:Sprite = new Sprite();
		var _titleField:TextField = new TextField();
		var _resizeHandle:Sprite = new Sprite();
		var _clickOffset:Point = new Point();
		var _resizeRect:Rectangle = new Rectangle();
		var _maxRect:Rectangle;
		var _minRect:Rectangle;
		var _maxScrollV:Float = 0;
		var _maxScrollH:Float = 0;
		var _scrollBarBottom:SimpleScrollbar = new SimpleScrollbar(SimpleScrollbar.HORIZONTAL);
		var _scrollBarRight:SimpleScrollbar = new SimpleScrollbar(SimpleScrollbar.VERTICAL);
		var _closeButton:Sprite = new Sprite();
		var _background:Shape = new Shape();
		public var viewRect:Rectangle;
		var _constrainToStage:Bool = false;
		var pt:Point = new Point();
		
		public function new(title:String, rect:Rectangle, contents:DisplayObject = null, maxRect:Rectangle = null, minRect:Rectangle = null, enableClose:Bool = true, enableScroll:Bool = true, enableScale:Bool = true, constrainToStage:Bool = true) {
			super();
			tabEnabled = tabChildren = false;
			_scrollBarBottom.addEventListener(Event.CHANGE, onScroll);
			_scrollBarRight.addEventListener(Event.CHANGE, onScroll);
			
			_closeButton.graphics.beginFill(Colors.BUTTON_INACTIVE_BG);
			_closeButton.graphics.lineStyle(0, 0);
			_closeButton.graphics.drawRect(0, 0, BAR_HEIGHT - 3, BAR_HEIGHT - 3);
			_closeButton.buttonMode = true;
			
			_constrainToStage = constrainToStage;
			
			addChild(_background);
			this._contents__com_furusystems_dconsole2_core_gui_Window.y = _background.y = BAR_HEIGHT;
			addChild(this._contents__com_furusystems_dconsole2_core_gui_Window);
			
			this._maxRect = maxRect;
			this._minRect = minRect;
			
			//rect.height += BAR_HEIGHT;
			_titleField.height = BAR_HEIGHT + 3;
			_titleField.selectable = false;
			_titleField.defaultTextFormat = TextFormats.consoleTitleFormat;
			_titleField.embedFonts = true;
			_titleField.textColor = Colors.HEADER_FG;
			_titleField.text = title;
			_titleField.y -= 2;
			_titleField.mouseEnabled = false;
			
			_resizeHandle.graphics.clear();
			_resizeHandle.graphics.beginFill(Colors.CORE, 0);
			_resizeHandle.graphics.drawRect(0, 0, SCALE_HANDLE_SIZE, SCALE_HANDLE_SIZE);
			_resizeHandle.graphics.endFill();
			_resizeHandle.graphics.lineStyle(0, Colors.CORE);
			_resizeHandle.graphics.moveTo(SCALE_HANDLE_SIZE, 0);
			_resizeHandle.graphics.lineTo(0, SCALE_HANDLE_SIZE);
			_resizeHandle.graphics.moveTo(SCALE_HANDLE_SIZE, 5);
			_resizeHandle.graphics.lineTo(0, SCALE_HANDLE_SIZE + 5);
			_resizeHandle.scrollRect = new Rectangle(0, 0, SCALE_HANDLE_SIZE, SCALE_HANDLE_SIZE);
			_resizeHandle.blendMode = BlendMode.INVERT;
			
			_closeButton.addEventListener(MouseEvent.CLICK, onClose);
			_closeButton.addEventListener(MouseEvent.ROLL_OVER, onCloseRollover);
			_closeButton.addEventListener(MouseEvent.ROLL_OUT, onCloseRollout);
			
			addChild(_chrome);
			
			_header.addChild(_titleField);
			_chrome.addChild(_header);
			
			if (enableScroll) {
				_chrome.addChild(_scrollBarBottom);
				_chrome.addChild(_scrollBarRight);
			}
			if (enableScale)
				_chrome.addChild(_resizeHandle);
			if (enableClose)
				_chrome.addChild(_closeButton);
			_chrome.addChild(_outlines);
			
			_resizeHandle.buttonMode = _header.buttonMode = true;
			
			x = rect.x;
			y = rect.y;
			
			var dsf= new DropShadowFilter(4, 45, 0, .1, 8, 8);
			//filters = [dsf];
			
			redraw(rect);
			
			_header.addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
			_resizeHandle.addEventListener(MouseEvent.MOUSE_DOWN, startResizing);
			addEventListener(MouseEvent.MOUSE_DOWN, setDepth);
			if (contents != null) {
				setContents(contents);
			}
		}
		
		public function setViewRect(rect:Rectangle) {
			redraw(rect);
		}
		
		function onCloseRollout(e:MouseEvent) {
			cast(e.target, DisplayObject).blendMode = BlendMode.NORMAL;
		}
		
		function onCloseRollover(e:MouseEvent) {
			cast(e.target, DisplayObject).blendMode = BlendMode.INVERT;
		}
		
		function setTitle(str:String) {
			_titleField.text = str;
		}
		
		function onClose(e:MouseEvent) {
			_header.removeEventListener(MouseEvent.MOUSE_DOWN, startDragging);
			_resizeHandle.removeEventListener(MouseEvent.MOUSE_DOWN, startResizing);
			removeEventListener(MouseEvent.MOUSE_DOWN, setDepth);
		}
		
		function onScroll(e:Event) {
			var r= getContentsRect();
			var newRect= _contents__com_furusystems_dconsole2_core_gui_Window.scrollRect.clone();
			switch (e.target) {
				case (_ == _scrollBarBottom => true):
					newRect.x = _scrollBarBottom.outValue * (_maxScrollH - newRect.width);
					
				case (_ == _scrollBarRight => true):
					newRect.y = _scrollBarRight.outValue * (_maxScrollV - newRect.height);
					

default:
			}
			_contents__com_furusystems_dconsole2_core_gui_Window.scrollRect = newRect;
			redraw(viewRect);
		}
		
		function startResizing(e:MouseEvent) {
			_clickOffset.x = SCALE_HANDLE_SIZE - _resizeHandle.mouseX;
			_clickOffset.y = SCALE_HANDLE_SIZE - _resizeHandle.mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onResizeDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, onResizeStop);
		}
		
		function onResizeStop(e:MouseEvent) {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onResizeDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onResizeStop);
		}
		
		function onResizeDrag(e:MouseEvent) {
			e.updateAfterEvent();
			pt.x = mouseX + _clickOffset.x;
			pt.y = mouseY + _clickOffset.y;
			pt = localToGlobal(pt);
			pt.x = Math.min(stage.stageWidth, pt.x);
			pt.y = Math.min(stage.stageHeight, pt.y);
			pt = globalToLocal(pt);
			
			pt.x = Math.max(SCALE_HANDLE_SIZE + BAR_HEIGHT, pt.x);
			pt.y = Math.max(SCALE_HANDLE_SIZE + BAR_HEIGHT, pt.y);
			
			_resizeRect.width = pt.x;
			_resizeRect.height = pt.y - BAR_HEIGHT;
			_resizeRect.x = x;
			_resizeRect.y = y;
			if (_minRect != null) {
				_resizeRect.width = Math.max(_minRect.width, _resizeRect.width);
				_resizeRect.height = Math.max(_minRect.height, _resizeRect.height);
			}
			onResize();
			redraw(_resizeRect);
		}
		
		function onResize() {
		
		}
		
		function scroll(x:Int = 0, y:Int = 0) {
			if (_contents__com_furusystems_dconsole2_core_gui_Window.scrollRect.x + x >= 0) {
				if (_contents__com_furusystems_dconsole2_core_gui_Window.scrollRect.width + x <= _maxScrollH)
					_contents__com_furusystems_dconsole2_core_gui_Window.scrollRect.x += x;
			}
			if (_contents__com_furusystems_dconsole2_core_gui_Window.scrollRect.y + y >= 0) {
				if (_contents__com_furusystems_dconsole2_core_gui_Window.scrollRect.height + y <= _maxScrollV)
					_contents__com_furusystems_dconsole2_core_gui_Window.scrollRect.y += y;
			}
		}
		
		function resetScroll() {
			_contents__com_furusystems_dconsole2_core_gui_Window.scrollRect.x = 0;
			_contents__com_furusystems_dconsole2_core_gui_Window.scrollRect.y = 0;
			_scrollBarBottom.outValue = 0;
			_scrollBarRight.outValue = 0;
		}
		
		public function updateAppearance() {
			//TODO: Update theme
		}
		
		function redraw(rect:Rectangle) {
			//GRADIENT_MATRIX.createGradientBox(rect.width * 3, rect.height * 3);
			
			_background.graphics.clear();
			_background.graphics.beginFill(Colors.ASSISTANT_BG);
			//_background.graphics.beginGradientFill(GradientType.RADIAL, [Colors.CORE, Colors.DROPDOWN_BG_INACTIVE], [1, 1], [0, 255], GRADIENT_MATRIX);
			_background.graphics.drawRect(0, 0, rect.width, rect.height);
			
			_header.graphics.clear();
			_header.graphics.beginFill(Colors.HEADER_BG);
			_header.graphics.drawRect(0, 0, rect.width, BAR_HEIGHT);
			_header.graphics.endFill();
			
			_outlines.graphics.clear();
			_outlines.graphics.lineStyle(0, 0);
			_outlines.graphics.drawRect(0, 0, rect.width, rect.height + BAR_HEIGHT);
			
			_titleField.width = rect.width;
			_closeButton.x = rect.width - (BAR_HEIGHT - 2);
			_closeButton.y = 1;
			
			_resizeHandle.x = rect.width - SCALE_HANDLE_SIZE;
			_resizeHandle.y = rect.height + BAR_HEIGHT - SCALE_HANDLE_SIZE;
			
			var cRect= getContentsRect();
			
			if (rect.width < cRect.width) {
				_maxScrollH = cRect.width;
			} else {
				_maxScrollH = 0;
			}
			if (rect.height < cRect.height) {
				_maxScrollV = cRect.height;
			} else {
				_maxScrollV = 0;
			}
			_contents__com_furusystems_dconsole2_core_gui_Window.scrollRect = new Rectangle(Math.max(0, _scrollBarBottom.outValue * (_maxScrollH - rect.width)), Math.max(0, _scrollBarRight.outValue * (_maxScrollV - rect.height)), rect.width + 1, rect.height + 1);
			updateScrollBars(_maxScrollH, _maxScrollV, rect);
			viewRect = rect;
			
			x = viewRect.x;
			y = viewRect.y;
		}
		
		function updateScrollBars(maxH:Float, maxV:Float, rect:Rectangle) {
			if (maxH > 0) {
				_scrollBarBottom.visible = true;
				_scrollBarBottom.y = rect.height + BAR_HEIGHT - _scrollBarBottom.trackWidth;
				_scrollBarBottom.draw(rect.width - SCALE_HANDLE_SIZE, _contents__com_furusystems_dconsole2_core_gui_Window.scrollRect, _contents__com_furusystems_dconsole2_core_gui_Window.scrollRect.x, maxH);
			} else {
				_scrollBarBottom.visible = false;
			}
			
			if (maxV > 0) {
				_scrollBarRight.visible = true;
				_scrollBarRight.x = rect.width - _scrollBarRight.trackWidth;
				_scrollBarRight.y = BAR_HEIGHT;
				_scrollBarRight.draw(rect.height - SCALE_HANDLE_SIZE, _contents__com_furusystems_dconsole2_core_gui_Window.scrollRect, _contents__com_furusystems_dconsole2_core_gui_Window.scrollRect.y, maxV);
			} else {
				_scrollBarRight.visible = false;
			}
		}
		
		function getContentsRect():Rectangle {
			if (_contents__com_furusystems_dconsole2_core_gui_Window.numChildren < 1)
				return new Rectangle();
			return _contents__com_furusystems_dconsole2_core_gui_Window.getChildAt(0).getRect(_contents__com_furusystems_dconsole2_core_gui_Window);
		}
		
		function setDepth(e:MouseEvent) {
			parent.setChildIndex(this, parent.numChildren - 1);
		}
		
		function startDragging(e:MouseEvent) {
			_clickOffset.x = _chrome.mouseX;
			_clickOffset.y = _chrome.mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onWindowDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
		}
		
		function stopDragging(e:MouseEvent) {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onWindowDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragging);
		}
		
		function onWindowDrag(e:MouseEvent) {
			x = stage.mouseX - _clickOffset.x;
			y = stage.mouseY - _clickOffset.y;
			/*if (_constrainToStage) {
			   x = Math.max(0, Math.min(x, stage.stageWidth - width));
			   y = Math.max(0, Math.min(y, stage.stageHeight - height));
			 }*/
			viewRect.x = x;
			viewRect.y = y;
			//e.updateAfterEvent();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function setContents(d:DisplayObject, autoScale:Bool = false) {
			while (_contents__com_furusystems_dconsole2_core_gui_Window.numChildren > 0) {
				_contents__com_furusystems_dconsole2_core_gui_Window.removeChildAt(0);
			}
			_contents__com_furusystems_dconsole2_core_gui_Window.addChild(d);
			if (autoScale) {
				scaleToContents();
			}
		}
		
		function scaleToContents() {
			viewRect = getContentsRect();
			redraw(viewRect);
			onResize();
		}
		
		@:flash.property public var header(get,never):Sprite;
function  get_header():Sprite {
			return _header;
		}
	
	}

