package com.furusystems.dconsole2.core.input ;
	import flash.ui.Keyboard;
	
	/**
	 * Maintains a list of keyboard bindings.
	 * 	Wrapper for the Keyboard class, some extra options and adds set of default keycodes for the characters a-z.
	 *
	 * References:
	 *	- http://www.signar.se/blog/as-3-charcodes/
	 *
	 * @author Cristobal Dabed
	 * @version 0.2
	 */
	 final class KeyBindings {
		/* Modifiers */
		public static inline final NONE:UInt = 0; // Special Modifier binding for when tracing keystroke characters only.
		public static inline final ALT:UInt = 18; // Keyboard.ALTERNATE
		public static final SHIFT:UInt = Keyboard.SHIFT;
		public static final CTRL:UInt = Keyboard.CONTROL;
		public static final ALT_SHIFT:UInt = 18 + Keyboard.SHIFT;
		public static final CTRL_ALT:UInt = Keyboard.CONTROL + 18;
		public static final CTRL_SHIFT:UInt = Keyboard.CONTROL + Keyboard.SHIFT;
		
		/* Keystrokes */
		// FN's
		public static final F1:UInt = Keyboard.F1;
		public static final F2:UInt = Keyboard.F2;
		public static final F3:UInt = Keyboard.F3;
		public static final F4:UInt = Keyboard.F4;
		public static final F5:UInt = Keyboard.F5;
		public static final F6:UInt = Keyboard.F6;
		public static final F7:UInt = Keyboard.F7;
		public static final F8:UInt = Keyboard.F8;
		public static final F9:UInt = Keyboard.F9;
		public static final F10:UInt = Keyboard.F10;
		public static final F11:UInt = Keyboard.F11;
		public static final F12:UInt = Keyboard.F12;
		public static final F13:UInt = Keyboard.F13;
		public static final F14:UInt = Keyboard.F14;
		public static final F15:UInt = Keyboard.F15;
		
		// OPTIONS
		public static final ENTER:UInt = Keyboard.ENTER; // can only be used as keystroke + 2 modifiers
		public static final TAB:UInt = Keyboard.TAB; // can only be used as keystroke + 2 modifiers
		public static final ESC:UInt = Keyboard.ESCAPE; // can only be used as keystroke + 1 modifier
		public static final SPACE:UInt = Keyboard.SPACE; // must have at least on valid modifier.
		
		// Arrows
		public static final UP:UInt = Keyboard.UP;
		public static final DOWN:UInt = Keyboard.DOWN;
		public static final RIGHT:UInt = Keyboard.RIGHT;
		public static final LEFT:UInt = Keyboard.LEFT;
		
		// Nums
		public static final NUM_0:UInt = Keyboard.NUMPAD_0;
		public static final NUM_1:UInt = Keyboard.NUMPAD_1;
		public static final NUM_2:UInt = Keyboard.NUMPAD_2;
		public static final NUM_3:UInt = Keyboard.NUMPAD_3;
		public static final NUM_4:UInt = Keyboard.NUMPAD_4;
		public static final NUM_5:UInt = Keyboard.NUMPAD_5;
		public static final NUM_6:UInt = Keyboard.NUMPAD_6;
		public static final NUM_7:UInt = Keyboard.NUMPAD_7;
		public static final NUM_8:UInt = Keyboard.NUMPAD_8;
		public static final NUM_9:UInt = Keyboard.NUMPAD_9;
		
		// Ops
		public static final OP_ADD:UInt = Keyboard.NUMPAD_ADD;
		public static final OP_SUB:UInt = Keyboard.NUMPAD_SUBTRACT;
		public static final OP_DIV:UInt = Keyboard.NUMPAD_DIVIDE;
		public static final OP_MUL:UInt = Keyboard.NUMPAD_MULTIPLY;
		
		// Characters lowercase
		public static final a:UInt = toCharCode("a");
		public static final b:UInt = toCharCode("b");
		public static final c:UInt = toCharCode("c");
		public static final d:UInt = toCharCode("d");
		public static final e:UInt = toCharCode("e");
		public static final f:UInt = toCharCode("f");
		public static final g:UInt = toCharCode("g");
		public static final h:UInt = toCharCode("h");
		public static final i:UInt = toCharCode("i");
		public static final j:UInt = toCharCode("j");
		public static final k:UInt = toCharCode("k");
		public static final l:UInt = toCharCode("l");
		public static final m:UInt = toCharCode("m");
		public static final n:UInt = toCharCode("n");
		public static final o:UInt = toCharCode("o");
		public static final p:UInt = toCharCode("p");
		public static final q:UInt = toCharCode("q");
		public static final r:UInt = toCharCode("r");
		public static final s:UInt = toCharCode("s");
		public static final t:UInt = toCharCode("t");
		public static final u:UInt = toCharCode("u");
		public static final v:UInt = toCharCode("v");
		public static final x:UInt = toCharCode("x");
		public static final y:UInt = toCharCode("y");
		public static final z:UInt = toCharCode("z");
		
		// Characters uppercase
		public static final A:UInt = toKeyCode("A");
		public static final B:UInt = toKeyCode("B");
		public static final C:UInt = toKeyCode("C");
		public static final D:UInt = toKeyCode("D");
		public static final E:UInt = toKeyCode("E");
		public static final F:UInt = toKeyCode("F");
		public static final G:UInt = toKeyCode("G");
		public static final H:UInt = toKeyCode("H");
		public static final I:UInt = toKeyCode("I");
		public static final J:UInt = toKeyCode("J");
		public static final K:UInt = toKeyCode("K");
		public static final L:UInt = toKeyCode("L");
		public static final M:UInt = toKeyCode("M");
		public static final N:UInt = toKeyCode("N");
		public static final O:UInt = toKeyCode("O");
		public static final P:UInt = toKeyCode("P");
		public static final Q:UInt = toKeyCode("Q");
		public static final R:UInt = toKeyCode("R");
		public static final S:UInt = toKeyCode("S");
		public static final T:UInt = toKeyCode("T");
		public static final U:UInt = toKeyCode("U");
		public static final V:UInt = toKeyCode("V");
		public static final X:UInt = toKeyCode("X");
		public static final Y:UInt = toKeyCode("Y");
		public static final Z:UInt = toKeyCode("Z");
		
		/**
		 * To key code
		 *
		 * @param char The char value to get the char code for.
		 *
		 * @return
		 * 	Returns the char code for the character passed.
		 */
		public static function toCharCode(char:String):UInt {
			return char.charCodeAt(0);
		}
		
		/**
		 * To char codes.
		 *
		 * @param value	The string values to retrieve the char codes for.
		 *
		 * @return
		 * 	Returns an array of the char codes from the passed string.
		 */
		public static function toCharCodes(value:String):Array<ASAny> {
			var keyCodes:Array<ASAny> = [];
			var i= 0, l= value.length;while (i < l) {
				keyCodes.push(value.charCodeAt(i));
i++;
			}
			return keyCodes;
		}
		
		/**
		 * To key code
		 *
		 * @param char The char value to get the char code for.
		 *
		 * @return
		 * 	Returns the char code for the character passed.
		 */
		public static function toKeyCode(char:String):UInt {
			return char.toUpperCase().charCodeAt(0);
		}
		
		/**
		 * To key codes
		 *
		 * @param value The string values to retrieve the key codes for.
		 *
		 * @return
		 * 	Returns an array of the key codes from the passed string.
		 */
		public static function toKeyCodes(value:String):Array<ASAny> {
			var keyCodes:Array<ASAny> = [];
			var i= 0, l= value.length;while (i < l) {
				keyCodes.push(toKeyCode(value.charAt(i)));
i++;
			}
			return keyCodes;
		}
	}
