package com.furusystems.dconsole2.plugins.inspectorviews.propertyview.tabs
;
	import com.furusystems.dconsole2.IConsole;
	import flash.display.DisplayObject;
	import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;
	import com.furusystems.dconsole2.core.introspection.IntrospectionScope;
	import com.furusystems.dconsole2.plugins.inspectorviews.propertyview.fieldtypes.PropertyField;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class OverviewTab extends PropertyTab
	{
		
		public function new(console:IConsole, scope:IntrospectionScope) 
		{
			var className= getQualifiedClassName(scope.targetObject);
			super(className.split("::").pop(), true);
			var i:Int;
			if (Std.is(scope.targetObject , DisplayObject)) {
				var displayObject= ASCompat.dynamicAs(scope.targetObject , DisplayObject);
				if (displayObject != displayObject.root) addField(new PropertyField(console, scope.targetObject, "name", "string", "readwrite"));
				i = 0;while (i < scope.accessors.length) 
				{
					if (scope.accessors[i].name.toLowerCase() == "parent") {
						addField(new PropertyField(console, scope.targetObject, scope.accessors[i].name, scope.accessors[i].type, scope.targetObject[scope.accessors[i].name]));
						break;
					}
i++;
				}
			}
		}
		
	}

