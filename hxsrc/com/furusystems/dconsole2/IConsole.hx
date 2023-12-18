package com.furusystems.dconsole2 ;
	import com.furusystems.dconsole2.core.gui.debugdraw.DebugDraw;
	import com.furusystems.dconsole2.core.gui.maindisplay.ConsoleView;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.events.Event;
	
	/**
	 * @author Andreas Roenning
	 */
	 interface IConsole {
		/**
		 * Get a pointer to the visual component of the console
		 * Add this to your root to get started
		 */
		@:flash.property var view(get,never):ConsoleView;
		/**
		 * Show the console
		 */
		function show():Void;
		/**
		 * Hide the console
		 */
		function hide():Void;
		/**
		 * Toggles between showing and hiding
		 */
		function toggleDisplay():Void;
		/**
		 * Execute a command statement
		 * @param	statement The statement to execute
		 * @param	echo Wether the statement should be output to the log
		 * @return The statement's return value, if any
		 */
		function executeStatement(statement:String, echo:Bool = false):ASAny;
		/**
		 * Select a new console scope
		 * @param	target
		 */
		function select(target:ASAny):Void;
		/**
		 * Set console visibility
		 */
				@:flash.property var visible(get,set):Bool;
		/**
		 * Set the default input callback. This function is called with a command statement in the case that the console doesn't understand it.
		 * Set to null to cancel this behavior out
		 */
				@:flash.property var defaultInputCallback(get,set):ASFunction;
		/**
		 * Print a message
		 * @param	str The message string
		 * @param	type The message type, one of ConsoleMessageTypes
		 * @param	tag The message tag
		 */
		function print(str:String, type:String = "Info", tag:String = ""):Void;
		/**
		 * Change the invoking keyboard shortcut
		 * @param	keystroke
		 * @param	modifier
		 */
		function changeKeyboardShortcut(keystroke:UInt, modifier:UInt):Void;
		/**
		 * Use this function to print events
		 * @example addEventListener(Event.ADDED_TO_STAGE,DConsole.onEvent);
		 * @param	e
		 */
		function onEvent(e:Event):Void;
		/**
		 * Clear the log
		 */
		function clear():Void;
		/**
		 * Create a new command
		 * @param	keyword The keyword. Must be unique.
		 * @param	func The function to map
		 * @param	category The command group: This is used to categorize commands.
		 * @param	helpText Any assisting text to display in the assistant
		 */
		function createCommand(keyword:String, func:ASFunction, category:String = "Application", helpText:String = ""):Void;
		/**
		 * Remove a command by its associated keyword
		 * @param	keyword
		 */
		function removeCommand(keyword:String):Void;
		/**
		 * Set the header text of the console. Useful for displaying app version, title etc
		 * @param	title
		 */
		function setHeaderText(title:String):Void;
		/**
		 * Set the overriding callback. This callback is called with ALL console input until cleared.
		 * @param	callback
		 */
		function setOverrideCallback(callback:ASFunction):Void;
		/**
		 * Removes the overriding callback
		 */
		function clearOverrideCallback():Void;
		
		/**
		 * Lock the output: No new messages will be drawn
		 */
		function lockOutput():Void;
		/**
		 * Unlock the output: New messages will be drawn, and the buffer and view will be synchronized.
		 */
		function unlockOutput():Void;
		
		function setTheme(colors:compat.XML, theme:compat.XML):Void;
		function getTheme():Array<ASAny>;
		
		/**
		 * Get the debugDraw utility (work in progress)
		 */
		@:flash.property var debugDraw(get,never):DebugDraw;
		
		/**
		 * Get the internal messaging central
		 */
		@:flash.property var messaging(get,never):PimpCentral;
		
		/**
		 * Get the full console log as a string
		 */
		function getLogString():String;
		
		/**
		 * Print the stack trace up until where this method was called
		 */
		function stackTrace():Void;
		
		/**
		 * Update the current scope to reflect any recent changes
		 */
		function refresh():Void;
		
		/**
		 * Retrieve the instance of a loaded plugin (if it exists)
		 * @param	type
		 * @return An IDConsolePlugin
		 */
		function getPluginInstance(type:Class<Dynamic>):IDConsolePlugin;
	}

