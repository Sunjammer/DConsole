package com.furusystems.dconsole2.utilities ;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	 class ThemeConfigurer extends Sprite {
		var palette:PaletteView;
		var _prevSelection:TextField;
		
		public function new(palette:PaletteView) {
			super();
			this.palette = palette;
		}

		public function populate(theme:compat.XML) {
			addNode(theme, 0, 0);
		}
		
		public function addNode(xml:compat.XML, x:Float, y:Float):Float {
			var tf= new TextField();
			tf.height = 20;
			tf.width = 100;
			tf.x = x;
			tf.y = y;
			tf.selectable = false;
			addChild(tf);
			var count= 1;
			if (ASCompat.stringAsBool(xml.name())) {
				if (xml.child("text" )!= null) {
				}
				tf.text = xml.name();
				for (node in xml.children()) {
					count += Std.int(addNode(node, x + 50, tf.y + count * 20));
				}
			} else {
				tf.text = xml.toString();
				tf.backgroundColor = palette.getColorByName(tf.text);
				tf.background = true;
				tf.textColor = 0xFFFFFF - tf.backgroundColor;
				tf.addEventListener(MouseEvent.CLICK, selectField);
			}
			return count;
		}
		
		public function updateColor(color:ColorDef) {
			var i= numChildren;while (i-- != 0) {
				var tf= Std.downcast(getChildAt(i) , TextField);
				if (tf.text.toLowerCase() == color.name.toLowerCase()) {
					tf.backgroundColor = color.color;
				}
			}
		}
		
		function selectField(e:MouseEvent) {
			if (_prevSelection != null) {
				_prevSelection.border = false;
			}
			_prevSelection = ASCompat.dynamicAs(e.currentTarget , TextField);
			_prevSelection.border = true;
			palette.selectSwatchByName(_prevSelection.text);
		}
		
		@:flash.property public var prevSelection(get,never):TextField;
function  get_prevSelection():TextField {
			return _prevSelection;
		}
	
	}

