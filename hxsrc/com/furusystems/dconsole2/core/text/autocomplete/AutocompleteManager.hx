package com.furusystems.dconsole2.core.text.autocomplete
;
	import com.furusystems.dconsole2.core.text.TextUtils;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;

	/**
	 * ...
	 * @author Andreas Roenning
	 * Heavily based on Ali Mills' work on ternary trees at http://www.asserttrue.com/articles/2006/04/09/actionscript-projects-in-flex-builder-2-0
	 */
	 class AutocompleteManager
	{

		var txt:String;
		public var dict:AutocompleteDictionary;
		public var scopeDict:AutocompleteDictionary;
		var paused:Bool = false;
		var _targetTextField:TextField;
		public var suggestionActive:Bool = false;
		public var ready:Bool = false;

		public function new(targetTextField:TextField)
		{
			this.targetTextField = targetTextField;
		}

		public function setDictionary(newDict:AutocompleteDictionary)
		{
			dict = newDict;
			ready = true;
		}

		function changeListener(e:Event)
		{
			suggestionActive = false;
			if (!paused)
			{
				complete();
			}
		}

		function keyDownListener(e:KeyboardEvent)
		{
			if (e.keyCode == Keyboard.BACKSPACE || e.keyCode == Keyboard.DELETE)
			{
				paused = true;
			}
			else
			{
				paused = false;
			}
		}

		public function complete()
		{

			// TODO: Start process offset by the nearest occurence of an opening parenthesis
			suggestionActive = false;
			// if the caret is somewhere in an existing word, ignore
			var nextChar= _targetTextField.text.charAt(_targetTextField.caretIndex);
			if (_targetTextField.caretIndex < _targetTextField.text.length && nextChar != "" && nextChar != " ")
			{
				return;
			}

			// we only complete single words, so start caret is the beginning of the word the caret is currently in
			var firstIndex= TextUtils.getFirstIndexOfWordAtCaretIndex(_targetTextField);
			var str= _targetTextField.text.substr(firstIndex, _targetTextField.caretIndex);
			var strParts:Array<ASAny> = (cast str.split(""));
			var suggestion:String;
			if (scopeDict == null || firstIndex < 1)
			{
				suggestion = dict.getSuggestion(strParts);
			}
			else
			{
				suggestion = scopeDict.getSuggestion(strParts);
			}
			if (suggestion.length > 0)
			{
				// Sort of a brutal divide and conquer strategy here. Someone smarter take a look?
				var _originalText= _targetTextField.text;
				var originalCaretIndex= _targetTextField.caretIndex;
				var currentWord= TextUtils.getWordAtCaretIndex(_targetTextField);
				var wordSplit:Array<ASAny> = (cast _originalText.split(" "));
				var wordIndex= wordSplit.indexOf(currentWord);
				currentWord += suggestion;
				ASCompat.arraySplice(wordSplit, wordIndex, 1, [currentWord]);
				_targetTextField.text = wordSplit.join(" ");

				_targetTextField.setSelection(originalCaretIndex, originalCaretIndex + suggestion.length);
				suggestionActive = true;
			}
		}

		public function isKnown(str:String, includeScope:Bool = false, includeCommands:Bool = true):Bool
		{
			if (scopeDict != null && includeScope)
			{
				if (scopeDict.contains(str))
					return true;
			}
			if (includeCommands)
				return dict.contains(str);
			return false;
		}

		
		@:flash.property public var targetTextField(get,set):TextField;
function  get_targetTextField():TextField
		{
			return _targetTextField;
		}
function  set_targetTextField(value:TextField):TextField		{
			try
			{
				_targetTextField.removeEventListener(Event.CHANGE, changeListener);
				_targetTextField.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			}
			catch (e:Error)
			{
			}
			// TODO: Finally block
			_targetTextField = value;
			_targetTextField.addEventListener(Event.CHANGE, changeListener);
			_targetTextField.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
return value;
		}

		public function correctCase(str:String):String
		{
			try
			{
				return dict.correctCase(str);
			}
			catch (e:Error)
			{
				if (scopeDict != null)
					return scopeDict.correctCase(str);
			}
			throw new Error("No correct case found");
		}
	}

