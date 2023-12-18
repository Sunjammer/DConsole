package com.furusystems.dconsole2.core.gui ;
	import com.furusystems.dconsole2.core.style.Colors;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class SimpleScrollbar extends Sprite {
		public static inline final VERTICAL= 0;
		public static inline final HORIZONTAL= 1;
		var orientation:Int = 0;
		public var trackWidth:Float = 4;
		public var thumbWidth:Float = 4;
		public var minThumbWidth:Float = thumbWidth;
		var length:Float = 0;
		public var outValue:Float = 0;
		var clickOffset:Float = 0;
		var thumbPos:Float = Math.NaN;
		
		public function new(orientation:Int) {
			super();
			this.orientation = orientation;
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
		}
		
		function startDragging(e:MouseEvent) {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, doScroll);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
			switch (orientation) {
				case VERTICAL:
					clickOffset = mouseY - thumbPos;
					
				case HORIZONTAL:
					clickOffset = mouseX - thumbPos;
					
			}
			doScroll();
		}
		
		function stopDragging(e:MouseEvent) {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, doScroll);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragging);
		}
		
		function doScroll(e:MouseEvent = null) {
			switch (orientation) {
				case VERTICAL:
					outValue = Math.max(0, Math.min(1, (mouseY - clickOffset) / (length - thumbWidth)));
					
				case HORIZONTAL:
					outValue = Math.max(0, Math.min(1, (mouseX - clickOffset) / (length - thumbWidth)));
					
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function draw(length:Float, viewRect:Rectangle, currentScroll:Float, maxScroll:Float) {
			this.length = length;
			graphics.clear();
			graphics.beginFill(Colors.SCROLLBAR_BG);
			currentScroll = Math.min(maxScroll, currentScroll);
			
			switch (orientation) {
				case VERTICAL:
					thumbWidth = Math.max(minThumbWidth, (viewRect.height / maxScroll) * length);
					thumbPos = (currentScroll / maxScroll) * length;
					graphics.drawRect(0, 0, trackWidth, length);
					graphics.beginFill(Colors.SCROLLBAR_FG);
					graphics.drawRect(0, thumbPos, trackWidth, thumbWidth);
					
					
				case HORIZONTAL:
					thumbWidth = Math.max(minThumbWidth, (viewRect.width / maxScroll) * length);
					thumbPos = (currentScroll / maxScroll) * length;
					graphics.drawRect(0, 0, length, trackWidth);
					graphics.beginFill(Colors.SCROLLBAR_FG);
					graphics.drawRect(thumbPos, 0, thumbWidth, trackWidth);
					
			}
		}
	
	}

