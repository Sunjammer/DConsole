package com.furusystems.dconsole2.core.references ;
	import com.furusystems.dconsole2.core.introspection.IntrospectionScope;
	import com.furusystems.dconsole2.core.introspection.ScopeManager;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.messaging.pimp.MessageData;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class ReferenceManager {
		var referenceDict:ASDictionary<ASAny,ASAny> = new ASDictionary(true);
		var console:DConsole;
		var scopeManager:ScopeManager;
		var uidPool:UInt = 0;
		
		@:flash.property var uid(get,never):UInt;
function  get_uid():UInt {
			return uidPool++;
		}
		
		//TODO: Add autocomplete for reference names
		public function new(console:DConsole, scopeManager:ScopeManager) {
			this.scopeManager = scopeManager;
			this.console = console;
			console.messaging.addCallback(Notifications.SCOPE_CHANGE_COMPLETE, onScopeChanged);
		}
		
		function onScopeChanged(md:MessageData) {
			referenceDict["this"] = cast(md.data, IntrospectionScope).targetObject;
		}
		
		public function clearReferenceByName(name:String) {
			try {
				referenceDict.remove(name);
				console.print("Cleared reference " + name, ConsoleMessageTypes.SYSTEM);
				printReferences();
			} catch (e:Error) {
				console.print("No such reference", ConsoleMessageTypes.ERROR);
			}
		}
		
		public function getReferenceByName(target:ASAny, id:String = null) {
			var t:ASObject;
			try {
				t = scopeManager.getScopeByName(target);
			} catch (e:Error) {
				t = target;
			}
			if (!t) {
				throw new Error("Invalid target");
			}
			if (!ASCompat.stringAsBool(id)) {
				id = "ref" + uid;
			}
			referenceDict[id] = t;
			printReferences();
		}
		
		public function getReference(id:String = null) {
			if (!ASCompat.stringAsBool(id)) {
				id = "ref" + uid;
			}
			referenceDict[id] = scopeManager.currentScope.targetObject;
			printReferences();
		}
		
		public function createReference(o:ASAny) {
			var id= "r" + uid;
			referenceDict[id] = o;
			printReferences();
		}
		
		public function clearReferences() {
			referenceDict = new ASDictionary<ASAny,ASAny>(true);
			console.print("References cleared", ConsoleMessageTypes.SYSTEM);
		}
		
		public function printReferences() {
			console.print("Stored references: ");
			for (b in referenceDict.keys()) {
				console.print("	" + Std.string(b) + " : " + Std.string(referenceDict[b]));
			}
		}
		
		public function setScopeByReferenceKey(key:String) {
			if (referenceDict[key]) {
				scopeManager.setScope(referenceDict[key]);
			} else {
				throw new Error("No such reference");
			}
		}
		
		public function parseForReferences(args:Array<ASAny>):Array<ASAny> {
			//return args;
			var i= 0;while (i < args.length) {
				var key:String = args[i];
				if (referenceDict[key] != null) {
					if (Reflect.isFunction(referenceDict[key] )) {
						args[i] = referenceDict[key]();
					} else {
						args[i] = referenceDict[key];
					}
				} else {
					try {
						var force= false;
						if (key.charAt(0) == "@") {
							key = key.substring(1, key.length);
							force = true;
						}
						var tmp:ASAny = scopeManager.getScopeByName(key);
						if (Reflect.isFunction(tmp ) || force) {
							args[i] = tmp;
						}
					} catch (e:Error) {
						//args[i] = null;
					}
				}
i++;
			}
			return args;
		}
	
	}

