package com.furusystems.dconsole2.core.gui ;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class FuruLogoGraphic extends Sprite {
		var _sourceSWF:Class<Dynamic>;
		
		public function new() {
			super();
			var bytes= cast(Type.createInstance(_sourceSWF, []), ByteArray);
			var l= new Loader();
			addChild(l);
			l.scaleX = l.scaleY = .3;
			l.loadBytes(bytes);
		}
	
	}

