package com.furusystems.dconsole2.plugins.inspectorviews.propertyview.tabs
;
	import com.furusystems.dconsole2.IConsole;
	import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;
	import com.furusystems.dconsole2.core.introspection.IntrospectionScope;
	import com.furusystems.dconsole2.plugins.inspectorviews.propertyview.fieldtypes.PropertyField;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class InheritanceTab extends PropertyTab
	{
		
		public function new(console:IConsole, scope:IntrospectionScope) 
		{
			var className= getQualifiedClassName(scope.targetObject);
			super("Inheritance", false);
			var i:Int;			
			var f:PropertyField;
			i = 0;while (i < scope.inheritanceChain.length) 
			{
				f = new PropertyField(console, null, "Extends", "string");
				f.controlField.value = scope.inheritanceChain[i];
				f.readOnly = true;
				addField(f);
i++;
			}
			i = 0;while (i < scope.interfaces.length) 
			{
				f = new PropertyField(console, null, "Implements", "string");
				f.controlField.value = scope.interfaces[i];
				f.readOnly = true;
				addField(f);
i++;
			}
		}
		override public function updateFields() 
		{
		}
		
	}

