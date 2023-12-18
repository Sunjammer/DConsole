package com.furusystems.dconsole2.core.io ;
	
	/**
	 * BufferedReader.as
	 *
	 * 	mimics the java.io.BufferedReader class
	 *
	 * @author Cristobal Dabed
	 * @version 0.1
	 */
	 final class BufferedReader extends Reader {
		static inline final EOF= -1;
		static final LF:Int = "\n".charCodeAt(0); // Should be dec: 10
		static final CR:Int = "\r".charCodeAt(0); // Should be dec: 13
		
		var _reader:Reader;
		
		/**
		 * Creates a buffering character-input stream that uses a default-sized input buffer.
		 *
		 * @param reader A Reader
		 */
		public function new(reader:Reader) {
			super();
			_reader = reader;
		}
		
		/**
		 * Reads a line of text.
		 * A line is considered to be terminated by any one of a line feed ('\n'), a carriage return ('\r'), or a carriage return followed immediately by a linefeed.
		 *
		 * @return
		 * 	A String containing the contents of the line, not including any line-termination characters, or null if the end of the stream has been reached
		 */
		public function readLine():String {
			var characters:Array<ASAny> = [];
			var char:Int;
			var line:String = null;
			
			// TODO: Handle CR+LF
			while ((char = _reader.read()) != EOF) {
				if ((char == LF) || (char == CR)) {
					break;
				}
				characters.push(char);
			}
			
			if (characters.length > 0) {
				line = Reflect.callMethod(String.fromCharCode, String.fromCharCode, characters);
			} else if (!ASCompat.stringAsBool(line) && (char != EOF)) {
				line = "";
			}
			return line;
		}
		
		/**
		 * @override
		 *
		 * Skips the specified number of characters in the stream.
		 *
		 * @param n	The number of characters to skip
		 * @return
		 * 		The number of characters actually skipped
		 */
		override public function skip(n:Float):Float {
			return _reader.skip(n);
		}
		
		/**
		 * @override
		 *
		 * Tells wether this reader is ready or not
		 *
		 * @return
		 * 	True or false or depending on wether the reader input is ready.
		 */
		override public function ready():Bool {
			return _reader.ready();
		}
		
		/**
		 * @override
		 *
		 * Get the reader stream
		 *
		 * @return
		 * 	Returns a copy of the curren reader stream
		 */
		override public function stream():String {
			return _reader.stream();
		}
	}
