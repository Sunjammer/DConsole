package com.furusystems.dconsole2.core.bitmap ;
	import flash.display.BitmapData;
	import flash.geom.Point;
import flash.geom.Point;
	
	/**
	 * An implementation of bresenham's algorithm used with some drawing calls
	 * @author Andreas Roenning
	 */
	
	 final class Bresenham {
		static final _XY:BresenhamSharedData = new BresenhamSharedData();
		
		public static function line_pixel(p1:Point, p2:Point, target:BitmapData, color:UInt = 0) {
			_XY.update(p1, p2);
			var y= _XY.y0;
			target.lock();
			target.setPixel(Std.int(p1.x), Std.int(p1.y), color);
			var x= _XY.x0;while (x < _XY.x1) {
				if (_XY.steep) {
					target.setPixel(y, x, color);
				} else {
					target.setPixel(x, y, color);
				}
				_XY.error = _XY.error - _XY.deltay;
				if (_XY.error < 0) {
					y += _XY.ystep;
					_XY.error += _XY.deltax;
				}
x++;
			}
			target.setPixel(Std.int(p2.x), Std.int(p2.y), color);
			target.unlock();
		}
		
		public static function line_pixel32(p1:Point, p2:Point, target:BitmapData, color:UInt = 0xFF000000) {
			_XY.update(p1, p2);
			var y= _XY.y0;
			target.lock();
			target.setPixel32(Std.int(p1.x), Std.int(p1.y), color);
			var x= _XY.x0;while (x < _XY.x1) {
				if (_XY.steep) {
					target.setPixel32(y, x, color);
				} else {
					target.setPixel32(x, y, color);
				}
				_XY.error = _XY.error - _XY.deltay;
				if (_XY.error < 0) {
					y += _XY.ystep;
					_XY.error += _XY.deltax;
				}
x++;
			}
			target.setPixel32(Std.int(p2.x), Std.int(p2.y), color);
			target.unlock();
		}
		
		public static function line_stamp(p1:Point, p2:Point, target:BitmapData, stampSource:BitmapData, centerStamp:Bool = true) {
			if (centerStamp) {
				var offsetX= 0;
				var offsetY= 0;
				offsetX = Std.int(stampSource.width * .5);
				offsetY = Std.int(stampSource.height * .5);
				p1.offset(-offsetX, -offsetY);
				p2.offset(-offsetX, -offsetY);
			}
			_XY.update(p1, p2);
			var y= _XY.y0;
			var targetPoint= new Point();
			var targetPointInv= new Point();
			target.lock();
			target.copyPixels(stampSource, stampSource.rect, p1, null, null, true);
			var x= _XY.x0;while (x < _XY.x1) {
				targetPoint.x = x;
				targetPoint.y = y;
				targetPointInv.x = y;
				targetPointInv.y = x;
				if (_XY.steep) {
					target.copyPixels(stampSource, stampSource.rect, targetPointInv, null, null, true);
				} else {
					target.copyPixels(stampSource, stampSource.rect, targetPoint, null, null, true);
				}
				_XY.error = _XY.error - _XY.deltay;
				if (_XY.error < 0) {
					y += _XY.ystep;
					_XY.error += _XY.deltax;
				}
x++;
			}
			target.copyPixels(stampSource, stampSource.rect, p2, null, null, true);
			target.unlock();
		}
		
		public static function circle(p:Point, radius:Int, target:BitmapData, color:UInt = 0) {
			var f= 1 - radius;
			var ddF_x= 1;
			var ddF_y= -2 * radius;
			var x= 0;
			var y= radius;
			var x0= Std.int(p.x);
			var y0= Std.int(p.y);
			
			target.lock();
			target.setPixel(x0, y0 + radius, color);
			target.setPixel(x0, y0 - radius, color);
			target.setPixel(x0 + radius, y0, color);
			target.setPixel(x0 - radius, y0, color);
			
			while (x < y) {
				if (f >= 0) {
					y--;
					ddF_y += 2;
					f += ddF_y;
				}
				x++;
				ddF_x += 2;
				f += ddF_x;
				target.setPixel(x0 + x, y0 + y, color);
				target.setPixel(x0 - x, y0 + y, color);
				target.setPixel(x0 + x, y0 - y, color);
				target.setPixel(x0 - x, y0 - y, color);
				target.setPixel(x0 + y, y0 + x, color);
				target.setPixel(x0 - y, y0 + x, color);
				target.setPixel(x0 + y, y0 - x, color);
				target.setPixel(x0 - y, y0 - x, color);
			}
			target.unlock();
		}
		
		public static function circle32(p:Point, radius:Int, target:BitmapData, color:UInt = 0xFF000000) {
			var f= 1 - radius;
			var ddF_x= 1;
			var ddF_y= -2 * radius;
			var x= 0;
			var y= radius;
			var x0= Std.int(p.x);
			var y0= Std.int(p.y);
			
			target.lock();
			target.setPixel32(x0, y0 + radius, color);
			target.setPixel32(x0, y0 - radius, color);
			target.setPixel32(x0 + radius, y0, color);
			target.setPixel32(x0 - radius, y0, color);
			
			while (x < y) {
				if (f >= 0) {
					y--;
					ddF_y += 2;
					f += ddF_y;
				}
				x++;
				ddF_x += 2;
				f += ddF_x;
				target.setPixel32(x0 + x, y0 + y, color);
				target.setPixel32(x0 - x, y0 + y, color);
				target.setPixel32(x0 + x, y0 - y, color);
				target.setPixel32(x0 - x, y0 - y, color);
				target.setPixel32(x0 + y, y0 + x, color);
				target.setPixel32(x0 - y, y0 + x, color);
				target.setPixel32(x0 + y, y0 - x, color);
				target.setPixel32(x0 - y, y0 - x, color);
			}
			target.unlock();
		}
	}


/*internal*/ final private class BresenhamSharedData {
	public var x0:Int = 0;
	public var x1:Int = 0;
	public var y0:Int = 0;
	public var y1:Int = 0;
	public var deltax:Int = 0;
	public var deltay:Int = 0;
	public var error:Int = 0;
	public var ystep:Int = 0;
	public var steep:Bool = false;
	var t1:Int = 0;
	public var t2:Int = 0;
	public var temp:Int = 0;
	
	public function update(p1:Point, p2:Point) {
		t1 = Std.int(p1.y - p2.y);
		t2 = Std.int(p1.x - p2.x);
		steep = ((t1 ^ (t1 >> 31)) - (t1 >> 31)) > ((t2 ^ (t2 >> 31)) - (t2 >> 31));
		x0 = Std.int(p2.x);
		x1 = Std.int(p1.x);
		y0 = Std.int(p2.y);
		y1 = Std.int(p1.y);
		
		if (steep) {
			x0 ^= y0;
			y0 ^= x0;
			x0 ^= y0;
			
			x1 ^= y1;
			y1 ^= x1;
			x1 ^= y1;
		}
		if (x0 > x1) {
			x0 ^= x1;
			x1 ^= x0;
			x0 ^= x1;
			
			y0 ^= y1;
			y1 ^= y0;
			y0 ^= y1;
		}
		deltax = x1 - x0;
		temp = y1 - y0;
		deltay = (temp ^ (temp >> 31)) - (temp >> 31);
		error = Std.int(deltax * .5);
		(y0 < y1) ? (ystep = 1) : (ystep = -1);
	}
public function new(){}
}
