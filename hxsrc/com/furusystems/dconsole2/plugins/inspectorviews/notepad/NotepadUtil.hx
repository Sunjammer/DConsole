package com.furusystems.dconsole2.plugins.inspectorviews.notepad 
;
	import com.furusystems.dconsole2.core.inspector.AbstractInspectorView;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class NotepadUtil extends AbstractInspectorView
	{
		
		public function new() 
		{
			super("Notepad");
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsoleInspectorPlugin */
		
		override function  get_descriptionText():String { 
			return "Adds a simple persistent text input window to the inspector";
		}
		override function  get_title():String 
		{
			return "Notepad";
		}
				
		override function  get_dependencies():Vector<Class<Dynamic>> 
		{
			return null;
		}
		
		
	}

