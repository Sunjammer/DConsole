package com.furusystems.dconsole2.core.text.autocomplete ;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 /*dynamic*/ class AutocompleteDictionary {
		public var basepage:ASObject = new ASObject();
		var stringContents:Vector<String> = new Vector();
		var stringContentsLowercase:Vector<String> = new Vector();
		
		public function new() {
		}
		
		public function correctCase(str:String):String {
			var idx= stringContentsLowercase.indexOf(str.toLowerCase());
			if (idx == -1)
				throw new Error("No result");
			return stringContents[idx];
		}
		
		public function addToDictionary(str:String) {
			stringContents.push(str);
			stringContentsLowercase.push(str.toLowerCase()); //TODO: This is a terrible way to solve the search problem. Must fix.
			var strParts:Array<ASAny> = (cast str.split(""));
			strParts.push('');
			insert(strParts, basepage);
		}
		
		public function contains(str:String):Bool {
			return stringContentsLowercase.indexOf(str.toLowerCase(), 0) > -1;
		}
		
		function insert(parts:Array<ASAny>, page:ASObject) {
			if (parts[0] == /*undefined*/null) {
				return;
			}
			var letter:String = parts[0];
			if (!page[letter]) {
				page[letter] = new ASObject();
			}
			insert(parts.slice(1, parts.length), page[letter]);
		}
		
		public function getSuggestion(arr:Array<ASAny>):String {
			var suggestion= "";
			var len:UInt = arr.length;
			var tmpDict:ASObject = basepage;
			
			if (len < 1) {
				return suggestion;
			}
			
			var letter:String;
			var i:UInt = 0;while (i < len) {
				letter = arr[i];
				if (tmpDict[letter.toUpperCase()] && tmpDict[letter.toLowerCase()]) {
					var upperTmpDict:ASObject = tmpDict[letter.toUpperCase()];
					var lowerTmpDict:ASObject = tmpDict[letter.toLowerCase()];
					tmpDict = mergeDictionaries(lowerTmpDict, upperTmpDict);
				} else if (tmpDict[letter.toUpperCase()]) {
					tmpDict = tmpDict[letter.toUpperCase()];
				} else if (tmpDict[letter.toLowerCase()]) {
					tmpDict = tmpDict[letter.toLowerCase()];
				} else {
					return suggestion;
				}
i++;
			}
			
			var loop= true;
			while (loop) {
				loop = false;
				for (l in tmpDict.___keys()) {
					if (shouldContinue(tmpDict)) {
						suggestion += l;
						tmpDict = tmpDict[l];
						loop = true;
						break;
					}
				}
			}
			
			return suggestion;
		}
		
		function mergeDictionaries(lowerCaseDict:ASObject, upperCaseDict:ASObject):ASObject {
			var tmpDict:ASObject = new ASObject();
			
			for (j in lowerCaseDict.___keys()) {
				tmpDict[j] = lowerCaseDict[j];
			}
			
			for (k in upperCaseDict.___keys()) {
				if (tmpDict[k] != /*undefined*/null && upperCaseDict[k] != /*undefined*/null) {
					tmpDict[k] = mergeDictionaries(tmpDict[k], upperCaseDict[k]);
				} else {
					tmpDict[k] = upperCaseDict[k];
				}
			}
			return tmpDict;
		}
		
		function shouldContinue(tmpDict:ASObject):Bool {
			var count:Float = 0;
			for (k in tmpDict.___keys()) {
				if (count > 0) {
					return false;
				}
				count++;
			}
			return true;
		}
	
	}

