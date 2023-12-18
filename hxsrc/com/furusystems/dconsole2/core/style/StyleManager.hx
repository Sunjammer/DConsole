package com.furusystems.dconsole2.core.style ;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.style.themes.ConsoleTheme;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class StyleManager {
		//[Embed(source='themes/default.xml',mimeType='application/octet-stream')]
		var DEFAULT_THEME_XML:Class<Dynamic>;
		//[Embed(source='themes/default_colors.xml',mimeType='application/octet-stream')]
		var DEFAULT_COLOR_DESC_XML:Class<Dynamic>;

		var _colorsLoaded:Bool = false;
		var _themeLoaded:Bool = false;
		public var colors:ColorCollection = new ColorCollection();
		public var theme:ConsoleTheme;
		var _themeLoader:URLLoader;
		var _colorLoader:URLLoader;
		var _loadTally:Int = 0;
		var _loadTallyTarget:Int = 0;
		var _messaging:PimpCentral;

		public function new(console:DConsole) {
			_messaging = console.messaging;
			theme = new ConsoleTheme(this);
			_themeLoader = new URLLoader();
			_themeLoader.addEventListener(Event.COMPLETE, onThemeLoaded);
			_colorLoader = new URLLoader();
			_colorLoader.addEventListener(Event.COMPLETE, onColorsLoaded);
		}
		
		public function load(themeURI:String = null, colorsURI:String = null) {
			_loadTallyTarget = 0;
			if (colorsURI == null) {
				setColors();
			} else {
				loadColors(colorsURI);
			}
			if (themeURI == null) {
				setTheme();
			} else {
				loadTheme(themeURI);
			}
			if (_loadTallyTarget == 0)
				consolidateStyle();
		}

		public function setThemeXML(colors:compat.XML, theme:compat.XML) {
			setColors(colors);
			setTheme(theme);
			consolidateStyle();
		}

		function onColorsLoaded(e:Event) {
			setColors(new compat.XML(_colorLoader.data));
			loadTally++;
		}

		function onThemeLoaded(e:Event) {
			setTheme(new compat.XML(_themeLoader.data));
			loadTally++;
		}

		
		@:flash.property var loadTally(get,set):Int;
function  set_loadTally(n:Int):Int{
			_loadTally = n;
			if (_loadTally >= _loadTallyTarget) {
				consolidateStyle();
			}
return n;
		}
function  get_loadTally():Int {
			return _loadTally;
		}

		function loadTheme(themeURI:String) {
			_loadTallyTarget++;
			_themeLoader.load(new URLRequest(themeURI));
		}

		function loadColors(colorsURI:String) {
			_loadTallyTarget++;
			_colorLoader.load(new URLRequest(colorsURI));
		}

		function setColors(input:compat.XML = null) {
			_colorsLoaded = true;
			if (input == null) {
				input = new compat.XML(Type.createInstance(DEFAULT_COLOR_DESC_XML, []));
			} else {
				DConsole.print("Custom color scheme loaded");
			}
			colors.populate(input);
			_messaging.send(Notifications.COLOR_SCHEME_CHANGED, null, this);
		}

		function setTheme(input:compat.XML = null) {
			_themeLoaded = true;
			if (input == null) {
				input = new compat.XML(Type.createInstance(DEFAULT_THEME_XML, []));
			} else {
				DConsole.print("Custom theme loaded");
			}
			theme.populate(input);
			Alphas.update(this);
			Colors.update(this);
			TextColors.update(this);
		}

		function consolidateStyle() {
			TextFormats.refresh();
			_messaging.send(Notifications.THEME_CHANGED, null, this);
		}

		@:flash.property public var themeXML(get,never):compat.XML;
function  get_themeXML():compat.XML {
			return theme.xml;
		}

		@:flash.property public var colorXML(get,never):compat.XML;
function  get_colorXML():compat.XML {
			return colors.xml;
		}

		@:flash.property public var themeLoaded(get,never):Bool;
function  get_themeLoaded():Bool {
			return _themeLoaded;
		}

		@:flash.property public var colorsLoaded(get,never):Bool;
function  get_colorsLoaded():Bool {
			return _colorsLoaded;
		}

	}

