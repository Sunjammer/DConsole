package com.furusystems.dconsole2.core.introspection ;
	import com.furusystems.dconsole2.core.introspection.descriptions.*;
	import com.furusystems.dconsole2.core.text.autocomplete.AutocompleteDictionary;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class IntrospectionScope {
		public var autoCompleteDict:AutocompleteDictionary = new AutocompleteDictionary();
		public var children:Vector<ChildScopeDesc>; //child display objects
		public var accessors:Vector<AccessorDesc>; //accessors/setters/getters
		public var methods:Vector<MethodDesc>; //methods
		public var variables:Vector<VariableDesc>; //variables
		public var targetObject:ASObject; //the actual source object
		public var xml:compat.XML;
		public var qualifiedClassName:String;
		public var inheritanceChain:Vector<String>;
		public var interfaces:Vector<String>;
		
		public function new() {
		
		}
	}

