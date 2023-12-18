package com.furusystems.dconsole2.core.io ;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * FileReader.as
	 *
	 * 	mimics the java.io.FileReader class
	 *
	 * @author Cristobal Dabed
	 * @version 0.1
	 */
	 final class FileReader extends Reader {
		var _error:Error;
		
		/**
		 * Constructor
		 *
		 * @param filename The filename to load
		 */
		public function new(filename:String) {
			super();
			load(filename);
		}
		
		// == Properties
		
		/**
		 * @readonly error
		 */
		@:flash.property public var error(get,never):Error;
function  get_error():Error {
			return _error;
		}
		
		// == Methods
		
		/**
		 * Load file
		 *
		 */
		function load(filename:String) {
			/* lock */
			lock();
			
			/* Setup loader */
			var loader= new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorEvent);
			
			/* Load File */
			loader.load(new URLRequest(filename));
		}
		
		/**
		 * Set Error
		 *
		 * @param error
		 */
		function setError(value:Error) {
			_error = value;
		}
		
		// == Loader Events
		
		/**
		 * On complete
		 *
		 * @param event The flash event
		 */
		function onComplete(event:Event) {
			// event.target.data pass data to reader for processing
			setStream(event.target.data);
			unlock();
		}
		
		/**
		 * On io error
		 *
		 * @param error The IO error
		 */
		function onIOError(ioError:IOError) {
			setError(ioError);
			unlock();
		}
		
		/**
		 * On security error
		 *
		 * @param error The security error
		 */
		function onSecurityErrorEvent(securityError:SecurityErrorEvent) {
			setError(new Error(securityError.toString()));
			unlock();
		}
	}
