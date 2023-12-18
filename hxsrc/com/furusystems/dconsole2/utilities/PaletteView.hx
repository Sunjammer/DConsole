package com.furusystems.dconsole2.utilities ;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	 class PaletteView extends Sprite {
		
		var _selectedSwatch:ColorSwatch = null;
		var rowLength:Int = 0;
		var nameField:TextField = new TextField();
		var swatchContainer:Sprite = new Sprite();
		var configurer:ThemeConfigurer;
		
		public function new(rowLength:Int = 8) {
			super();
			this.rowLength = rowLength;
			addChild(swatchContainer);
			addChild(nameField);
			nameField.height = 22;
			nameField.width = 120;
			nameField.background = true;
			nameField.border = true;
			nameField.text = "Bahh";
			nameField.addEventListener(Event.CHANGE, onTextchange);
		}
		
		public function setConfigurer(p:ThemeConfigurer) {
			this.configurer = p;
		}
		
		function onTextchange(e:Event) {
			if (_selectedSwatch != null) {
				_selectedSwatch.color.name = nameField.text;
			}
		}
		
		public function setColors(colors:Vector<ColorDef>) {
			clear();
			for (c in colors) {
				var swatch= new ColorSwatch(c);
				swatchContainer.addChild(swatch);
				swatch.addEventListener(MouseEvent.MOUSE_DOWN, onSwatchClicked);
				swatch.addEventListener(Event.CHANGE, onSwatchChange);
			}
			layout();
		}
		
		function onSwatchClicked(e:MouseEvent) {
			setSelectedSwatch(ASCompat.dynamicAs(e.currentTarget , ColorSwatch));
		
		}
		
		function setSelectedSwatch(swatch:ColorSwatch) {
			if (_selectedSwatch != null) {
				_selectedSwatch.selected = false;
			}
			_selectedSwatch = swatch;
			nameField.text = _selectedSwatch.color.name;
			_selectedSwatch.selected = true;
			if (configurer.prevSelection != null) {
				configurer.prevSelection.text = nameField.text;
				configurer.prevSelection.backgroundColor = getColorByName(nameField.text);
			}
		}
		
		function clear() {
			while (swatchContainer.numChildren > 0) {
				swatchContainer.removeChildAt(0).removeEventListener(MouseEvent.MOUSE_DOWN, onSwatchClicked);
			}
		}
		
		public function addSwatch(color:ColorDef) {
			var swatch= new ColorSwatch(color);
			swatchContainer.addChild(swatch);
			swatch.addEventListener(MouseEvent.MOUSE_DOWN, onSwatchClicked);
			swatch.addEventListener(Event.CHANGE, onSwatchChange);
			layout();
		}
		
		function onSwatchChange(e:Event) {
			var swatch= ASCompat.dynamicAs(e.currentTarget , ColorSwatch);
			configurer.updateColor(swatch.color);
		}
		
		public function removeSwatch(swatch:ColorSwatch) {
			swatchContainer.removeChild(swatch);
			swatch.removeEventListener(MouseEvent.MOUSE_DOWN, onSwatchClicked);
			swatch.removeEventListener(Event.CHANGE, onSwatchChange);
			layout();
		}
		
		function layout() {
			var x= 0;
			var y= 0;
			var i= 0;while (i < swatchContainer.numChildren) {
				swatchContainer.getChildAt(i).x = x * ((ColorSwatch.RADIUS << 1) + 2);
				swatchContainer.getChildAt(i).y = y * ((ColorSwatch.RADIUS << 1) + 2);
				x++;
				if (x > rowLength) {
					x = 0;
					y++;
				}
i++;
			}
			nameField.y = swatchContainer.height + 2;
		}
		
		@:flash.property public var selectedSwatch(get,never):ColorSwatch;
function  get_selectedSwatch():ColorSwatch {
			return _selectedSwatch;
		}
		
		public function getColorByName(name:String):UInt {
			var i= swatchContainer.numChildren;while (i-- != 0) {
				var swatch= Std.downcast(swatchContainer.getChildAt(i) , ColorSwatch);
				if (swatch.color.name.toLowerCase() == name.toLowerCase()) {
					return swatch.color.color;
				}
			}
			return 0;
		}
		
		public function selectSwatchByName(name:String) {
			var i= swatchContainer.numChildren;while (i-- != 0) {
				var swatch= Std.downcast(swatchContainer.getChildAt(i) , ColorSwatch);
				if (swatch.color.name.toLowerCase() == name.toLowerCase()) {
					setSelectedSwatch(swatch);
					return;
				}
			}
		}
	
	}


