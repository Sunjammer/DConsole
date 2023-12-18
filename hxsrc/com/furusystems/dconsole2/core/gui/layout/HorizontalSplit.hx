package com.furusystems.dconsole2.core.gui.layout ;
	import flash.geom.Rectangle;
	
	/**
	 * A cell containing two cells along a horizontal split
	 * @author Andreas Roenning
	 */
	 class HorizontalSplit extends Cell {
		public var leftCell:Cell = new Cell();
		public var rightCell:Cell = new Cell();
		var _splitRatio:Float = 0.5;
		
		public function new() {
			super();
			addChild(leftCell);
			addChild(rightCell);
		}
		
				
		@:flash.property public var splitRatio(get,set):Float;
function  get_splitRatio():Float {
			return _splitRatio;
		}
function  set_splitRatio(value:Float):Float{
			_splitRatio = Math.max(0, Math.min(1, value));
			var r= rect.clone();
			
			var leftWidth= Std.int(rect.width * _splitRatio);
			var rightWidth= rect.width - leftWidth;
			var remainder= rect.width - (leftWidth + rightWidth);
			if (remainder > 0) {
				leftWidth += Std.int(remainder);
			} else if (remainder < 0) {
				rightWidth -= remainder;
			}
			
			var leftRect= new Rectangle(0, 0, leftWidth, rect.height);
			var rightRect= new Rectangle(leftWidth, 0, rightWidth, rect.height);
			
			leftCell.onParentUpdate(leftRect);
			rightCell.onParentUpdate(rightRect);
return value;
		}
		
		public function setSplitPos(splitPosition:Int):Float {
			splitPosition = Std.int(Math.max(minWidth, Math.min(splitPosition, width)));
			splitRatio = splitPosition / width;
			return splitRatio;
		}
		
		public function getSplitPos():Int {
			return Std.int(splitRatio * width);
		}
		
		override function onRectangleChanged() {
			splitRatio = _splitRatio;
		}
		
		override public function onParentUpdate(allotedRect:Rectangle) {
			rect = allotedRect;
		}
	
	}

