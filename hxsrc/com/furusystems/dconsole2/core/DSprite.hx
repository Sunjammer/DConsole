package com.furusystems.dconsole2.core ;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class DSprite extends Sprite {
		static final tempPoint:Point = new Point();
		
		public var data:ASAny;
		
		public static inline final ALIGN_TOP:UInt = 0;
		public static inline final ALIGN_BOT:UInt = 1;
		public static inline final ALIGN_LEFT:UInt = 2;
		public static inline final ALIGN_RIGHT:UInt = 3;
		public static inline final ALIGN_TOP_RIGHT:UInt = 4;
		public static inline final ALIGN_TOP_LEFT:UInt = 5;
		public static inline final ALIGN_BOT_RIGHT:UInt = 6;
		public static inline final ALIGN_BOT_LEFT:UInt = 7;
		public static inline final ALIGN_CENTER:UInt = 8;
		
		public static inline final ADDMODE_ROW:UInt = 0;
		public static inline final ADDMODE_COLUMN:UInt = 1;
		public static inline final ADDMODE_GRID:UInt = 2;
		
		public function new() {
			super();
		
		}
		
		function nativeTrace( args:Array<ASAny> = null) {
if (args == null) args = [];
			Reflect.callMethod(this, trace, args);
		}
		
		/**
		 * Add a child directly at a certain position
		 * @param	d
		 * The DisplayObject to add
		 * @param	x
		 * X position
		 * @param	y
		 * Y position
		 * @param	centerVertically
		 * Center the object vertically by subtracting half its height from Y
		 * @param	centerHorizontally
		 * Center the object horizontally by subtracting half its width from X
		 * @return
		 * The added DisplayObject
		 */
		public function addChildAtPosition(d:DisplayObject, x:Float, y:Float, centerVertically:Bool = false, centerHorizontally:Bool = false):DisplayObject {
			d.x = x;
			if (centerHorizontally)
				d.x -= Std.int(d.width )>> 1;
			d.y = y;
			if (centerVertically)
				d.y -= Std.int(d.height )>> 1;
			return this.addChild(d);
		}
		
		/**
		 * Returns an array of first level child display objects
		 * @return an array of display objects
		 */
		public function getChildren():Array<ASAny> {
			var a:Array<ASAny> = [];
			var i= 0;while (i < numChildren) {
				a.push(getChildAt(i));
i++;
			}
			return a;
		}
		
		public function alignChildren(alignType:Int = ALIGN_TOP) {
			var c= getChildren();
			var alignValue:Float = 0;
			var rect= getRect(this);
			var i= 0;while (i < c.length) {
				var d= cast(c[i], DisplayObject);
				switch (alignType) {
					case ALIGN_BOT:
						d.y = rect.height - d.height;
						
					case ALIGN_TOP:
						d.y = 0;
						
					case ALIGN_LEFT:
						d.x = 0;
						
					case ALIGN_RIGHT:
						d.x = rect.width - d.width;
						
				}
i++;
			}
		}
		
		public function fromPoint(p:Point) {
			x = p.x;
			y = p.y;
		}
		
		public function getPoint():Point {
			return new Point(x, y);
		}
		
		public function fromRect(rect:Rectangle) {
			x = rect.x;
			y = rect.y;
			width = rect.width;
			height = rect.height;
		}
		
		/**
		 * Centers the sprite at a point
		 * @param	x
		 * X coord
		 * @param	y
		 * Y coord
		 * @param	interpolate
		 * Interpolate the move
		 */
		public function centerAt(x:Float, y:Float, interpolate:Bool = false) {
			tempPoint.x = x;
			tempPoint.y = y;
			alignWithPoint(tempPoint, ALIGN_CENTER);
		}
		
		/**
		 * Aligns the sprite to point p
		 * @param	p
		 * The point to align with
		 * @param	alignment
		 * The alignment type
		 */
		public function alignWithPoint(p:Point, alignment:UInt) {
			switch (alignment) {
				case ALIGN_BOT:
					x = p.x - width * .5;
					y = p.y - height;
					
				case ALIGN_BOT_LEFT:
					x = p.x;
					y = p.y - height;
					
				case ALIGN_BOT_RIGHT:
					x = p.x - width;
					y = p.y - height;
					
				case ALIGN_TOP:
					x = p.x - width * .5;
					y = p.y;
					
				case ALIGN_TOP_LEFT:
					x = p.x;
					y = p.y;
					
				case ALIGN_TOP_RIGHT:
					x = p.x - width;
					y = p.y;
					
				case ALIGN_LEFT:
					y = p.y - height * .5;
					x = p.x;
					
				case ALIGN_RIGHT:
					y = p.y - height * .5;
					x = p.x - width;
					
				case ALIGN_CENTER:
					y = p.y - height * .5;
					x = p.x - width * .5;
					
			}
		}
		
		/**
		 * Adds an array of display objects to the display list
		 * @param	children
		 * The array of children to add
		 * @param	addMode
		 * The way the children are added to the list, either as a row, a column or a grid (0,1,2 respectively)
		 * @param	margin
		 * The pixel margin between each column or row
		 * @param	startPos
		 * The pixel offset to start from
		 * @param	maxCol
		 * The max number of items per row
		 */
		public function addChildren(children:Array<ASAny>, addMode:Int = -1, margin:Int = 0, startPos:Point = null, maxCol:Int = 5):Array<ASAny> {
			if (startPos == null)
				startPos = new Point();
			var c1= 0;
			var c2= 0;
			var c3= 0;
			var ob:DisplayObject;
			switch (addMode) {
				case ADDMODE_COLUMN:
					for (_tmp_ in children) {
ob  = _tmp_;
						addChild(ob);
						ob.y = startPos.y + c1;
						ob.x = startPos.x;
						c1 += Std.int(ob.height + margin);
					}
					
				case ADDMODE_ROW:
					for (_tmp_ in children) {
ob  = _tmp_;
						addChild(ob);
						ob.y = startPos.y;
						ob.x = startPos.x + c1;
						c1 += Std.int(ob.width + margin);
					}
					
				case ADDMODE_GRID:
					for (_tmp_ in children) {
ob  = _tmp_;
						addChild(ob);
						ob.x = startPos.x + c1;
						ob.y = startPos.y + c2;
						c1 += Std.int(ob.width + margin);
						c3++;
						if (c3 > maxCol) {
							c2 += Std.int(ob.height + margin);
							c3 = c1 = 0;
						}
					}
					
				default:
					for (_tmp_ in children) {
ob  = _tmp_;
						addChild(ob);
					}
			}
			return children;
		}
		
		public function layoutChildren(addMode:Int = -1, margin:Int = 0, startPos:Point = null, maxCol:Int = 5) {
			var a= getChildren();
			addChildren(a, addMode, margin, startPos, maxCol);
		}
		
		@:flash.property public var xy(never,set):Float;
function  set_xy(n:Float):Float{
			x = y = n;
return n;
		}
		
		@:flash.property public var scaleXY(never,set):Float;
function  set_scaleXY(n:Float):Float{
			scaleX = scaleY = n;
return n;
		}
	
	}

