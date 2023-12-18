package com.furusystems.dconsole2.core.gui ;
	import com.furusystems.dconsole2.core.interfaces.IThemeable;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.StyleManager;
	import com.furusystems.messaging.pimp.MessageData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class SimpleScrollbarNorm extends Sprite implements IThemeable {
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
		var _thumbColor:UInt = Colors.SCROLLBAR_FG;
		public var jumpToClick:Bool = true;
		var _bgColor:UInt = 0;
		
		public function new(orientation:Int) {
			super();
			this.orientation = orientation;
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
			//messaging.addCallback(Notifications.THEME_CHANGED, onThemeChange);
		}
		
		function startDragging(e:MouseEvent) {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, doScroll);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
			if (jumpToClick) {
				thumbPos = mouseY;
			}
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
		
		public function draw(length:Float, currentScroll:Float, maxScroll:Float) {
			this.length = length;
			graphics.clear();
			graphics.beginFill(Colors.SCROLLBAR_BG);
			currentScroll = Math.min(maxScroll, currentScroll);
			
			//TODO: Dynamic thumb height
			switch (orientation) {
				case VERTICAL:
					//thumbWidth = Math.max(minThumbWidth, currentScroll / maxScroll * length);
					thumbWidth = minThumbWidth;
					thumbPos = (currentScroll / maxScroll) * (length - thumbWidth);
					graphics.drawRect(0, 0, trackWidth, length);
					graphics.beginFill(Colors.SCROLLBAR_FG);
					graphics.drawRect(0, thumbPos, trackWidth, thumbWidth);
					
					
				case HORIZONTAL:
					//thumbWidth = Math.max(minThumbWidth, currentScroll / maxScroll * length);
					thumbWidth = minThumbWidth;
					thumbPos = (currentScroll / maxScroll) * length;
					graphics.drawRect(0, 0, length, trackWidth);
					graphics.beginFill(Colors.SCROLLBAR_FG);
					graphics.drawRect(thumbPos, 0, thumbWidth, trackWidth);
					
			}
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.interfaces.IThemeable */
		
		public function onThemeChange(md:MessageData) {
			var sm= cast(md.source, StyleManager);
		}
	
	}

