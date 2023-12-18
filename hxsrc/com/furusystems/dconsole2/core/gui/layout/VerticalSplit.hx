package com.furusystems.dconsole2.core.gui.layout ;
	import flash.geom.Rectangle;
	
	/**
	 * A cell containing two cells along a vertical split
	 * @author Andreas Roenning
	 */
	 class VerticalSplit extends Cell {
		public var topCell:Cell = new Cell();
		public var botCell:Cell = new Cell();
		var _splitRatio:Float = 0.5;
		var creationTime:Float = flash.Lib.getTimer();
		
		public function new() {
			super();
			addChild(topCell);
			addChild(botCell);
		}
		
				
		@:flash.property public var splitRatio(get,set):Float;
function  get_splitRatio():Float {
			return _splitRatio;
		}
function  set_splitRatio(value:Float):Float{
			_splitRatio = value;
			var r= rect.clone();
			r.height = rect.height * _splitRatio;
			topCell.onParentUpdate(r);
			r.y = rect.y + rect.height * _splitRatio;
			r.height = rect.height * (1 - _splitRatio);
			botCell.onParentUpdate(r);
return value;
		}
		
		override function onRectangleChanged() {
			super.onRectangleChanged();
			splitRatio = _splitRatio;
		}
		
		override public function onParentUpdate(allotedRect:Rectangle) {
			_splitRatio = Math.sin((flash.Lib.getTimer() - creationTime) / 1000) * 0.5 + 0.5;
			rect = allotedRect;
		}
	
	}

