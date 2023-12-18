package com.furusystems.dconsole2.utilities ;
	import com.furusystems.dconsole2.IConsole;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	 class ThemeEditor extends Sprite {
		var _console:IConsole;
		var _colors:compat.XML;
		var _theme:compat.XML;
		
		//TEMP
		var DEFAULT_COLOR_XML:Class<Dynamic>;
		var DEFAULT_THEME_XML:Class<Dynamic>;
		var _colorSelector:ColorSelector;
		var palette:PaletteView;
		var themeConfig:ThemeConfigurer;
		
		//
		public function new(console:IConsole) {
			super();
			_console = console;
			
			//graphics.beginFill(0, 1);
			//graphics.drawRect(0, 0, 320, 240);
			
			_colorSelector = new ColorSelector(320, 240);
			addChild(_colorSelector);
			_colorSelector.addEventListener(MouseEvent.MOUSE_DOWN, onColorPick);
			
			palette = new PaletteView(8);
			addChild(palette);
			palette.y = _colorSelector.height + 4;
			palette.x = 4;
			
			themeConfig = new ThemeConfigurer(palette);
			addChild(themeConfig).x = _colorSelector.width + 4;
			palette.setConfigurer(themeConfig);
			
			//TEMP
			populate(new compat.XML(Type.createInstance(DEFAULT_COLOR_XML, [])), new compat.XML(Type.createInstance(DEFAULT_THEME_XML, [])));
		}
		
		function onColorPick(e:MouseEvent) {
			if (palette.selectedSwatch != null) {
				palette.selectedSwatch.setColor(_colorSelector.lookUp(_colorSelector.mouseX, _colorSelector.mouseY));
			}
		}
		
		public function populate(colors:compat.XML, theme:compat.XML) {
			clear();
			_colors = colors;
			_theme = theme;
			createPalette();
			createTree();
		}
		
		function createPalette() {
			var colors= new Vector<ColorDef>();
			for (xml in _colors.child("everything")) {
				colors.push(new ColorDef(xml.name(), ASCompat.toInt(xml.toString())));
			}
			palette.setColors(colors);
		}
		
		function createTree() {
			themeConfig.populate(_theme);
		}
		
		function clear() {
			//remove all components etc
		}
		
		public function applyTheme() {
			//_console.setTheme(palette.save(), themeConfig.save());
		}
	
	}

