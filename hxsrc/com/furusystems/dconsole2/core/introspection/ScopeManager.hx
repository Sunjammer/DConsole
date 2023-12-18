package com.furusystems.dconsole2.core.introspection ;
	import com.furusystems.dconsole2.core.commands.CommandManager;
	import com.furusystems.dconsole2.core.introspection.descriptions.*;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.text.autocomplete.AutocompleteManager;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.messaging.pimp.MessageData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class ScopeManager extends EventDispatcher {
		public static inline final SEARCH_METHODS= 0;
		public static inline final SEARCH_ACCESSORS= 1;
		public static inline final SEARCH_CHILDREN= 2;
		
		var _currentScope:IntrospectionScope;
		var _previousScope:IntrospectionScope;
		
		var console:DConsole;
		var autoCompleteManager:AutocompleteManager;
		var commandManager:CommandManager;
		
		public function new(console:DConsole, autoCompleteManager:AutocompleteManager) {
			super();
			this.console = console;
			this.autoCompleteManager = autoCompleteManager;
			console.messaging.addCallback(Notifications.REQUEST_PROPERTY_CHANGE_ON_SCOPE, onPropertyChangeRequest);
			console.messaging.addCallback(Notifications.SCOPE_CHANGE_REQUEST_FROM_PROPERTY, onPropertyScopeChangeRequest);
			console.messaging.addCallback(Notifications.SCOPE_CHANGE_REQUEST_FROM_CHILD_NAME, onChildNameScopeChangeRequest);
		}
		
		public function initialize() {
			_currentScope = createScope({});
		}
		
		function onChildNameScopeChangeRequest(md:MessageData) {
			try {
				setScope(cast(_currentScope.targetObject, DisplayObjectContainer).getChildByName(ASCompat.toString(md.data)));
			} catch (e:Error) {
				console.print("Null reference, couldn't select target.", ConsoleMessageTypes.ERROR);
			}
		}
		
		function onPropertyScopeChangeRequest(md:MessageData) {
			try {
				setScope(_currentScope.targetObject[md.data]);
			} catch (e:Error) {
				console.print("Null reference, couldn't select target.", ConsoleMessageTypes.ERROR);
			}
		}
		
		function onPropertyChangeRequest(md:MessageData) {
			_currentScope.targetObject[md.data.name] = md.data.newValue;
			console.messaging.send(Notifications.PROPERTY_CHANGE_ON_SCOPE, _currentScope, this);
		}
		
		public function createScope(o:ASAny, justReturn:Bool = false):IntrospectionScope {
			if (!o)
				throw new ArgumentError("Invalid scope");
			var c= new IntrospectionScope();
			c.children = TreeUtils.getChildren(o);
			c.accessors = InspectionUtils.getAccessors(o);
			c.methods = InspectionUtils.getMethods(o);
			c.variables = InspectionUtils.getVariables(o);
			c.targetObject = o;
			c.xml = ASCompat.describeType(o);
			c.qualifiedClassName = getQualifiedClassName(o);
			c.inheritanceChain = InspectionUtils.getInheritanceChain(o);
			c.interfaces = InspectionUtils.getInterfaces(o);
			
			if (justReturn)
				return c;
			c.autoCompleteDict = InspectionUtils.getAutoCompleteDictionary(o);
			_currentScope = c;
			console.messaging.send(Notifications.SCOPE_CREATED, _currentScope, this);
			return _currentScope;
		}
		
		public function setScope(o:ASAny, force:Bool = false, printResults:Bool = true) {
			if (Std.is(o , Stage) && DConsole.STAGE_SAFE_MODE) {
				console.print("Stage safe mode active, access prohibited", ConsoleMessageTypes.ERROR);
				return; //TODO: Stage selections really shouldn't be disallowed. But Stage object is so weird :-/
			}
			if (Std.is(o , DConsole) && DConsole.CONSOLE_SAFE_MODE) {
				console.print("Console safe mode active, access prohibited", ConsoleMessageTypes.ERROR);
				return;
			}
			//if(currentScope.targetObject===o){
			//if (force&&printResults) {
			//printScope();
			//printDownPath();
			//}
			//return;
			//}
			console.messaging.send(Notifications.SCOPE_CHANGE_BEGUN, _currentScope, this);
			try {
				createScope(o);
				autoCompleteManager.scopeDict = currentScope.autoCompleteDict;
			} catch (e:Error) {
				throw e;
			}
			if (printResults) {
				printScope();
				printDownPath();
			}
			console.messaging.send(Notifications.SCOPE_CHANGE_COMPLETE, _currentScope, this);
		}
		
		public function getScopeByName(str:String):ASAny {
			try {
				if (currentScope.targetObject[str]) {
					return currentScope.targetObject[str];
				} else
					throw new Error();
			} catch (e:Error) {
				try {
					if (Std.is(currentScope.targetObject , DisplayObjectContainer)) {
						var tmp:DisplayObject = currentScope.targetObject.getChildByName(str);
						if (tmp != null)
							return tmp;
					}
				} catch (e:Error) {
				}
			}
			throw new Error("No such scope");
		}
		
		public function getRoot():DisplayObject {
			return console.root;
		}
		
		@:flash.property public var currentScope(get,never):IntrospectionScope;
function  get_currentScope():IntrospectionScope {
			return _currentScope;
		}
		
		public function up() {
			if (_currentScope == null) {
				throw new Error("No current scope; cannot switch to parent");
			}
			if (Std.is(_currentScope.targetObject , DisplayObject)) {
				setScope(_currentScope.targetObject.parent);
			} else {
				throw new Error("Current scope is not a DisplayObject; cannot switch to parent");
			}
		}
		
		function traverseFor(obj:ASObject, name:String):ASObject {
			
			throw new Error("Not found");
		}
		
		public function setScopeByName(str:String) {
			if (str.indexOf(".") > -1) {
				//path
				var found= false;
				var split:Array<ASAny> = (cast str.split("."));
				var i= 0;while (i < split.length) {
					setScope(getScopeByName(split[i]), false, i == split.length - 1);
i++;
				}
				
			} else {
				//name
				try {
					setScope(getScopeByName(str));
				} catch (e:Error) {
					throw e;
				}
			}
		}
		
		public function printMethods() {
			var m= currentScope.methods;
			console.print("	methods:");
			var i:Int;
			i = 0;while (i < m.length) {
				var md= m[i];
				console.print("		" + md.name + " : " + md.returnType);
i++;
			}
		}
		
		public function printVariables() {
			var a= currentScope.variables;
			var cv:ASAny;
			console.print("	variables: " + a.length);
			var i:Int;
			i = 0;while (i < a.length) {
				var vd= a[i];
				console.print("		" + vd.name + ": " + vd.type);
				try {
					cv = currentScope.targetObject[vd.name];
					console.print("			value: " + (Std.is(cv , ByteArray) ? "[ByteArray]" : Std.string(cv)));
				} catch (e:Error) {
					
				}
i++;
			}
			var b= currentScope.accessors;
			console.print("	accessors: " + b.length);
			i = 0;while (i < b.length) {
				var ad= b[i];
				console.print("		" + ad.name + ": " + ad.type);
				try {
					cv = currentScope.targetObject[ad.name];
					console.print("			value: " + (Std.is(cv , ByteArray) ? "[ByteArray]" : Std.string(cv)));
				} catch (e:Error) {
					
				}
i++;
			}
		}
		
		public function printChildren() {
			var c= currentScope.children;
			if (c.length < 1)
				return;
			console.print("	children: " + c.length);
			var i= 0;while (i < c.length) {
				var cc= c[i];
				console.print("		" + cc.name + " : " + cc.type);
i++;
			}
		}
		
		public function printDownPath() {
			printChildren();
			printComplexObjects();
		}
		
		public function printComplexObjects() {
			var a= currentScope.variables;
			var cv:ASAny;
			if (a.length < 1)
				return;
			var i:Int;
			var out:Array<ASAny> = [];
			i = 0;while (i < a.length) {
				var vd= a[i];
				switch (vd.type) {
					case "Number"
					   | "Boolean"
					   | "String"
					   | "int"
					   | "uint"
					   | "Array":
						i++;continue;
				}
				out.push("		" + vd.name + ": " + vd.type);
i++;
			}
			console.print("	complex types: " + out.length);
			if (out.length > 0) {
				i = 0;while (i < out.length) {
					console.print(out[i]);
i++;
				}
			}
		}
		
		public function printScope() {
			if (Std.is(currentScope.targetObject , ByteArray)) {
				console.print("scope : [ByteArray]");
			} else {
				console.print("scope : " + Std.string(currentScope.targetObject));
			}
		}
		
		public function setPropertyOnObject(propertyName:String, arg:ASAny):ASAny {
			if (arg == "true") {
				arg = true;
			} else if (arg == "false") {
				arg = false;
			}
			try {
				currentScope.targetObject[propertyName] = arg;
			} catch (e:Error) {
				console.print("Property '" + propertyName + "' could not be set", ConsoleMessageTypes.ERROR);
			}
			try {
				return currentScope.targetObject[propertyName];
			} catch (e:Error) {
				return null;
			}
		}
		
		public function getPropertyOnObject(propertyName:String):String {
			return Std.string(currentScope.targetObject[propertyName]);
		}
		
		public function getPropertyValueOnObject(propertyName:String):ASAny {
			return currentScope.targetObject[propertyName];
		}
		
		public function selectBaseScope() {
			setScope(console.parent);
		}
		
		public function callMethodOnScope( args:Array<ASAny> = null):ASAny {
if (args == null) args = [];
			var cmd:ASFunction = args.shift();
			return commandManager.callMethodWithArgs(cmd, args);
		}
		
		public function updateScope() {
			setScope(currentScope.targetObject, true);
		}
		
		public function doSearch(search:String, searchMode:Int = SEARCH_METHODS):Vector<String> {
			var result= new Vector<String>();
			var s= search.toLowerCase();
			var i:Int;
			switch (searchMode) {
				case SEARCH_ACCESSORS:
					i = currentScope.accessors.length;while (i-- != 0) {
						var a= currentScope.accessors[i];
						if (a.name.toLowerCase().indexOf(s, 0) > -1) {
							result.push(a.name);
						}
					}
					i = currentScope.variables.length;while (i-- != 0) {
						var v= currentScope.variables[i];
						if (v.name.toLowerCase().indexOf(s, 0) > -1) {
							result.push(v.name);
						}
					}
					
				case SEARCH_METHODS:
					i = currentScope.methods.length;while (i-- != 0) {
						var m= currentScope.methods[i];
						if (m.name.toLowerCase().indexOf(s, 0) > -1) {
							result.push(m.name);
						}
					}
					
				case SEARCH_CHILDREN:
					i = currentScope.children.length;while (i-- != 0) {
						var c= currentScope.children[i];
						if (c.name.toLowerCase().indexOf(s, 0) > -1) {
							result.push(c.name);
						}
					}
					
			}
			return result;
		}
		
		public function describeObject(o:ASObject):IntrospectionScope {
			return createScope(o, true);
		}
		
		public function setCommandMgr(commandManager:CommandManager) {
			this.commandManager = commandManager;
		}
	
	}

