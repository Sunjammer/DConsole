package com.furusystems.dconsole2.plugins.dialog 
;
	/**
	 * VO containing a vector of string responses 
	 * @author Andreas Ronning
	 */
	 class DialogResult 
	{
		var _result:Vector<String> = new Vector();
		public function addResult(result:String) {
			_result.push(result);
		}
		@:flash.property public var results(get,never):Vector<String>;
function  get_results():Vector<String> 
		{
			return _result;
		}
public function new(){}
		
	}

