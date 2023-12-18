package com.furusystems.dconsole2.core.input ;
	
	/**
	 * Keyboardshortcut
	 * POAO class for a keyboard shortcut used and manipulated by the KeyboardShortcutsManager class only.
	 *
	 * @author Cristobal Dabed
	 * @version 0.1
	 */
	 final class KeyboardShortcut {
		public var keystroke:UInt = 0;
		public var modifier:UInt = 0;
		public var callback:ASFunction;
		public var released:Bool = true;
		
		public function new(keystroke:UInt, modifier:UInt, callback:ASFunction) {
			this.keystroke = keystroke;
			this.modifier = modifier;
			this.callback = callback;
		}
	}
