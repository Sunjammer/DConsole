package com.furusystems.dconsole2.utilities ;
	import com.boostworthy.geom.ColorBar;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	 class ColorSelector extends Sprite {
		var colorBarBmp:BitmapData;
		
		public function new(width:Float, height:Float) {
			super();
			colorBarBmp = new BitmapData(Std.int(width), Std.int(height), false, 0);
			colorBarBmp.draw(new ColorBar(width, height));
			addChild(new Bitmap(colorBarBmp));
		}
		
		public function lookUp(x:Float, y:Float):UInt {
			return colorBarBmp.getPixel(Std.int(Math.max(0, Math.min(width, x))), Std.int(Math.max(0, Math.min(height, y))));
		}
	
	}

