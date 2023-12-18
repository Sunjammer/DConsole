package com.furusystems.dconsole2.core.io ;
	import flash.errors.IOError;
	
	/**
	 * Class Reader
	 * 	Mimics the java.io.Reader
	 *
	 * @author Cristobal Dabed
	 * @version 0.2
	 */
	 class Reader implements ICloseable implements  IReadable {
		// TODO: Test performance on wether to have stream as Vector.<int> instead of an String only
		
		// NOTE: The mark & markSupported methods are not added since we only work with String stream @see http://download.oracle.com/javase/6/docs/api/java/io/StringReader.html#mark(int)
		//       We don't actually work with a File this would be the case when using Air or neeeded to add other similar InputStream classes
		
		var _stream:String;
		var _position:Int = -1;
		var _locked:Bool = false;
		var _ready:Bool = false;
		
		public function new() {
			// Abstract Class
		
		}
		
		/**
		 * Get the current position in the stream
		 *
		 * @return
		 * 	The current position, position is zero-indexed
		 */
		public function position():Int {
			return _position;
		}
		
		/**
		 * Set position
		 *
		 * @param value
		 */
		function setPosition(value:Int) {
			_position = value;
		}
		
		/**
		 * Close the stream
		 */
		public function close() {
			_stream = null;
			setPosition(-1);
			setReady(false);
		}
		
		/**
		 * Reads a single character.
		 *
		 * @return
		 * 	The character read, as an integer in the range 0 to 65535 (0x00-0xffff), or -1 if the end of the stream has been reached
		 */
		public function read():Int {
			enforceStream();
			
			// We work directly on _stream + _position params to max speed
			// avoiding function calls here
			var char= -1;
			if (_position < _stream.length) {
				char = _stream.charCodeAt(_position);
				_position++;
			}
			return char;
		}
		
		/**
		 * Get the reader stream
		 *
		 * @return
		 * 	Returns a copy of the current reader stream
		 */
		public function stream():String {
			return _stream;
		}
		
		/**
		 * Set stream
		 *
		 * @param value
		 */
		function setStream(value:String) {
			/*
			   if(!value){
			   throw new IOError("Reader :: invalid stream");
			   }
			 */
			_stream = value;
			setPosition(0);
			setReady(true);
		}
		
		/**
		 * Throws an error if no stream is available in the Reader
		 */
		function enforceStream() {
			if (!ASCompat.stringAsBool(_stream)) {
				throw new IOError("Reader :: No Stream");
			}
		}
		
		/**
		 * Tells wether this stream is ready to be read.
		 */
		public function ready():Bool {
			return _ready;
		}
		
		/**
		 * Set ready
		 *
		 * @param value
		 */
		function setReady(value:Bool) {
			_ready = value;
		}
		
		/**
		 * Tells wether this stream is locked or not
		 */
		public function locked():Bool {
			return _locked;
		}
		
		/**
		 * Lock the stream
		 */
		function lock() {
			_locked = true;
		}
		
		/**
		 * Unlock the stream
		 */
		function unlock() {
			_locked = false;
		}
		
		/**
		 * Resets the stream. If the stream has been marked, then attempt to reposition it at the mark. If the stream has not been marked,
		 * then attempt to reset it in some way appropriate to the particular stream, for example by repositioning it to its starting point.
		 */
		public function reset() {
			enforceStream();
			
			setPosition(0);
			setReady(false);
		}
		
		/**
		 * Skips the specified number of characters in the stream.
		 *
		 * @param n	The number of characters to skip
		 * @return
		 * 		The number of characters actually skipped
		 */
		public function skip(n:Float):Float {
			enforceStream();
			
			/* Skip value can not be negative */
			if (n < 0) {
				throw new ArgumentError("skip value is negative");
			}
			
			/*
			   As long as the current position + skip value is less than the length of the stream
			   n remains the same
			
			   Otherwise `n = stream.length() - position - 1`
			 */
			if ((_position + n) < _stream.length) {
				_position += Std.int(n);
			} else {
				n = _stream.length - _position - 1;
				_position = _stream.length - 1; // set the position to the end
			}
			return n;
		}
	
	}
