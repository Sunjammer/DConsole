package com.furusystems.dconsole2.core ;
	import com.furusystems.messaging.pimp.Message;
	
	/**
	 * Enumeration of all constant notifications used throughout, and made available to the plugin API through PimpCentral
	 * @author Andreas Roenning
	 */
	 final class Notifications {
		static public final CONSOLE_VIEW_TRANSITION_COMPLETE:Message = new Message();
		
		static public final ESCAPE_KEY:Message = new Message();
		
		static public final HIDE_DOCKING_GUIDE:Message = new Message();
		static public final SHOW_DOCKING_GUIDE:Message = new Message();
		
		static public final TOOLBAR_DRAG_START:Message = new Message();
		static public final TOOLBAR_DRAG_STOP:Message = new Message();
		static public final TOOLBAR_DRAG_UPDATE:Message = new Message();
		
		static public final CORNER_DRAG_START:Message = new Message();
		static public final CORNER_DRAG_STOP:Message = new Message();
		static public final CORNER_DRAG_UPDATE:Message = new Message();
		
		static public final CURRENT_LOG_CHANGED:Message = new Message();
		static public final LOG_BUTTON_CLICKED:Message = new Message();
		static public final NEW_LOG_CREATED:Message = new Message();
		static public final LOG_DESTROYED:Message = new Message();
		static public final INSPECTOR_MODE_CHANGE:Message = new Message();
		static public final INSPECTOR_VIEW_ADDED:Message = new Message();
		static public final INSPECTOR_VIEW_REMOVED:Message = new Message();
		
		public static final THEME_CHANGED:Message = new Message();
		public static final COLOR_SCHEME_CHANGED:Message = new Message();
		/**
		 * Sent when the console visibility is toggled on
		 */
		public static final CONSOLE_SHOW:Message = new Message();
		/**
		 * Sent when the console visibility is toggled off
		 */
		public static final CONSOLE_HIDE:Message = new Message();
		/**
		 * Sent when the current scope has successfully changed, payload holds new scope object
		 */
		public static final SCOPE_CHANGE_COMPLETE:Message = new Message();
		/**
		 * Sent when the user requests a change of scope, payload holds requested scope target
		 */
		public static final SCOPE_CHANGE_REQUEST:Message = new Message();
		/**
		 * Sent when a new scope object has been created, payload holds new scope object
		 */
		
		public static final CONSOLE_INPUT_LINE_CHANGE_REQUEST:Message = new Message();
		
		public static final REQUEST_PROPERTY_CHANGE_ON_SCOPE:Message = new Message();
		public static final PROPERTY_CHANGE_ON_SCOPE:Message = new Message();
		
		public static final TOOLTIP_SHOW_REQUEST:Message = new Message();
		public static final TOOLTIP_HIDE_REQUEST:Message = new Message();
		
		public static final SCOPE_CHANGE_REQUEST_FROM_PROPERTY:Message = new Message();
		public static final SCOPE_CHANGE_REQUEST_FROM_CHILD_NAME:Message = new Message();
		
		public static final SCOPE_CREATED:Message = new Message();
		/**
		 * Sent when the user has entered a statement and executed it, payload holds full text statement
		 */
		public static final EXECUTE_STATEMENT:Message = new Message();
		//logging
		public static final LOG_CHANGED:Message = new Message();
		//frameupdates
		//TODO: A proper frame update manager may be in order here
		public static final FRAME_UPDATE:Message = new Message();
		/**
		 * Sent when the console outputs a new message. Payload holds the message object
		 */
		public static final NEW_CONSOLE_OUTPUT:Message = new Message();
		//Assistant
		public static final ASSISTANT_MESSAGE_REQUEST:Message = new Message();
		public static final ASSISTANT_CLEAR_REQUEST:Message = new Message();
		//exceptions
		/**
		 * Sent when the console outputs a new error message. Payload holds the message object
		 */
		public static final ERROR:Message = new Message();
		
		/**
		 * Sent by plugins to add and remove topics. The message data should be a HelpTopic instance
		 */
		public static final HELP_TOPIC_ADD_REQUEST:Message = new Message();
		
		public static final HELP_TOPIC_REMOVE_REQUEST:Message = new Message();
		/**
		 * Sent by the scope manager when a scope change is about to take place
		 */
		public static final SCOPE_CHANGE_BEGUN:Message = new Message();
	}

