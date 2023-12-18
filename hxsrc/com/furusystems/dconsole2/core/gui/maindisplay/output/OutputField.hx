package com.furusystems.dconsole2.core.gui.maindisplay.output ;
	import com.furusystems.dconsole2.core.gui.layout.IContainable;
	import com.furusystems.dconsole2.core.gui.SimpleScrollbarNorm;
	import com.furusystems.dconsole2.core.interfaces.IThemeable;
	import com.furusystems.dconsole2.core.logmanager.DConsoleLog;
	import com.furusystems.dconsole2.core.logmanager.DLogManager;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.output.ConsoleMessage;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.style.Alphas;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.StyleManager;
	import com.furusystems.dconsole2.core.style.TextFormats;
	import com.furusystems.dconsole2.core.utils.StringUtil;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.messaging.pimp.MessageData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	
	/**
	 * Handles rendering of a vector of messages
	 * @author Andreas Roenning
	 */
	 class OutputField extends Sprite implements IContainable implements  IThemeable {
		var _textOutput:TextField;
		var _scrollbar:SimpleScrollbarNorm;
		var _locked:Bool = false;
		var _scrollRange:Int = 0;
		var _scrollIndex:Int = 0;
		var _currentLog:DConsoleLog;
		var _atBottom:Bool = true;
		var _lineMetrics:TextLineMetrics;
		var _allotedRect:Rectangle;
		public var showLineNum:Bool = true;
		public var traceValues:Bool = true;
		public var showTraceValues:Bool = true;
		public var showTimeStamp:Bool = false;
		public var showTag:Bool = true; //TODO: Make this private?
		var _dirty:Bool = false;
		static inline final TRUNCATE= false;
		var _console:DConsole;
		
		public function new(console:DConsole) {
			super();
			_console = console;
			_textOutput = new TextField();
			_textOutput.defaultTextFormat = TextFormats.outputTformatOld;
			_textOutput.embedFonts = TextFormats.OUTPUT_FONT.charAt(0) != "_";
			
			_textOutput.text = "#";
			_lineMetrics = _textOutput.getLineMetrics(0);
			addChild(_textOutput);
			_scrollbar = new SimpleScrollbarNorm(SimpleScrollbarNorm.VERTICAL);
			_scrollbar.addEventListener(Event.CHANGE, onScrollbarChange);
			_scrollbar.trackWidth = 10;
			addChild(_scrollbar);
			_textOutput.mouseWheelEnabled = false;
			_textOutput.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			console.messaging.addCallback(Notifications.THEME_CHANGED, onThemeChange);
			console.messaging.addCallback(Notifications.CURRENT_LOG_CHANGED, onCurrentLogChange);
			console.messaging.addCallback(Notifications.FRAME_UPDATE, onFrameUpdate);
			
			if (TRUNCATE)
				_textOutput.addEventListener(MouseEvent.CLICK, onTextClick);
		}
		
		function onFrameUpdate() {
			if (_locked) {
				return;
			}
			if (_currentLog.dirty || _dirty) {
				drawMessages();
				_currentLog.setClean();
				_dirty = false;
			}
		}
		
		function onCurrentLogChange(md:MessageData) {
			var lm= cast(md.source, DLogManager);
			currentLog = lm.currentLog;
			_dirty = true;
		}
		
		function onTextClick(e:MouseEvent) {
			var lineIDX= _textOutput.getLineIndexAtPoint(_textOutput.mouseX, _textOutput.mouseY);
			var msg= getMessageAtLine(lineIDX);
			if (msg.truncated) {
				//TODO: Display clicked text in some sort of popover
			}
		}
		
		function onScrollbarChange(e:Event) {
			scrollIndex = Std.int(_scrollbar.outValue * maxScroll);
		}
		
		/**
		 * The number of lines displayable
		 */
		@:flash.property public var numLines(get,never):Int;
function  get_numLines():Int {
			return Std.int(Math.max(1, Math.ffloor((_textOutput.height - 4) / _lineMetrics.height)));
		}
		
				
		@:flash.property public var text(get,set):String;
function  set_text(s:String):String{
			return _textOutput.text = s;
		}
function  get_text():String {
			return _textOutput.text;
		}
		
		public function setText(s:String) {
			_textOutput.text = s;
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.gui.layout.IContainable */
		
		public function onParentUpdate(allotedRect:Rectangle) {
			_allotedRect = allotedRect;
			y = allotedRect.y;
			x = allotedRect.x;
			var prevHeight= _textOutput.height;
			_textOutput.width = allotedRect.width - _scrollbar.trackWidth;
			_textOutput.height = allotedRect.height;
			_scrollbar.x = allotedRect.width - _scrollbar.trackWidth;
			drawBackground();
			var r= allotedRect.clone();
			_scrollbar.draw(r.height, _scrollIndex, maxScroll);
			
			if (prevHeight != _textOutput.height) {
				_dirty = true;
					//update(); //introduces latency but avoids clogging when called in a loop
					//drawMessages();
			}
		}
		
		function drawBackground() {
			if (_allotedRect == null)
				return;
			graphics.clear();
			graphics.beginFill(Colors.OUTPUT_BG, Alphas.CONSOLE_CORE_ALPHA);
			graphics.drawRect(0, 0, _allotedRect.width, _allotedRect.height);
		}
		
		@:flash.property public var minHeight(get,never):Float;
function  get_minHeight():Float {
			return 0;
		}
		
		@:flash.property public var minWidth(get,never):Float;
function  get_minWidth():Float {
			return 0;
		}
		
		@:flash.property public var rect(get,never):Rectangle;
function  get_rect():Rectangle {
			return _allotedRect;
		}
		
		@:flash.property public var textOutput(get,never):TextField;
function  get_textOutput():TextField {
			return _textOutput;
		}
		
		@:flash.property public var locked(get,never):Bool;
function  get_locked():Bool {
			return _locked;
		}
		
		public function gotoLine(line:Int) {
			scrollToLine(line - 1);
		}
		
		public function scrollToLine(line:Int) {
			var diff= scrollIndex - line;
			scroll(diff);
		}
		
		public function lockOutput() {
			_locked = true;
		}
		
		public function unlockOutput() {
			_locked = false;
		}
		
		/**
		 * Toggle display of message timestamp
		 */
		public function toggleTimestamp(input:String = null) {
			if (input == null) {
				showTimeStamp = !showTimeStamp;
			} else {
				showTimeStamp = StringUtil.verboseToBoolean(input);
			}
			if (showTimeStamp)
				_console.print("Timestamp on", ConsoleMessageTypes.SYSTEM)
			else
				_console.print("Timestamp off", ConsoleMessageTypes.SYSTEM);
		}
		
		function onMouseWheel(e:MouseEvent) {
			scroll(e.delta);
		}
		
		public function toggleLineNumbers(input:String = null) {
			if (input == null) {
				showLineNum = !showLineNum;
			} else {
				showLineNum = StringUtil.verboseToBoolean(input);
			}
			showLineNum ? _console.print("Line numbers: on", ConsoleMessageTypes.SYSTEM) : _console.print("Line numbers: off", ConsoleMessageTypes.SYSTEM);
			_dirty = true;
		}
		
		public function scroll(deltaY:Int = 0, deltaX:Int = 0) {
			_textOutput.scrollH += deltaX;
			if (deltaY != 0) {
				if (currentLog.length < numLines)
					return;
				scrollIndex = scrollIndex - deltaY;
			}
		}
		
				
		@:flash.property public var scrollIndex(get,set):Int;
function  set_scrollIndex(i:Int):Int{
			var _prevIndex= _scrollIndex;
			_scrollIndex = Std.int(Math.max(0, Math.min(i, maxScroll)));
			_atBottom = _scrollIndex == maxScroll;
			if (_prevIndex != _scrollIndex) {
				_dirty = true;
			}
return i;
		}
function  get_scrollIndex():Int {
			return _scrollIndex;
		}
		
		@:flash.property public var maxScroll(get,never):Int;
function  get_maxScroll():Int {
			if (currentLog == null)
				return 0;
			return Std.int(Math.max(0, currentLog.messages.length - numLines));
		}
		
		public function update() {
			onFrameUpdate();
		}
		
				
		@:flash.property public var currentLog(get,set):DConsoleLog;
function  set_currentLog(l:DConsoleLog):DConsoleLog{
			_currentLog = l;
			showTag = _currentLog.manager.rootLog == _currentLog;
			update();
return l;
		}
function  get_currentLog():DConsoleLog {
			return _currentLog;
		}
		
		public function getMessageAtLine(line:Int):ConsoleMessage {
			var currentLogVector= currentLog.messages;
			line += _scrollIndex;
			return currentLog.messages[line];
		}
		
		public function drawMessages() {
			if (!_console.visible || _locked || currentLog == null) {
				return;
			}
			if (_atBottom) {
				_scrollIndex = maxScroll;
			}
			var currentLogVector= currentLog.messages;
			var date= Date.now();
			clear();
			_scrollRange = Std.int(Math.min(currentLogVector.length, scrollIndex + numLines));
			if (numLines > _scrollRange - scrollIndex) {
				_scrollIndex = maxScroll;
				_atBottom = true;
				_scrollRange = Std.int(Math.min(currentLogVector.length, scrollIndex + numLines));
			}
			_scrollbar.visible = numLines < currentLogVector.length;
			if (_scrollbar.visible) {
				_textOutput.width = _allotedRect.width - _scrollbar.trackWidth;
			} else {
				_textOutput.width = _allotedRect.width;
			}
			var i= scrollIndex;while (i < _scrollRange) {
				var msg= currentLogVector[i];
				var lineLength= 0;
				var lineNum= i + 1;
				if (msg.type == ConsoleMessageTypes.TRACE && !showTraceValues)
{					i++;continue;};
				var messageVisible= msg.visible;
				var fmt:TextFormat;
				textOutput.defaultTextFormat = fmt = TextFormats.outputTformatDebug;
				var lineNumStr= Std.string(lineNum);
				if (lineNum < 100) {
					lineNumStr = "0" + lineNumStr;
				}
				if (lineNum < 10) {
					lineNumStr = "0" + lineNumStr;
				}
				if (showLineNum) {
					lineLength += lineNumStr.length + 2;
					appendWithFormat("[" + lineNumStr + "]", TextFormats.outputTformatLineNo);
				}
				if (showTimeStamp) {
					fmt = messageVisible ? TextFormats.outputTformatTimeStamp : TextFormats.outputTformatHidden;
					date.setTime(msg.timestamp);
					var dateStr= " " + date.toLocaleDateString() + " " + date.toLocaleTimeString() + " ";
					lineLength += dateStr.length;
					appendWithFormat(dateStr, fmt);
				}
				if (showTag && msg.tag != "" && msg.tag != DConsole.TAG && messageVisible) {
					fmt = messageVisible ? TextFormats.outputTformatTag : TextFormats.outputTformatHidden;
					lineLength += (1 + msg.tag.length);
					appendWithFormat(" " + msg.tag, fmt);
				}
				if (msg.type == ConsoleMessageTypes.USER) {
					appendWithFormat(" < ", TextFormats.outputTformatAux);
				} else {
					appendWithFormat(" > ", TextFormats.outputTformatAux);
				}
				lineLength += 3;
				var _hooray= false;
				if (messageVisible || msg.type == ConsoleMessageTypes.USER) {
					switch (msg.type) {
						case ConsoleMessageTypes.USER:
							fmt = TextFormats.outputTformatUser;
							
						case ConsoleMessageTypes.SYSTEM:
							fmt = TextFormats.outputTformatSystem;
							
						case ConsoleMessageTypes.ERROR:
							fmt = TextFormats.outputTformatError;
							
						case ConsoleMessageTypes.WARNING:
							fmt = TextFormats.outputTformatWarning;
							
						case ConsoleMessageTypes.FATAL:
							fmt = TextFormats.outputTformatFatal;
							
						case ConsoleMessageTypes.HOORAY:
							_hooray = true;
							fmt = TextFormats.hoorayFormat;
							
						case ConsoleMessageTypes.INFO:
							fmt = TextFormats.outputTformatInfo;
							
						default:
							if (i == currentLogVector.length - 1) {
								fmt = TextFormats.outputTformatNew;
							} else {
								fmt = TextFormats.outputTformatOld;
							}
					}
				} else {
					fmt = TextFormats.outputTformatHidden;
				}
				var idx= text.length;
				var str= msg.text;
				if (msg.repeatcount > 0) {
					var str2= " x" + (msg.repeatcount + 1);
					str += str2;
				}
				
				//determine length of current line
				lineLength += str.length;
				msg.truncated = false;
				if (TRUNCATE) {
					if (lineLength * _lineMetrics.width > width) {
						//truncate
						var diff= Std.int(lineLength - (width / _lineMetrics.width));
						//str = (str.length-diff).toString()
						str = str.substr(0, Std.int(Math.max(1, (str.length - diff) - 4)));
						str += "...";
						msg.truncated = true; //flag this message as truncated for future reference
					}
				}
				
				if (i != _scrollRange - 1) {
					appendWithFormat(str + "\n", fmt);
				} else {
					appendWithFormat(str, fmt);
				}
				try {
					if (_hooray) {
						var sindex= 0;while (sindex < str.length) {
							//TODO: This is the worst thing in history. Good thing the hooray thing won't be used very much O_o
							fmt.color = Math.random() * 0xFFFFFF;
							textOutput.setTextFormat(fmt, idx + sindex, idx + sindex + str.length - sindex);
sindex++;
						}
					} else {
						//if(str.length>0) textOutput.setTextFormat(fmt, idx, idx + str.length);
						if (str.length > 0)
							textOutput.setTextFormat(fmt, idx, idx + str.length);
					}
				} catch (e:Error) {
					currentLogVector.splice(i, 1);
					_console.print(e.message, ConsoleMessageTypes.ERROR);
					_console.print("The console encountered a message draw error. Did you attempt to log a ByteArray?", ConsoleMessageTypes.ERROR);
					drawMessages();
				}
i++;
					//_logManager.currentLog.setClean();
			}
			_scrollbar.draw(_textOutput.height, _scrollIndex, maxScroll);
		}
		/**
		 * Add text to the output with a format
		 * @param	string
		 * @param	format
		 */
		@:meta(Inline())
		
		function appendWithFormat(string:String, format:TextFormat) {
			var idx= textOutput.length;
			textOutput.appendText(string);
			textOutput.setTextFormat(format, idx, textOutput.length);
		}
		
		public function clear() {
			_textOutput.text = "";
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.interfaces.IThemable */
		
		public function onThemeChange(md:MessageData) {
			var sm= cast(md.source, StyleManager);
			drawBackground();
			_scrollbar.draw(_textOutput.height, _scrollIndex, maxScroll);
			drawMessages();
		}
		
		public function scrollToBottom() {
			scrollToLine(ASCompat.MAX_INT);
		}
	
	}

