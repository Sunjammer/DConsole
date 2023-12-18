package com.furusystems.dconsole2.core.security ;
	
	import com.furusystems.dconsole2.core.input.KeyboardManager;
	
	/**
	 * Console lock Class
	 * 	Managed by the ConsoleUtil and the subclasses of a AbstractConsole
	 *
	 * @author Cristobal Dabed
	 * @version 0.1
	 */
	 final class ConsoleLock {
		// NOTE: Should the callback on the lock be available or not, open for discussion.
		
		/* Variables */
		var _locked:Bool = false;
		var _keyCodes:Array<ASAny> = [];
		var callback:ASFunction = null;
		
		// Constructor
		public function new() {
		}
		
		/**
		 * @readonly locked
		 */
		@:flash.property public var locked(get,never):Bool;
function  get_locked():Bool {
			return _locked;
		}
		
		/**
		 * @readonly keyCodes
		 */
		@:flash.property public var keyCodes(get,never):Array<ASAny>;
function  get_keyCodes():Array<ASAny> {
			return _keyCodes;
		}
		
		/**
		 * Lock
		 *
		 * @param keyCodes the keycode to use as a lock.
		 *
		 * @return
		 * 	Returns true or false depending on wether we successfully added the keyCodes as a lock or not.
		 *  Will return false if we could not unlock previous lock or the keyCode sequence is not a valid sequence
		 *  and also if it was not possible to bind the keyCodes as alock.
		 */
		public function lockWithKeycodes(keyCodes:Array<ASAny>, callback:ASFunction):Bool {
			var success= true;
			
			/*
			 * 1. If the keyboard is already locked try to unlock it first.
			 * 2. And if so update the success state to the return value of the unlock function.
			 */
			if (locked) {
				success = unlock();
			}
			
			/*
			 * 3. If we still pass validate the keyCodes
			 */
			if (success) {
				success = KeyboardManager.instance.validateKeyboardSequence(keyCodes);
			}
			
			/*
			 * 4. If we stil pass try adding the keyCodes
			 * 5. If we successfully binded the keyboardSequence update the lock state and set the callback function.
			 * 6. If we could not add the lock set success to false.
			 */
			if (success) {
				if (KeyboardManager.instance.addKeyboardSequence(keyCodes, unlock)) {
					setLocked(true);
					setkeyCodes(keyCodes);
					setCallback(callback);
				} else {
					success = false;
				}
			}
			return success;
		}
		
		/**
		 * Unlock
		 *
		 * @return
		 * 	Returns true if the lock was successfully unlocked.
		 * 	Will return false if it could not unlock or if it was not locked when calling unlock.
		 */
		public function unlock():Bool {
			var success= false;
			
			// Only remove if it has been locked.
			if (locked) {
				/*
				 * 1. If the KeyboardManager successfully removes the lock sequences then.
				 * 1.1 Execute callback
				 * 1.2 Unlock
				 * 1.3 Remove callback
				 * 1.3 Reset keycodes
				 * 1.4 Set sucess to true.
				 */
				if (KeyboardManager.instance.removeKeyboardSequence(keyCodes)) {
					setLocked(false);
					executeCallback();
					setCallback(null);
					setkeyCodes([]);
					success = true;
				}
			}
			return success;
		}
		
		/**
		 * Set Locked
		 *
		 * @param value A Boolean value wether it is locked or not.
		 */
		function setLocked(value:Bool) {
			_locked = value;
		}
		
		/**
		 * Set keycodes
		 *
		 * @param keyCodes A value indicating the lock state.
		 */
		function setkeyCodes(value:Array<ASAny>) {
			_keyCodes = value.copy(); // make sure create a shallow copy.
		}
		
		/**
		 * Set Callback
		 *
		 * @param callback A function value to callback when the unlock has been called with a lock state set.
		 */
		function setCallback(value:ASFunction) {
			callback = value;
		}
		
		/**
		 * Execute Callback
		 *  - Warns if it could not be executed.
		 */
		function executeCallback() {
			if (Std.is(callback , "function")) {
				try {
					callback();
				} catch (error:Error) {
				}
			}
		}
	
	}
