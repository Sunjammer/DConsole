package com.furusystems.dconsole2.core.gui ;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class AbstractButton extends Sprite {
		var _bg:Shape = new Shape();
		var _iconDisplay:Bitmap = new Bitmap();
		var _inactiveBmd:BitmapData;
		var _activeBmd:BitmapData;
		var _active:Bool = false;
		var _toggleSwitch:Bool = false;
		var _height:Float = Math.NaN;
		var _width:Float = Math.NaN;
		
		public function new(width:Float = GUIUnits.SQUARE_UNIT, height:Float = GUIUnits.SQUARE_UNIT) {
			super();
			_width = width;
			_height = height;
			addChild(_bg);
			addChild(_iconDisplay);
			active = false;
			buttonMode = true;
			mouseChildren = false;
			scrollRect = new Rectangle(0, 0, width, height);
			addEventListener(MouseEvent.MOUSE_DOWN, doClick, false, 0, true);
		}
		
		function doClick(e:MouseEvent) {
			if (_toggleSwitch) {
				active = !active;
			}
		}
		
		public function setIcon(bmd:BitmapData) {
			_iconDisplay.bitmapData = bmd;
			_iconDisplay.x = Math.ffloor(_bg.width / 2 - _iconDisplay.width / 2);
			_iconDisplay.y = Math.ffloor(_bg.height / 2 - _iconDisplay.height / 2);
		}
		
				
		@:flash.property public var active(get,set):Bool;
function  get_active():Bool {
			return _active;
		}
function  set_active(value:Bool):Bool{
			_active = value;
			_bg.graphics.clear();
			if (_active) {
				_bg.graphics.beginFill(Colors.BUTTON_ACTIVE_BG);
			} else {
				_bg.graphics.beginFill(Colors.BUTTON_INACTIVE_BG);
			}
			_bg.graphics.drawRect(0, 0, _width, _height);
return value;
		}
		
		public function updateAppearance() {
			active = active;
		}
	
	}

