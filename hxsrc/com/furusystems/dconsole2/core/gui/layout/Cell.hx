package com.furusystems.dconsole2.core.gui.layout ;
	import com.furusystems.dconsole2.core.DSprite;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 * Layout cell, describing a rectangle that may contain cells of its own
	 * @author Andreas Roenning
	 */
	 class Cell extends DSprite implements ILayoutContainer {
		var _rect:Rectangle;
		var _children:Array<ASAny> = [];
		public static inline final ROUND_VALUES= false;
		
		public function new() {
			super();
			_rect = new Rectangle();
		}
		
		/* INTERFACE layout.ILayoutContainer */
		
				
		@:flash.property public var rect(get,set):Rectangle;
function  set_rect(r:Rectangle):Rectangle{
			if (ROUND_VALUES) {
				r.x = Std.int(r.x);
				r.y = Std.int(r.y);
				r.width = Std.int(r.width);
				r.height = Std.int(r.height);
			}
			//x = r.x;
			y = r.y;
			_rect = r;
			onRectangleChanged();
return r;
		}
function  get_rect():Rectangle {
			return _rect;
		}
		
		function onRectangleChanged() {
		
		}
		
		/* INTERFACE layout.ILayoutContainer */
		
		@:flash.property public var children(get,never):Array<ASAny>;
function  get_children():Array<ASAny> {
			return _children;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject {
			_children.push(child);
			return super.addChild(child);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject {
			var idx= _children.indexOf(child);
			if (idx > -1) {
				_children.splice(idx, 1);
			}
			return super.removeChild(child);
		}
		
		public function onParentUpdate(allotedRect:Rectangle) {
			rect = allotedRect;
			for (_tmp_ in children) {
var i:IContainable  = _tmp_;
				i.onParentUpdate(rect);
			}
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

