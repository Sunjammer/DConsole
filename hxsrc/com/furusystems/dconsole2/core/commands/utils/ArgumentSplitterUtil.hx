package com.furusystems.dconsole2.core.commands.utils ;
	import com.furusystems.dconsole2.core.errors.ErrorStrings;
	
	/**
	 * Utility for splitting strings into argument objects
	 * @author Andreas Roenning
	 */
	 class ArgumentSplitterUtil {
		static final SINGLE_QUOTE:Int = "'".charCodeAt(0);
		static final DOUBLE_QUOTE:Int = '"'.charCodeAt(0);
		static final OBJECT_START:Int = "{".charCodeAt(0);
		static final OBJECT_STOP:Int = "}".charCodeAt(0);
		static final ARRAY_START:Int = "[".charCodeAt(0);
		static final ARRAY_STOP:Int = "]".charCodeAt(0);
		static final SUBCOMMAND_START:Int = "(".charCodeAt(0);
		static final SUBCOMMAND_STOP:Int = ")".charCodeAt(0);
		static final SPACE:Int = " ".charCodeAt(0);
		static final UTIL:Int = "|".charCodeAt(0);
		
		public static function slice(a:String):Array<ASAny> {
			//fast search for string input
			if ((a.charAt(0) == "'" && a.charAt(a.length - 1) == "'") || (a.charAt(0) == '"' && a.charAt(a.length - 1) == '"')) {
				return [a];
			}
			var position= 0;
			
			while (position < a.length) {
				position++;
				var char= a.charCodeAt(position);
				switch (char) {
					case SUBCOMMAND_START:
						position = findSubCommand(a, position);
						
					case SPACE:
						var sa= a.substring(0, position);
						var sb= a.substring(position + 1);
						var ar:Array<ASAny> = [sa, sb];
						a = ar.join(UTIL);
						
					case SINGLE_QUOTE
					   | DOUBLE_QUOTE:
						position = findString(a, position);
						
					case OBJECT_START:
						position = findObject(a, position);
						
					case ARRAY_START:
						position = findArray(a, position);
						
				}
			}
			var out:Array<ASAny> = (cast a.split('|'));
			var str= "";
			var i= 0;while (i < out.length) {
				str = out[i];
				if (str.charCodeAt(0) == SINGLE_QUOTE || str.charCodeAt(0) == DOUBLE_QUOTE) {
					out[i] = str.substring(1, str.length - 1);
				}
i++;
			}
			return out;
		}
		
		static function findSubCommand(input:String, start:Int):Int {
			var score= 0;
			var l= input.length;
			var char:Int;
			var end = 0;
			for (i in start...l) {
				char = input.charCodeAt(i);
				if (char == SUBCOMMAND_START) {
					score++;
				} else if (char == SUBCOMMAND_STOP) {
					score--;
					if (score <= 0) {
						end = i;
						break;
					}
				}
			}
			if (score > 0) {
				throw new ArgumentError(ErrorStrings.SUBCOMMAND_PARSE_ERROR_TERMINATION);
			}
			return end;
		}
		
		static function findObject(input:String, start:Int):Int {
			var score= 0;
			var l= input.length;
			var char:Int;
			var end = 0;
			for (i in start...l) {
				char = input.charCodeAt(i);
				if (char == OBJECT_START) {
					score++;
				} else if (char == OBJECT_STOP) {
					score--;
					if (score <= 0) {
						end = i;
						break;
					}
				}
			}
			if (score > 0) {
				throw new ArgumentError(ErrorStrings.OBJECT_PARSE_ERROR_TERMINATION);
			}
			return end;
		}
		
		static function findArray(input:String, start:Int):Int {
			var score= 0;
			var l= input.length;
			var char:Int;
			var end = 0;
			for (i in start...l) {
				char = input.charCodeAt(i);
				if (char == ARRAY_START) {
					score++;
				} else if (char == ARRAY_STOP) {
					score--;
					if (score <= 0) {
						end = i;
						break;
					}
				}
			}
			if (score > 0) {
				throw new ArgumentError(ErrorStrings.ARRAY_PARSE_ERROR_TERMINATION);
			}
			return end;
		}
		
		static function findString(input:String, start:Int):Int {
			var out= input.indexOf(input.charAt(start), start + 1);
			if (out < start)
				throw new ArgumentError(ErrorStrings.STRING_PARSE_ERROR_TERMINATION);
			return out;
		}
		
		static function findCommand(input:String):Int {
			return input.split(' ').shift().length;
		}
	
	}

