package com.furusystems.dconsole2.core.gui ;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.core.style.TextFormats;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class TextFieldFactory {
		public static function getLabel(label:String):TextField {
			var tf= new TextField();
			tf.defaultTextFormat = TextFormats.consoleTitleFormat;
			tf.text = label;
			tf.height = GUIUnits.SQUARE_UNIT;
			var f= tf.defaultTextFormat.font;
			if (f.charAt(0) != "_")
				tf.embedFonts = true;
			tf.mouseEnabled = true;
			tf.selectable = false;
			return tf;
		}
	
	}

