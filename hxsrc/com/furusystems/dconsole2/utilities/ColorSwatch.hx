package com.furusystems.dconsole2.utilities ;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	 class ColorSwatch extends Sprite {
		public var color:ColorDef;
		public static inline final RADIUS= 10;
		var bg:Shape;
		var c:Shape;
		var _selected:Bool = false;
		
		public function new(colorDef:ColorDef) {
			super();
			buttonMode = true;
			bg = new Shape();
			c = new Shape();
			addChild(bg);
			selected = false;
			addChild(c);
			this.color = colorDef;
			setColor(color.color);
		}
		
				
		@:flash.property public var selected(get,set):Bool;
function  set_selected(b:Bool):Bool{
			_selected = b;
			bg.graphics.clear();
			bg.graphics.beginFill(_selected ? 0xFFFFFF : 0);
			bg.graphics.drawCircle(RADIUS, RADIUS, RADIUS);
return b;
		}
function  get_selected():Bool {
			return _selected;
		}
		
		public function setColor(color:UInt) {
			this.color.color = color;
			c.graphics.clear();
			c.graphics.beginFill(color);
			c.graphics.drawCircle(RADIUS, RADIUS, RADIUS - 2);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function setName(name:String) {
			this.color.name = name;
		}
	
	}

