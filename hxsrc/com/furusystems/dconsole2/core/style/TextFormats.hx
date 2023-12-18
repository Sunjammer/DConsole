package com.furusystems.dconsole2.core.style ;
	import com.furusystems.dconsole2.core.style.fonts.Fonts;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 final class TextFormats {
		public static inline final OUTPUT_SIZE:Float = 16;
		public static inline final GUI_SIZE:Float = 16;
		public static inline final OUTPUT_LEADING:Float = 0;
		public static final OUTPUT_FONT:String = Fonts.codingFontTobi.fontName;
		//public static const OUTPUT_FONT:String = "_typewriter";
		public static final GUI_FONT:String = Fonts.codingFontTobi.fontName;
		//public static const INPUT_FONT:String = "_typewriter";
		public static final INPUT_FONT:String = Fonts.codingFontTobi.fontName;
		public static inline final INPUT_SIZE:Float = 16;
		
		public static final inputTformat:TextFormat = makeFormat(INPUT_FONT, Std.int(INPUT_SIZE), TextColors.TEXT_INPUT);
		public static final helpTformat:TextFormat = makeFormat(INPUT_FONT, Std.int(INPUT_SIZE), TextColors.TEXT_ASSISTANT);
		
		public static final outputTformatUser:TextFormat = makeFormat(OUTPUT_FONT, Std.int(OUTPUT_SIZE), TextColors.TEXT_USER);
		public static final outputTformatLineNo:TextFormat = makeFormat(OUTPUT_FONT, Std.int(OUTPUT_SIZE), TextColors.TEXT_AUX);
		public static final outputTformatOld:TextFormat = makeFormat(OUTPUT_FONT, Std.int(OUTPUT_SIZE), TextColors.TEXT_DEBUG);
		public static final outputTformatHidden:TextFormat = makeFormat(OUTPUT_FONT, Std.int(OUTPUT_SIZE), BaseColors.BLACK);
		public static final outputTformatTag:TextFormat = makeFormat(OUTPUT_FONT, Std.int(OUTPUT_SIZE), TextColors.TEXT_TAG);
		public static final outputTformatNew:TextFormat = makeFormat(OUTPUT_FONT, Std.int(OUTPUT_SIZE), TextColors.TEXT_INFO);
		public static final hoorayFormat:TextFormat = makeFormat(OUTPUT_FONT, Std.int(OUTPUT_SIZE), TextColors.TEXT_DEBUG);
		public static final outputTformatSystem:TextFormat = makeFormat(OUTPUT_FONT, Std.int(OUTPUT_SIZE), TextColors.TEXT_SYSTEM);
		public static final outputTformatTimeStamp:TextFormat = makeFormat(OUTPUT_FONT, Std.int(OUTPUT_SIZE), TextColors.TEXT_AUX);
		public static final outputTformatDebug:TextFormat = makeFormat(OUTPUT_FONT, Std.int(OUTPUT_SIZE), TextColors.TEXT_DEBUG);
		public static final outputTformatWarning:TextFormat = makeFormat(OUTPUT_FONT, Std.int(OUTPUT_SIZE), TextColors.TEXT_WARNING);
		public static final outputTformatError:TextFormat = makeFormat(OUTPUT_FONT, Std.int(OUTPUT_SIZE), TextColors.TEXT_ERROR);
		public static final outputTformatFatal:TextFormat = makeFormat(OUTPUT_FONT, Std.int(OUTPUT_SIZE), TextColors.TEXT_FATAL);
		public static final outputTformatInfo:TextFormat = makeFormat(OUTPUT_FONT, Std.int(OUTPUT_SIZE), TextColors.TEXT_INFO);
		public static final outputTformatAux:TextFormat = makeFormat(OUTPUT_FONT, Std.int(OUTPUT_SIZE), TextColors.TEXT_AUX);
		//TODO: Running out of colors here. Need to take another gander at these
		public static final consoleTitleFormat:TextFormat = makeFormat(GUI_FONT, Std.int(GUI_SIZE), BaseColors.WHITE);
		public static final windowDefaultFormat:TextFormat = makeFormat(GUI_FONT, Std.int(GUI_SIZE), BaseColors.WHITE);
		
		/**
		 * Returns a textformat copy with inverted color
		 * @param	tformat
		 * @return
		 */
		public static function getInverse(tformat:TextFormat):TextFormat {
			var newFormat= new TextFormat(tformat.font, tformat.size, tformat.color, tformat.bold, tformat.italic, tformat.underline, tformat.url, tformat.target, tformat.align, tformat.leftMargin, tformat.rightMargin, tformat.indent, tformat.leading);
			newFormat.color = BaseColors.WHITE - ASCompat.toInt(tformat.color);
			return newFormat;
		}
		
		static function makeFormat(font:String, size:Int, color:UInt):TextFormat {
			return new TextFormat(font, size, color, null, null, null, null, null, null, 0, 0, 0, 0);
		}
		
		public static function refresh() {
			inputTformat.color = TextColors.TEXT_INPUT;
			helpTformat.color = TextColors.TEXT_ASSISTANT;
			outputTformatUser.color = TextColors.TEXT_USER;
			outputTformatLineNo.color = TextColors.TEXT_AUX;
			outputTformatOld.color = TextColors.TEXT_DEBUG;
			outputTformatHidden.color = BaseColors.BLACK;
			outputTformatTag.color = TextColors.TEXT_TAG;
			outputTformatNew.color = TextColors.TEXT_INFO;
			hoorayFormat.color = TextColors.TEXT_DEBUG;
			outputTformatSystem.color = TextColors.TEXT_SYSTEM;
			outputTformatInfo.color = TextColors.TEXT_INFO;
			outputTformatAux.color = TextColors.TEXT_AUX;
			
			outputTformatTimeStamp.color = TextColors.TEXT_AUX;
			outputTformatDebug.color = TextColors.TEXT_DEBUG;
			outputTformatWarning.color = TextColors.TEXT_WARNING;
			outputTformatError.color = TextColors.TEXT_ERROR;
			outputTformatFatal.color = TextColors.TEXT_FATAL;
			consoleTitleFormat.color = BaseColors.WHITE;
			windowDefaultFormat.color = BaseColors.BLACK;
		
			//trace("Text color: " + outputTformatTag.color.toString(16));
		}
	
	}

