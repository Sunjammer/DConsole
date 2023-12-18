package com.furusystems.dconsole2.core.input
;
	import flash.events.KeyboardEvent;

	/**
	 * Maintains a list of keyboard sequences and dispatches the callback function when a sequence has been triggered.
	 *
	 * @author Cristobal Dabed
	 * @version 0.2
	 */
	 final class KeyboardSequences implements KeyboardList
	{
		// TODO: Add a more robust validator for validateKeyboardSequence

		/* Constants  */
		public static inline final KEYBOARD_SEQUENCES_MIN_LENGTH:UInt = 1; // NOTE: Should min length be 2?

		/* Variables */
		static var INSTANCE:KeyboardSequences = null;
		var keyboardSequences:Vector<KeyboardSequence> = new Vector();

		/* @group API */

		/**
		 * Instance
		 *
		 * @return
		 * 	Returns the singleton representation of this class.
		 */
		@:flash.property public static var instance(get,never):KeyboardSequences;
static function  get_instance():KeyboardSequences
		{
			if (INSTANCE == null)
			{
				INSTANCE = new KeyboardSequences();
			}
			return INSTANCE;
		}

		/**
		 * Add
		 *
		 * @param keyCodes	The list of keycodes to trigger a callback.
		 * @param callback	The callback function to call.
		 * @param override	Optional override for an existing keyboard sequence with the new function.
		 */
		public function add(keyCodes:Array<ASAny>, callback:ASFunction, override:Bool = false, replaceAll:Bool = true):Bool
		{
			var success= true;

			/*
			 *	1. Must satisfy minimum of length 1
			 *  2. Must satisfy a valid callback.
			 */
			if (!validateKeyboardSequence(keyCodes))
			{
				throw new Error("A keyboard sequence can not have less than " + KEYBOARD_SEQUENCES_MIN_LENGTH + " elements");
			}

			if (!Std.is(callback , "function"))
			{
				throw new Error("Invalid callback function");
			}
			if (replaceAll)
			{
				keyboardSequences = new Vector<KeyboardSequence>();
			}

			/*
			 * 1. If the keyCodes are not registered yet add them.
			 * 2. If the exist and set to override, remove the old one and add the new one.
			 * 3. Warn the user that the keyCodes could not be added success is set to false.
			 */
			if (!has(keyCodes))
			{
				keyboardSequences.push(new KeyboardSequence(keyCodes, callback));
			}
			else if (override)
			{
				remove(keyCodes);
				keyboardSequences.push(new KeyboardSequence(keyCodes, callback));
			}
			else
			{
				success = false;
			}
			return success;
		}

		/**
		 * Remove keyboard sequence.
		 *
		 * @param keyCodes	The keyCodes to stop listening on.
		 *
		 * @return
		 * 	Returns true or false depending on wether it successfully removed the keyCode sequence from the list or not.
		 */
		public function remove(keyCodes:Array<ASAny>):Bool
		{
			var success= false;
			if (!isEmpty())
			{
				if (has(keyCodes))
				{
					var i= 0;
					var l= keyboardSequences.length;while (i < l)
					{
						if (inKeyboardSequence(keyCodes, keyboardSequences[i]))
						{
							break;
						}
i++;
					}
					keyboardSequences.splice(i, 1);
					success = true;
				}
			}
			return success;
		}

		/**
		 * Has
		 *
		 * @param keyCodes The keyCodes to search on.
		 *
		 * @return
		 * 	Returns true or false depending on wether the given keyCode sequence is in the list or not.
		 */
		public function has(keyCodes:Array<ASAny>):Bool
		{
			var success= false;
			var i= 0, l= keyboardSequences.length;while (i < l)
			{
				if (inKeyboardSequence(keyCodes, keyboardSequences[i]))
				{
					success = true;
					break;
				}
i++;
			}
			return success;
		}

		/**
		 * Remove All
		 */
		public function removeAll()
		{
			// Reset the internal list.
			if (!isEmpty())
			{
				while (keyboardSequences.length > 0)
				{
					keyboardSequences.pop();
				}
			}
		}

		/**
		 * Is empty
		 *
		 * @return
		 * 	Returns true or false depending on wether there are any registered keyboard sequences or not.
		 */
		public function isEmpty():Bool
		{
			return (keyboardSequences.length == 0 ? true : false);
		}

		/**
		 * Validate keyboard sequence
		 *  - For the moment only validate on the length.
		 *
		 * @return
		 * 	Returns true or false wether the keyboard sequence is valid or not.
		 */
		public function validateKeyboardSequence(keyCodes:Array<ASAny>):Bool
		{
			return ((keyCodes.length : UInt) < KEYBOARD_SEQUENCES_MIN_LENGTH ? false : true);
		}

		/* @end */

		/* @group Delegates called  irectly by the KeyboardManager */
		// We could have added custom events but do not to save some resources while keyboard input should be as fast as possible.

		/**
		 * On key down.
		 *
		 * @param event The keyboard event.
		 */
		public function onKeyDown(event:KeyboardEvent):Bool
		{
			return false;
			// Nothing to do here, placeholder function only.
		}

		/**
		 * On key up.
		 *
		 * @param event 	The keyboard event.
		 */
		public function onKeyUp(event:KeyboardEvent):Bool
		{
			var success= false;
			if (!isEmpty())
			{

				var value= event.charCode;
				var modifier= false;

				/*
				 * If the charCode is 0 use the keycode instead.
				 * Since the charCode is not an unicode character or is either a modifier.
				 */
				if (value == 0)
				{
					value = event.keyCode;
				}

				switch (value)
				{
					case KeyBindings.ALT
					   | KeyBindings.SHIFT
					   | KeyBindings.CTRL:
						modifier = true;
						
				}

				// Only compare with none modifiers.
				if (!modifier)
				{
					/*
					 * Loop over the keyboard sequences.
					 *  If the value matches the current keyCode in the keystrokes for the given keyboard sequence
					 *  check if it is completed, if it is completed then set success to true and trigger the callback outside of the loop block.
					 *
					 *  If the current value did not match and or the reset flag is set, then reset the given keyboard sequence
					 *  to the default keystrokes state.
					 *
					 *  If we had a successful match break out of the loop block and execute the callback on the i-th element which matched.
					 */
					var i= 0;
					var reset :ASAny= true;
					var l= keyboardSequences.length;
					for (_tmp_ in 0...l)
					{
i = _tmp_;
						if (value == keyboardSequences[i].keystrokes.shift())
						{
							if (keyboardSequences[i].keystrokes.length == 0)
							{
								success = true;
							}
							else
							{
								reset = false;
							}

						}
						if (reset)
						{
							keyboardSequences[i].keystrokes = keyboardSequences[i].keyCodes.copy();
						}
						if (success)
						{
							break;
						}
					}
					if (success)
					{
						executeCallback(keyboardSequences[i].callback);
					}
				}
			}
			return success;
		}

		/* @end */

		/* @group Private Functions */

		/**
		 * In keyboard sequence
		 *
		 * @param keyCodes	The keyCodes to test for.
		 * @param keyboardSequence	The keyboardSequence to check on.
		 */
		function inKeyboardSequence(keyCodes:Array<ASAny>, keyboardSequence:KeyboardSequence):Bool
		{
			var success= true;
			if (keyCodes.length == keyboardSequence.keyCodes.length)
			{
				var i= 0, l= keyCodes.length;while (i < l)
				{
					if (keyCodes[i] != keyboardSequence.keyCodes[i])
					{
						success = false;
						break;
					}
i++;
				}
			}
			return success;
		}

		/**
		 * Execute callback.
		 *
		 * @param callback The callback to execute.
		 */
		function executeCallback(callback:ASFunction)
		{
			if (Std.is(callback , "function"))
			{
				try
				{
					callback();
				}
				catch (error:Error)
				{
					/* supress warning. */
				}
			}
			else
			{
				// trace("Warn: could not execute the callback, perhaps not a valid callback function...");
			}
		}
public function new(){}
		/* @end */
	}
