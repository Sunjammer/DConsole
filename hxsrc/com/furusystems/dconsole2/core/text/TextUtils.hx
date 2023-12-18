package com.furusystems.dconsole2.core.text ;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class TextUtils {
		public function new() {
		
		}
		
		public static function getNextSpaceAfterCaret(tf:TextField):Int {
			var str= tf.text;
			var first= str.lastIndexOf(" ", tf.caretIndex) + 1;
			var last= str.indexOf(" ", first);
			if (last < 0)
				last = tf.text.length;
			return last;
		}
		
		public static function selectWordAtCaretIndex(tf:TextField) {
			var str= tf.text;
			var first= str.lastIndexOf(" ", tf.caretIndex) + 1;
			var last= str.indexOf(" ", first);
			if (last == -1)
				last = str.length;
			tf.setSelection(first, last);
		}
		
		public static function getWordAtCaretIndex(tf:TextField):String {
			return getWordAtIndex(tf, tf.caretIndex);
		}
		
		public static function getWordAtIndex(tf:TextField, index:Int):String {
			if (tf.text.charAt(tf.caretIndex) == " ") {
				index--; //We want the word behind the current space, not the next one
			}
			var str= tf.text;
			var li= str.lastIndexOf(" ", index);
			var first= li + 1;
			var last= str.indexOf(" ", first);
			if (last == -1) {
				last = str.length;
			}
			return str.substring(first, last);
		}
		
		public static function getFirstIndexOfWordAtCaretIndex(tf:TextField):Int {
			var wordAtIndex= getWordAtCaretIndex(tf);
			var str= tf.text;
			return str.lastIndexOf(wordAtIndex, tf.caretIndex);
		}
		
		public static function getLastIndexOfWordAtCaretIndex(tf:TextField):Int {
			var wordAtIndex= getWordAtCaretIndex(tf);
			var str= tf.text;
			return str.indexOf(wordAtIndex, tf.caretIndex) + wordAtIndex.length;
		}
		
		public static function getCaretDepthOfWord(tf:TextField):Int {
			//var word:String = getWordAtCaretIndex(tf);
			var wordIndex= getFirstIndexOfWordAtCaretIndex(tf);
			return tf.caretIndex - wordIndex;
		}
		
		public static function stripWhitespace(str:String):String {
			while (str.charAt(str.length - 1) == " ") {
				str = str.substr(0, str.length - 1);
			}
			return str;
		}
		
		public static function parseForSecondElement(str:String):String {
			var split:Array<ASAny> = (cast str.split(" "));
			if (split.length > 1) {
				return split[1];
			}
			return "";
		}
		
		/**
		 * Trim
		 *	- http://blog.stevenlevithan.com/archives/faster-trim-javascript
		 *
		 * @param str 	The string to trim.
		 *
		 * @return
		 * 	Returns the trimmed str value with whitespace removed at the start and end of the string.
		 */
		public static function trim(str:String):String {
			str = new compat.RegExp("^\\s\\s*").replace(str, '');
			var ws= new compat.RegExp("\\s"), i= str.length;
			while (ws.test(str.charAt(--i))) {
			}
			;
			return str.substring(0, i + 1);
		}
	
	}

