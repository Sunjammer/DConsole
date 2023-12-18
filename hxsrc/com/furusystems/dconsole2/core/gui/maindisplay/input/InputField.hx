package com.furusystems.dconsole2.core.gui.maindisplay.input ;
	import com.furusystems.dconsole2.core.gui.layout.IContainable;
	import com.furusystems.dconsole2.core.interfaces.IThemeable;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.core.style.TextFormats;
	import com.furusystems.dconsole2.core.text.TextUtils;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.messaging.pimp.MessageData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	/**
	 * The main input field
	 * @author Andreas Roenning
	 */
	 class InputField extends Sprite implements IContainable implements  IThemeable {
		var _inputTextField:TextField;
		var _console:IConsole;
		
		public function new(console:IConsole) {
			super();
			_console = console;
			tabEnabled = tabChildren = false;
			_inputTextField = new TextField();
			_inputTextField.border = true;
			_inputTextField.embedFonts = TextFormats.INPUT_FONT.charAt(0) != "_";
			_inputTextField.defaultTextFormat = TextFormats.inputTformat;
			_inputTextField.multiline = false;
			_inputTextField.type = TextFieldType.INPUT;
			_inputTextField.background = true;
			_inputTextField.borderColor = Colors.INPUT_BORDER;
			_inputTextField.backgroundColor = Colors.INPUT_BG;
			_inputTextField.textColor = Colors.INPUT_FG;
			_inputTextField.tabEnabled = false;
			
			_inputTextField.text = "Input";
			_inputTextField.addEventListener(Event.CHANGE, onInputChange);
			addChild(_inputTextField);
			_console.messaging.addCallback(Notifications.CONSOLE_INPUT_LINE_CHANGE_REQUEST, onInputlineChangeRequest);
			_console.messaging.addCallback(Notifications.THEME_CHANGED, onThemeChange);
		}
		
		function onInputlineChangeRequest(md:MessageData) {
			text = ASCompat.toString(md.data);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		function onInputChange(e:Event) {
			dispatchEvent(e.clone());
		}
		
				
		@:flash.property public var text(get,set):String;
function  get_text():String {
			return _inputTextField.text;
		}
function  set_text(s:String):String{
			_inputTextField.text = s;
			focus();
return s;
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.gui.layout.IContainable */
		
		public function onParentUpdate(allotedRect:Rectangle) {
			y = allotedRect.y;
			x = allotedRect.x;
			_inputTextField.height = GUIUnits.SQUARE_UNIT;
			_inputTextField.width = allotedRect.width - 1;
		}
		
		@:flash.property public var rect(get,never):Rectangle;
function  get_rect():Rectangle {
			return getRect(parent);
		}
		
		@:flash.property public var minHeight(get,never):Float;
function  get_minHeight():Float {
			return 0;
		}
		
		@:flash.property public var minWidth(get,never):Float;
function  get_minWidth():Float {
			return 0;
		}
		
		public function moveCaretToIndex(index:Int = -1) {
			if (index == -1) {
				index = inputTextField.length;
			}
			inputTextField.setSelection(index, index);
		}
		
		@:flash.property public var selectionBeginIndex(get,never):Int;
function  get_selectionBeginIndex():Int {
			return _inputTextField.selectionBeginIndex;
		}
		
		@:flash.property public var selectionEndIndex(get,never):Int;
function  get_selectionEndIndex():Int {
			return _inputTextField.selectionEndIndex;
		}
		
		public function getWordAtIndex(index:Int):String {
			return TextUtils.getWordAtIndex(_inputTextField, index);
		}
		
		@:flash.property public var firstIndexOfWordAtCaret(get,never):Int;
function  get_firstIndexOfWordAtCaret():Int {
			return TextUtils.getFirstIndexOfWordAtCaretIndex(_inputTextField);
		}
		
		@:flash.property public var firstWord(get,never):String;
function  get_firstWord():String {
			return getWordAtIndex(0);
		}
		
		@:flash.property public var wordAtCaret(get,never):String;
function  get_wordAtCaret():String {
			return TextUtils.getWordAtCaretIndex(inputTextField);
		}
		
		public function selectWordAtCaret() {
			TextUtils.selectWordAtCaretIndex(_inputTextField);
		}
		
		public function moveCaretToEnd() {
			moveCaretToIndex(-1);
		}
		
		public function moveCaretToStart() {
			moveCaretToIndex(0);
		}
		
		public function focus() {
			if (stage.focus == _inputTextField)
				return;
			stage.focus = _inputTextField;
			moveCaretToEnd();
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.interfaces.IThemable */
		
		public function onThemeChange(md:MessageData) {
			_inputTextField.borderColor = Colors.INPUT_BORDER;
			_inputTextField.backgroundColor = Colors.INPUT_BG;
			_inputTextField.textColor = Colors.INPUT_FG;
		}
		
		public function clear() {
			text = "";
		}
		
		/**
		 * Insert a string at the current caret index, as though the user typed a word
		 * @param	string
		 */
		public function insertAtCaret(string:String) {
			deleteSelection();
			var a= text.substr(0, caretIndex);
			var b= text.substr(caretIndex);
			text = a + string + b;
			moveCaretToIndex(a.length + string.length);
		}
		
		public function deleteSelection() {
			var a= text.substr(0, _inputTextField.selectionBeginIndex);
			var b= text.substr(_inputTextField.selectionEndIndex);
			
			_inputTextField.text = a + b;
		}
		
		@:flash.property public var selectionActive(get,never):Bool;
function  get_selectionActive():Bool {
			return _inputTextField.selectedText != "";
		}
		
		@:flash.property public var length(get,never):Int;
function  get_length():Int {
			return _inputTextField.length;
		}
		
		@:flash.property public var caretIndex(get,never):Int;
function  get_caretIndex():Int {
			return _inputTextField.caretIndex;
		}
		
		@:flash.property public var inputTextField(get,never):TextField;
function  get_inputTextField():TextField {
			return _inputTextField;
		}
	
	}

