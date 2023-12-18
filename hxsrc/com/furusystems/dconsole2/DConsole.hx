package com.furusystems.dconsole2
;
	// { imports
	import com.furusystems.dconsole2.core.commands.CommandManager;
	import com.furusystems.dconsole2.core.commands.ConsoleCommand;
	import com.furusystems.dconsole2.core.commands.FunctionCallCommand;
	import com.furusystems.dconsole2.core.commands.IntrospectionCommand;
	import com.furusystems.dconsole2.core.DSprite;
	import com.furusystems.dconsole2.core.errors.ErrorStrings;
	import com.furusystems.dconsole2.core.gui.debugdraw.DebugDraw;
	import com.furusystems.dconsole2.core.gui.DockingGuides;
	import com.furusystems.dconsole2.core.gui.maindisplay.assistant.Assistant;
	import com.furusystems.dconsole2.core.gui.maindisplay.ConsoleView;
	import com.furusystems.dconsole2.core.gui.maindisplay.filtertabrow.FilterTabRow;
	import com.furusystems.dconsole2.core.gui.maindisplay.input.InputField;
	import com.furusystems.dconsole2.core.gui.maindisplay.output.OutputField;
	import com.furusystems.dconsole2.core.gui.maindisplay.toolbar.ConsoleToolbar;
	import com.furusystems.dconsole2.core.gui.ScaleHandle;
	import com.furusystems.dconsole2.core.gui.ToolTip;
	import com.furusystems.dconsole2.core.helpmanager.HelpManager;
	import com.furusystems.dconsole2.core.input.KeyBindings;
	import com.furusystems.dconsole2.core.input.KeyboardManager;
	import com.furusystems.dconsole2.core.input.KeyHandlerResult;
	import com.furusystems.dconsole2.core.introspection.InspectionUtils;
	import com.furusystems.dconsole2.core.introspection.IntrospectionScope;
	import com.furusystems.dconsole2.core.introspection.ScopeManager;
	import com.furusystems.dconsole2.core.logmanager.DConsoleLog;
	import com.furusystems.dconsole2.core.logmanager.DLogFilter;
	import com.furusystems.dconsole2.core.logmanager.DLogManager;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.output.ConsoleMessage;
	import com.furusystems.dconsole2.core.output.ConsoleMessageRepeatMode;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.persistence.PersistenceManager;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.core.references.ReferenceManager;
	import com.furusystems.dconsole2.core.security.ConsoleLock;
	import com.furusystems.dconsole2.core.style.StyleManager;
	import com.furusystems.dconsole2.core.text.autocomplete.AutocompleteDictionary;
	import com.furusystems.dconsole2.core.text.autocomplete.AutocompleteManager;
	import com.furusystems.dconsole2.core.text.TextUtils;
	import com.furusystems.dconsole2.core.utils.StringUtil;
	import com.furusystems.dconsole2.core.Version;
	import com.furusystems.dconsole2.logging.ConsoleLogBinding;
	import com.furusystems.logging.slf4as.Logging;
	import com.furusystems.messaging.pimp.Message;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.ui.Keyboard;

	// }

	/**
	 * ActionScript 3 logger, commandline interface and utility platform
	 * @author Andreas Roenning
	 * @author Cristobal Dabed
	 * @author Furu systems
	 */
	 class DConsole extends DSprite implements IConsole
	{

		// { members
		public var ignoreBlankLines:Bool = true;

		var _initialized:Bool = false;
		var _autoCompleteManager:AutocompleteManager;
		var _globalDictionary:AutocompleteDictionary = new AutocompleteDictionary();
		var _styleManager:StyleManager;
		var _referenceManager:ReferenceManager;
		var _scopeManager:ScopeManager;
		var _commandManager:CommandManager;
		var _toolTip:ToolTip;
		var _visible:Bool = false;
		var _isVisible:Bool = true; // TODO: Fix naming ambiguity; _isVisible refers to the native visibility toggle
		var _persistence:PersistenceManager;
		var _callCommand:FunctionCallCommand;
		var _getCommand:FunctionCallCommand;
		var _setCommand:FunctionCallCommand;
		var _selectCommand:FunctionCallCommand;
		var _quickSearchEnabled:Bool = true;
		var _repeatMessageMode:Int = ConsoleMessageRepeatMode.STACK;
		var _bgLayer:Sprite = new Sprite();
		var _topLayer:Sprite = new Sprite();
		var _consoleBackground:Sprite = new Sprite();
		var _keystroke:UInt = KeyBindings.ENTER;
		var _modifier:UInt = KeyBindings.CTRL_SHIFT;
		var _lock:ConsoleLock = new ConsoleLock();
		var _plugManager:PluginManager;
		var _logManager:DLogManager;
		var _autoCreateTagLogs:Bool = true; // If true, automatically create new logs when a new tag is encountered
		var _dockingGuides:DockingGuides;
		var _overrideCallback:ASFunction = null;
		var _cancelNextKey:Bool = false;
		var _defaultInputCallback:ASFunction;
		var _mainConsoleView:ConsoleView;
		var _debugDraw:DebugDraw;

		var _consoleContainer:Sprite;
		var _messaging:PimpCentral = new PimpCentral();

		var _trigger:UInt = Keyboard.TAB;

		var _helpManager:HelpManager;

		var _debugMode:Bool = false; // Internal debugging flag

		static public inline final DOCK_TOP= 0;
		static public inline final DOCK_BOT= 1;
		static public inline final DOCK_WINDOWED= -1;

		static public var autoComplete:Bool = true;

		// } end members
		// { Instance

		/**
		 * Creates a new DConsole instance.
		 * This class is intended to always be on top of the stage of the application it is associated with.
		 * Using the DConsole.instance getter is recommended
		 */
		public function new()
		{
			super();
			// Prepare logging
			_styleManager = new StyleManager(this);
			_persistence = new PersistenceManager(this);

			_logManager = new DLogManager(this);
			_mainConsoleView = new ConsoleView(this);

			_helpManager = new HelpManager(_messaging);

			output.currentLog = _logManager.currentLog;

			input.inputTextField.addEventListener(TextEvent.TEXT_INPUT, onTextInput);

			tabChildren = tabEnabled = false;

			_debugDraw = new DebugDraw(_messaging);

			_autoCompleteManager = new AutocompleteManager(input.inputTextField);
			_scopeManager = new ScopeManager(this, _autoCompleteManager);
			_autoCompleteManager.setDictionary(_globalDictionary);
			_referenceManager = new ReferenceManager(this, _scopeManager);
			_plugManager = new PluginManager(_scopeManager, _referenceManager, this, _topLayer, _bgLayer, _consoleBackground, _logManager);
			_commandManager = new CommandManager(this, _persistence, _referenceManager, _plugManager);
			_scopeManager.setCommandMgr(_commandManager);

			_consoleContainer = new Sprite();
			addChild(_consoleContainer);

			_consoleContainer.addChild(_debugDraw.shape);
			_consoleContainer.addChild(_bgLayer);
			_consoleContainer.addChild(_mainConsoleView);
			_consoleContainer.addChild(_topLayer);
			_dockingGuides = new DockingGuides();
			_consoleContainer.addChild(_dockingGuides);
			_toolTip = new ToolTip(this);
			_consoleContainer.addChild(_toolTip);

			input.addEventListener(Event.CHANGE, updateAssistantText);
			scaleHandle.addEventListener(Event.CHANGE, onScaleHandleDrag, false, 0, true);

			messaging.addCallback(Notifications.SCOPE_CHANGE_REQUEST, onScopeChangeRequest);
			messaging.addCallback(Notifications.EXECUTE_STATEMENT, onExecuteStatementNotification);
			messaging.addCallback(Notifications.CONSOLE_VIEW_TRANSITION_COMPLETE, onConsoleViewTransitionComplete);

			messaging.addCallback(Notifications.TOOLBAR_DRAG_START, onWindowDragStart);
			messaging.addCallback(Notifications.TOOLBAR_DRAG_STOP, onWindowDragStop);

			KeyboardManager.instance.addKeyboardShortcut(_keystroke, _modifier, toggleDisplay); // [CTRL+SHIFT, ENTER]); //default keystroke

			_callCommand = new FunctionCallCommand("call", _scopeManager.callMethodOnScope, "Introspection", "Calls a method with args within the current introspection scope");
			_setCommand = new IntrospectionCommand("set", _scopeManager.setPropertyOnObject, "Introspection", "Sets a variable within the current introspection scope");
			_getCommand = new IntrospectionCommand("get", _scopeManager.getPropertyOnObject, "Introspection", "Prints a variable within the current introspection scope");
			_selectCommand = new IntrospectionCommand("select", select, "Introspection", "Selects the specified object or reference by identifier as the current introspection scope");

			var basicHelp= "";
			basicHelp += "\tKeyboard commands\n";
			basicHelp += "\t\tControl+Shift+Enter (default) -> Show/hide console\n";
			basicHelp += "\t\tMaster key (Default TAB) -> (When out of focus) Set the keyboard focus to the input field\n";
			basicHelp += "\t\tMaster key (Default TAB) -> (While caret is on an unknown term) Context sensitive search\n";
			basicHelp += "\t\tEnter -> Execute line\n";
			basicHelp += "\t\tPage up/Page down -> Vertical scroll by page\n";
			basicHelp += "\t\tArrow up -> Recall the previous executed line\n";
			basicHelp += "\t\tArrow down -> Recall the more recent executed line\n";
			basicHelp += "\t\tShift + Arrow keys -> Scroll\n";
			basicHelp += "\t\tMouse functions\n";
			basicHelp += "\t\tMousewheel -> Vertical scroll line by line\n";
			basicHelp += "\t\tClick drag below the input line -> Change console height\n";
			basicHelp += "\t\tClick drag console header -> Move the console window\n";
			basicHelp += "\tMisc\n";
			basicHelp += "\t\tUse the 'commands' command to list available commmands";

			_helpManager.addTopic("Basic instructions", basicHelp);

			print("Welcome to Doomsday Console II - www.doomsday.no", ConsoleMessageTypes.SYSTEM);
			print("Today is " + Date.now().toString(), ConsoleMessageTypes.SYSTEM);
			print("Console version " + Version.Major + "." + Version.Minor, ConsoleMessageTypes.SYSTEM);
			print("Player version " + Capabilities.version, ConsoleMessageTypes.SYSTEM);

			setupDefaultCommands();
			setRepeatFilter(ConsoleMessageRepeatMode.STACK);

			visible = false;

			print("Ready. Type help to get started.", ConsoleMessageTypes.SYSTEM);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		function onWindowDragStop()
		{
			beginFrameUpdates();
		}

		function onWindowDragStart()
		{
			stopFrameUpdates();
		}

		function onConsoleViewTransitionComplete(md:MessageData)
		{
			// md.data will be true if the console is now visible, or false if it's now hidden
			if (!md.data)
			{
				_consoleContainer.visible = false;
			}
		}

		
		@:flash.property public static var debugDraw(get,never):DebugDraw;
static function  get_debugDraw():DebugDraw
		{
			return console.debugDraw;
		}

		public static function getLogString():String
		{
			return console.getLogString();
		}

		function onTextInput(e:TextEvent)
		{
			// if (_cancelNextSpace && e.text==" ") {
			if (_cancelNextKey)
			{
				e.preventDefault();
			}
			_cancelNextKey = false;
		}

		@:flash.property public var currentScope(get,never):IntrospectionScope;
function  get_currentScope():IntrospectionScope
		{
			return _scopeManager.currentScope;
		}

		function onExecuteStatementNotification(md:MessageData)
		{
			executeStatement(ASCompat.toString(md.data));
		}

		function onScopeChangeRequest(md:MessageData)
		{
			select(md.data);
		}

		function stopFrameUpdates()
		{
			removeEventListener(Event.ENTER_FRAME, frameUpdate);
		}

		function beginFrameUpdates()
		{
			addEventListener(Event.ENTER_FRAME, frameUpdate, false, -1000, false);
		}

		function frameUpdate(e:Event = null)
		{
			_plugManager.update();
			view.inspector.onFrameUpdate(e);
			messaging.send(Notifications.FRAME_UPDATE, null, this);
		}

		/**
		 * @readonly lock
		 */
		@:flash.property public var lock(get,never):ConsoleLock;
function  get_lock():ConsoleLock
		{
			return _lock;
		}

		/**
		 * Change keyboard shortcut
		 */
		public function changeKeyboardShortcut(keystroke:UInt, modifier:UInt)
		{
			KeyboardManager.instance.addKeyboardShortcut(keystroke, modifier, this.toggleDisplay, true);
		}

		function setupDefaultCommands()
		{
			// addCommand(new FunctionCallCommand("consoleHeight", setHeight, "View", "Change the number of lines to display. Example: setHeight 5"));
			createCommand("about", about, "System", "Credits etc");
			createCommand("clear", clear, "View", "Clear the console");

			createCommand("showTimestamps", output.toggleTimestamp, "View", "Toggle or set display of message timestamp");
			createCommand("showTags", toggleTags, "View", "Toggle or set the display of message tags");
			createCommand("showLineNumbers", output.toggleLineNumbers, "View", "Toggles or sets the display of line numbers");
			createCommand("setQuicksearch", toggleQuickSearch, "System", "Toggles or sets trigger key to search commands and methods for the current word");

			createCommand("help", getHelp, "System", "Output instructions. Append an argument to read more about that topic.");
			createCommand("clearhistory", _persistence.clearHistory, "System", "Clears the stored command history");
			createCommand("dock", setDockVerbose, "System", "Docks the console to either 'top'(default) 'bottom'/'bot' or 'window'");
			createCommand("maximizeConsole", maximize, "System", "Sets console height to fill the screen");
			createCommand("minimizeConsole", minimize, "System", "Sets console height to 1");
			createCommand("setRepeatFilter", setRepeatFilter, "System", "Sets the repeat message filter; 0 - Stack, 1 - Ignore, 2 - Passthrough");
			createCommand("repeat", repeatCommand, "System", "Repeats command string X Y times");
			addCommand(new FunctionCallCommand("resetConsole", resetConsole, "System", "Resets and clears the console"), false);

			if (Capabilities.isDebugger)
			{
				print("\tDebugplayer commands added", ConsoleMessageTypes.SYSTEM);
				createCommand("gc", System.gc, "Debugplayer", "Forces a garbage collection cycle");
			}
			if (Capabilities.playerType == "StandAlone" || Capabilities.playerType == "External")
			{
				print("\tProjector commands added", ConsoleMessageTypes.SYSTEM);
				createCommand("quitapp", quitCommand, "Projector", "Quit the application");
			}
			createCommand("plugins", _plugManager.printPluginInfo, "Plugins", "Lists enabled plugin information");

			createCommand("commands", _commandManager.listCommands, "Utility", "Output a list of available commands. Add a second argument to search.");
			createCommand("search", searchCurrentLog, "Utility", "Searches the current log for a string and scrolls to the first matching line");
			createCommand("toClipboard", toClipBoard, "Utility", "Takes value X and puts it in the system clipboard (great for grabbing command XML output)");

			addCommand(_callCommand);
			addCommand(_getCommand);
			addCommand(_setCommand);
			addCommand(_selectCommand);

			createCommand("root", _scopeManager.selectBaseScope, "Introspection", "Selects the stage as the current introspection scope");
			createCommand("parent", _scopeManager.up, "Introspection", "(if the current scope is a display object) changes scope to the parent object");
			createCommand("children", _scopeManager.printChildren, "Introspection", "Get available children in the current scope");
			createCommand("variables", _scopeManager.printVariables, "Introspection", "Get available simple variables in the current scope");
			createCommand("complex", _scopeManager.printComplexObjects, "Introspection", "Get available complex variables in the current scope");
			createCommand("scopes", _scopeManager.printDownPath, "Introspection", "List available scopes in the current scope");
			createCommand("methods", _scopeManager.printMethods, "Introspection", "Get available methods in the current scope");
			createCommand("updateScope", _scopeManager.updateScope, "Introspection", "Gets changes to the current scope tree");

			createCommand("referenceThis", _referenceManager.getReference, "Referencing", "Stores a weak reference to the current scope in a specified id (referenceThis 1)");
			createCommand("getReference", _referenceManager.getReferenceByName, "Referencing", "Stores a weak reference to the specified scope in the specified id (getReference scopename 1)");
			createCommand("listReferences", _referenceManager.printReferences, "Referencing", "Lists all stored references and their IDs");
			createCommand("clearAllReferences", _referenceManager.clearReferences, "Referencing", "Clears all stored references");
			createCommand("clearReference", _referenceManager.clearReferenceByName, "Referencing", "Clears the specified reference");

			createCommand("loadTheme", _styleManager.load, "Theme", "Loads theme xml from urls; [x] theme [y] color table");

		}

		public function setMasterKey(key:UInt)
		{
			if (key == Keyboard.ENTER)
			{
				throw new Error("The master key can not be the enter key");
			}
			_trigger = key;
		}

		// private function switchMasterKey():void
		// {
		// _masterKeyMode = !_masterKeyMode;
		// if (_masterKeyMode) {
		// addSystemMessage("Current trigger is ctrl+space");
		// }else {
		// addSystemMessage("Current trigger is space, ctrl+space overrides");
		// }
		// }

		function setDockVerbose(mode:String = "top")
		{
			mode = mode.toLowerCase();
			switch (mode)
			{
				case "bot"
				   | "bottom":
					dock(DOCK_BOT);
					
				case "none"
				   | "window":
					dock(DOCK_WINDOWED);
					
				default:
					dock(DOCK_TOP);
			}
		}

		@:flash.property var toolBar(get,never):ConsoleToolbar;
function  get_toolBar():ConsoleToolbar
		{
			return _mainConsoleView.toolbar;
		}

		@:flash.property var filterTabs(get,never):FilterTabRow;
function  get_filterTabs():FilterTabRow
		{
			return _mainConsoleView.filtertabs;
		}

		@:flash.property var output(get,never):OutputField;
function  get_output():OutputField
		{
			return _mainConsoleView.output;
		}

		public function getLogString():String
		{
			return logs.rootLog.toString();
		}

		@:flash.property var scaleHandle(get,never):ScaleHandle;
function  get_scaleHandle():ScaleHandle
		{
			return _mainConsoleView.scaleHandle;
		}

		@:flash.property var assistant(get,never):Assistant;
function  get_assistant():Assistant
		{
			return _mainConsoleView.assistant;
		}

		@:flash.property var input(get,never):InputField;
function  get_input():InputField
		{
			return _mainConsoleView.input;
		}

		function selectTag(tag:String)
		{

		}

		function toggleTags(input:String = null)
		{
			if (input == null)
			{
				view.output.showTag = !view.output.showTag;
			}
			else
			{
				view.output.showTag = StringUtil.verboseToBoolean(input);
			}
			view.output.update();
		}

		function resetConsole()
		{
			persistence.clearAll();
			view.splitRatio = persistence.verticalSplitRatio.value;
			onStageResize();
			_logManager.currentLog.clear();
			_logManager.clearFilters();
			addSystemMessage("GUI and history reset");
		}

		function about()
		{
			addSystemMessage("Doomsday Console II");
			addSystemMessage("\t\tversion " + Version.Major + "." + Version.Minor);
			addSystemMessage("\t\thttp://doomsdayconsole.googlecode.com");
			addSystemMessage("\t\tconcept and development by www.doomsday.no & www.furusystems.com");
		}

		function addSearch(term:String)
		{
			_logManager.addFilter(new DLogFilter(term));
		}

		public function searchCurrentLog(term:String)
		{
			var idx= _logManager.searchCurrentLog(term);
			if (idx > -1)
			{
				output.scrollToLine(idx);
				// print("'" + term + "' found in log "+_logManager.currentLog+" at line " + idx);
			}
			else
			{
				addErrorMessage("Not found");
			}
		}

		@:flash.property public var currentLog(get,never):DConsoleLog;
function  get_currentLog():DConsoleLog
		{
			return _logManager.currentLog;
		}

		function toClipBoard(str:String)
		{
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, str);
		}

		function getLoader(url:String):Loader
		{
			var l= new Loader();
			l.load(new URLRequest(url));
			return l;
		}

		function repeatCommand(cmd:String, count:Int = 1)
		{
			for (i in 0...count)
			{
				executeStatement(cmd);
			}
		}

		public function select(target:ASAny)
		{
			if (_scopeManager.currentScope == target)
			{
				return;
			}
			try
			{
				_scopeManager.setScopeByName(ASCompat.toString(target));
			}
			catch (e:Error)
			{
				try
				{
					_referenceManager.setScopeByReferenceKey(target);
				}
				catch (e:Error)
				{
					try
					{
						if (Std.is(target , "string"))
						{
							throw new Error();
						}
						_scopeManager.setScope(target);
					}
					catch (e:Error)
					{
						print("No such scope", ConsoleMessageTypes.ERROR);
					}
				}
			}
		}

		function toggleQuickSearch(input:String = null)
		{
			if (input == null)
			{
				setQuickSearch(!_quickSearchEnabled);
			}
			else
			{
				setQuickSearch(StringUtil.verboseToBoolean(input));
			}
		}

		function onScaleHandleDrag(e:Event)
		{
			var my:Float;
			var eh:Float = 14;
		}

		function quitCommand(code:Int = 0)
		{
			System.exit(code);
		}

		function getHelp(topic:String = "")
		{
			if (topic == "")
			{
				addSystemMessage(_helpManager.getTopic("Basic instructions"));
				addSystemMessage(_helpManager.getToc());
			}
			else
			{
				addSystemMessage(_helpManager.getTopic(topic));
			}
		}

		public function executeStatement(statement:String, echo:Bool = false):ASAny
		{
			if (echo)
				print(statement, ConsoleMessageTypes.USER);
			return _commandManager.tryCommand(statement);
		}

		function updateAssistantText(e:Event = null)
		{
			if (_overrideCallback != null)
				return;
			var cmd:ConsoleCommand = null;
			var helpText:String;
			try
			{
				cmd = _commandManager.parseForCommand(input.text);
				helpText = cmd.helpText;
			}
			catch (e:Error)
			{
				helpText = "";
			}
			var secondElement= TextUtils.parseForSecondElement(input.text);
			if (ASCompat.stringAsBool(secondElement))
			{
				if (cmd == _callCommand)
				{
					try
					{
						helpText = InspectionUtils.getMethodTooltip(_scopeManager.currentScope.targetObject, secondElement);
					}
					catch (e:Error)
					{
						helpText = cmd.helpText;
					}
				}
				else if (cmd == _setCommand || cmd == _getCommand)
				{
					try
					{
						helpText = InspectionUtils.getAccessorTooltip(_scopeManager.currentScope.targetObject, secondElement);
					}
					catch (e:Error)
					{
						helpText = cmd.helpText;
					}
				}
			}
			if (helpText != "")
			{
				assistant.text = "?\t" + cmd.trigger + ": " + helpText;
			}
			else
			{
				assistant.clear();
			}
		}

		public function setScope(o:ASObject)
		{
			_scopeManager.setScope(o);
		}

		public function createCommand(triggerPhrase:String, func:ASFunction, commandGroup:String = "Application", helpText:String = "")
		{
			addCommand(new FunctionCallCommand(triggerPhrase, func, commandGroup, helpText));
		}

		/**
		 * Add a custom command to the console
		 * @param	command
		 * An instance of FunctionCallCommand or ConsoleEventCommand
		 */
		public function addCommand(command:ConsoleCommand, includeInHistory:Bool = true)
		{
			try
			{
				_commandManager.addCommand(command, includeInHistory);
				_globalDictionary.addToDictionary(command.trigger);
			}
			catch (e:ArgumentError)
			{
				print(e.message, ConsoleMessageTypes.ERROR);
			}
		}

		public function removeCommand(trigger:String)
		{
			_commandManager.removeCommand(trigger);
		}

		/**
		 * A generic function to add as listener to events you want logged
		 * @param	e
		 */
		public function onEvent(e:Event)
		{
			print("Event: " + e.toString(), ConsoleMessageTypes.INFO);
		}

		function createMessages(str:String, type:String, tag:String):Vector<ConsoleMessage>
		{
			var out= new Vector<ConsoleMessage>();
			var split:Array<ASAny> = (cast str.split("\n").join("\r").split("\r"));
			if (split.join("").length < 1 && ignoreBlankLines)
				return out;
			var date= Std.string(Date.now().getTime());
			var msg:ConsoleMessage;
			var i= 0;while (i < split.length)
			{
				var txt:String = split[i];
				if (txt.length < 1 && ignoreBlankLines)
{					i++;continue;};
				if (txt.indexOf("com.furusystems.dconsole2") > -1 || txt.indexOf("adobe.com/AS3") > -1)
{					i++;continue;};
				msg = new ConsoleMessage(txt, date, type, tag);
				out.push(msg);
i++;
			}
			return out;
		}

		public function createTypeFilter(type:String)
		{
			_logManager.addFilter(new DLogFilter("", type));
		}

		public function createSearchFilter(term:String)
		{
			_logManager.addFilter(new DLogFilter(term));
		}

		public function printTo(targetLog:String, str:String, type:String = ConsoleMessageTypes.INFO, tag:String = "")
		{
			var log= _logManager.getLog(targetLog);
			var messages= createMessages(str, type, tag);
		}

		/**
		 * Add a message to the current console tab
		 * @param	str
		 * The string to be added. A timestamp is automaticaly prefixed
		 */
		public function print(str:String, type:String = ConsoleMessageTypes.INFO, tag:String = TAG)
		{
			// TODO: Per message, examine filters and append relevant messages to the relevant logs
			var _tagLog:DConsoleLog = null;
			if (tag != TAG && _autoCreateTagLogs)
			{
				_tagLog = _logManager.getLog(tag);
			}
			var _rootLog= _logManager.rootLog;
			var messages= createMessages(str, type, tag);
			var msg:ConsoleMessage;
			var i= 0;while (i < messages.length)
			{
				// break;
				msg = messages[i];
				if (_rootLog.prevMessage != null)
				{
					if (_rootLog.prevMessage.text == msg.text && _rootLog.prevMessage.tag == msg.tag && _rootLog.prevMessage.type == msg.type)
					{
						switch (_repeatMessageMode)
						{
							case ConsoleMessageRepeatMode.STACK:
								_rootLog.prevMessage.repeatcount++;
								_rootLog.prevMessage.timestamp = msg.timestamp;
								_rootLog.setDirty();
								if (_tagLog != null)
								{
									_tagLog.setDirty();
								}
								i++;continue;
								
							case ConsoleMessageRepeatMode.IGNORE:
								i++;continue;
								
						}
					}
				}
				if (msg.type != ConsoleMessageTypes.USER)
				{
					var evt:Message;
					if (msg.type == ConsoleMessageTypes.ERROR)
					{
						evt = Notifications.ERROR;
					}
					else
					{
						evt = Notifications.NEW_CONSOLE_OUTPUT;
					}
					messaging.send(evt, msg, this);
				}
				_rootLog.addMessage(msg);
				if (_tagLog != null)
					_tagLog.addMessage(msg);
i++;
			}
			output.update();
		}

		/**
		 * Clear the console
		 */
		public function clear()
		{
			_logManager.currentLog.clear();
			output.drawMessages();
		}

		function setupStageAlignAndScale()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			print("StageAlign set to TOP_LEFT, StageScaleMode set to NO_SCALE", ConsoleMessageTypes.SYSTEM);
		}

		function onAddedToStage(e:Event)
		{
			// branching for air
			is_air = Capabilities.playerType == "Desktop";

			Logging.logBinding = new ConsoleLogBinding();
			KeyboardManager.instance.setup(stage);
			if (stage.align != StageAlign.TOP_LEFT)
			{
				print("Warning: stage.align is not set to TOP_LEFT; This might cause scaling issues", ConsoleMessageTypes.ERROR);
				print("Fix: stage.align = StageAlign.TOP_LEFT;", ConsoleMessageTypes.DEBUG);
			}
			if (stage.scaleMode != StageScaleMode.NO_SCALE)
			{
				print("Warning: stage.scaleMode is not set to NO_SCALE; This might cause scaling issues", ConsoleMessageTypes.ERROR);
				print("Fix: stage.scaleMode = StageScaleMode.NO_SCALE;", ConsoleMessageTypes.DEBUG);
			}

			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, ASCompat.MAX_INT);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, ASCompat.MAX_INT);

			stage.addEventListener(Event.RESIZE, onStageResize);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_scopeManager.selectBaseScope();

			view.setHeaderText("Doomsday Console " + Version.Major + "." + Version.Minor);

			onStageResize(e);
		}

		function onStageResize(e:Event = null)
		{
			_mainConsoleView.consolidateView();
			_dockingGuides.resize();
		}

		public function stackTrace()
		{
			var e= new Error();
			var s= e.getStackTrace();
			var split:Array<ASAny> = (cast s.split("\n"));
			split.shift();
			s = "Stack trace: \n\t" + split.join("\n\t");
			print(s, ConsoleMessageTypes.INFO);
		}

		function doSearch(searchString:String, includeAccessors:Bool = false, includeCommands:Bool = true, includeScopeMethods:Bool = false):Vector<String>
		{
			var outResult= new Vector<String>();
			if (searchString.length < 1)
				return outResult;
			var found= false;
			var result:Vector<String>;
			var maxrow= 4;
			if (includeScopeMethods)
			{
				result = _scopeManager.doSearch(searchString, ScopeManager.SEARCH_METHODS);
				outResult = outResult.concat(result);
				var out= "";
				var count= 0;
				if (result.length > 0)
				{
					print("Scope methods matching '" + searchString + "'", ConsoleMessageTypes.SYSTEM);
					var i= 0;while (i < result.length)
					{
						out += result[i] + " ";
						count++;
						if (count > maxrow)
						{
							count = 0;
							print(out, ConsoleMessageTypes.INFO);
							out = "";
						}
i++;
					}
					if (out != "")
						print(out, ConsoleMessageTypes.INFO);
					found = true;
				}
			}
			if (includeCommands)
			{
				result = _commandManager.doSearch(searchString);
				outResult = outResult.concat(result);
				var count :ASAny= 0;
				var out :ASAny= "";
				var i= 0;
				if (result.length > 0)
				{
					print("Commands matching '" + searchString + "'", ConsoleMessageTypes.SYSTEM);
					i = 0;while (i < result.length)
					{
						out += "\t" + result[i] + " ";
						count++;
						if (count > maxrow)
						{
							count = 0;
							print(out, ConsoleMessageTypes.INFO);
							out = "";
						}
i++;
					}
					if (out != "")
						print(out, ConsoleMessageTypes.INFO);
					found = true;
				}
			}
			if (includeAccessors)
			{
				result = _scopeManager.doSearch(searchString, ScopeManager.SEARCH_ACCESSORS);
				outResult = outResult.concat(result);
				var count :ASAny= 0;
				var out :ASAny= "";
				var i= 0;
				if (result.length > 0)
				{
					print("Scope accessors matching '" + searchString + "'", ConsoleMessageTypes.SYSTEM);
					i = 0;while (i < result.length)
					{
						out += result[i] + " ";
						count++;
						if (count > maxrow)
						{
							count = 0;
							print(out, ConsoleMessageTypes.INFO);
							out = "";
						}
i++;
					}
					if (out != "")
						print(out, ConsoleMessageTypes.INFO);
					found = true;
				}
			}
			result = _scopeManager.doSearch(searchString, ScopeManager.SEARCH_CHILDREN);
			outResult = outResult.concat(result);
			var count :ASAny= 0;
			var out :ASAny= "";
			var i= 0;
			if (result.length > 0)
			{
				print("Children matching '" + searchString + "'", ConsoleMessageTypes.SYSTEM);
				i = 0;while (i < result.length)
				{
					out += result[i] + " ";
					count++;
					if (count > maxrow)
					{
						count = 0;
						print(out, ConsoleMessageTypes.INFO);
						out = "";
					}
i++;
				}
				if (out != "")
					print(out, ConsoleMessageTypes.INFO);
				found = true;
			}
			// if (!found) {
			// TODO: Do we really need this junk feedback?
			// print("No matches for '" + searchString + "'",ConsoleMessageTypes.ERROR);
			// }
			return outResult;

		}

		@:flash.property var currentMessageLogVector(get,never):Vector<ConsoleMessage>;
function  get_currentMessageLogVector():Vector<ConsoleMessage>
		{
			return _logManager.currentLog.messages;
		}

		public static function refresh()
		{
			console.refresh();
		}

		public function show()
		{
			if (stage == null)
				return;
			if (!visible)
				toggleDisplay();
		}

		public function hide()
		{
			if (stage == null)
				return;
			if (visible)
				toggleDisplay();
		}

		override function  get_visible():Bool
		{
			return _visible;
		}

		override function  set_visible(value:Bool):Bool		{
			_visible = value;
			if (_visible)
			{
				_consoleContainer.visible = true;
				view.show();
			}
			else
				view.hide();
return value;
		}

		
		@:flash.property public var isVisible(get,set):Bool;
function  set_isVisible(b:Bool):Bool		{
			_isVisible = b;
			super.visible = _isVisible;
return b;
		}
function  get_isVisible():Bool
		{
			return _isVisible;
		}

		public function toggleDisplay()
		{
			// Return if locked
			if (lock.locked)
			{
				return;
			}

			visible = !visible;
			var i:Int;
			var bounds= _persistence.rect;
			if (visible)
			{
				if (!_initialized)
				{
					initialize();
				}
				if (parent != null)
				{
					parent.addChild(this);
				}
				tabOrderOff();
				input.focus();
				input.text = "";
				updateAssistantText();
				beginFrameUpdates();
				messaging.send(Notifications.CONSOLE_SHOW, null, this);
			}
			else
			{
				tabOrderOn();
				stopFrameUpdates();
				messaging.send(Notifications.CONSOLE_HIDE, null, this);
			}
		}

		function tabOrderOn()
		{
			if (parent != null)
			{
				parent.tabChildren = parent.tabEnabled = _prevTabSettings;
			}
		}

		function tabOrderOff()
		{
			if (parent != null)
			{
				_prevTabSettings = parent.tabChildren;
				parent.tabChildren = parent.tabEnabled = false;
			}
		}

		function initialize()
		{
			_initialized = true;
			if (!_styleManager.themeLoaded)
			{
				_styleManager.load();
			}
			_mainConsoleView.consolidateView();
		}

		override function  get_height():Float
		{
			return _mainConsoleView.height;
		}

		override function  set_height(value:Float):Float		{
			return _mainConsoleView.height = value;
		}

		override function  get_width():Float
		{
			return _mainConsoleView.rect.width;
		}

		override function  set_width(value:Float):Float		{
			return _mainConsoleView.width = value;
		}

		public function setQuickSearch(newvalue:Bool = true)
		{
			_quickSearchEnabled = newvalue;
			print("Quick-searching: " + _quickSearchEnabled, ConsoleMessageTypes.SYSTEM);
		}

		// minmaxing size
		public function maximize()
		{
			if (stage == null)
				return;
			_mainConsoleView.maximize();
		}

		public function minimize()
		{
			_mainConsoleView.minimize();
		}

		// keyboard event handlers

		function onKeyUp(e:KeyboardEvent)
		{
			KeyboardManager.instance.handleKeyUp(e);
			if (visible)
			{
				var cmd= "";
				var _testCmd= false;
				if (e.keyCode == Keyboard.UP)
				{
					if (!e.shiftKey)
					{
						cmd = _persistence.historyUp();
						_testCmd = true;
					}
					else
					{
						return;
					}

				}
				else if (e.keyCode == Keyboard.DOWN)
				{
					if (!e.shiftKey)
					{
						cmd = _persistence.historyDown();
						_testCmd = true;
					}
					else
					{
						return;
					}
				}
				if (_testCmd)
				{
					input.text = cmd;
					input.focus();
					var spaceIndex= input.text.indexOf(" ");

					if (spaceIndex > -1)
					{
						input.inputTextField.setSelection(input.text.indexOf(" ") + 1, input.text.length);
					}
					else
					{
						input.inputTextField.setSelection(0, input.text.length);
					}
					updateAssistantText();
				}
			}
		}

		function keyHandler(e:KeyboardEvent):KeyHandlerResult
		{
			var out= keyhandlerResult;
			out.reset();
			var triggered= e.keyCode == _trigger;
			if (stage.focus == input.inputTextField)
			{
				if (!e.shiftKey && triggered)
				{
					out.swallowEvent = true;
					out.autoCompleted = doComplete();
					if (out.autoCompleted)
					{
						if (shouldCancel(e.keyCode))
						{
							cancelKey(e);
						}
					}
					return out;
				}
			}
			else
			{
				if (triggered)
				{
					input.focus();
					out.swallowEvent = true;
					return out;
				}
			}
			if (e.keyCode == Keyboard.ESCAPE)
			{
				if (_overrideCallback != null)
				{
					clearOverrideCallback();
				}
				messaging.send(Notifications.ESCAPE_KEY, null, this);
				out.swallowEvent = true;
				return out;
			}
			if (e.shiftKey)
			{
				switch (e.keyCode)
				{
					case Keyboard.UP:
						output.scroll(1);
						out.swallowEvent = true;
						return out;
					case Keyboard.DOWN:
						output.scroll(-1);
						out.swallowEvent = true;
						return out;
					case Keyboard.LEFT:
						// TODO: previous tab
						
					case Keyboard.RIGHT:
						// TODO: next tab
						
				}
			}
			if (e.keyCode == Keyboard.ENTER && stage.focus == input.inputTextField)
			{
				out.swallowEvent = true;
				if (input.text.length < 1)
				{
					// input.focus();
					return out;
				}
				var success= false;
				var passToDefault= false;
				var errorMessage= "";
				print(input.text, ConsoleMessageTypes.USER);
				if (_overrideCallback != null)
				{
					_overrideCallback(input.text);
					success = true;
				}
				else
				{
					try
					{
						var attempt:ASAny = executeStatement(input.text);
						success = true;
					}
					catch (error:com.furusystems.dconsole2.core.errors.ConsoleAuthError)
					{
						// TODO: This needs a more graceful solution. Dual auth error prints = lame
					}
					catch (error:ArgumentError)
					{
						switch (error.message)
						{
							case ErrorStrings.STRING_PARSE_ERROR_TERMINATION:
								passToDefault = true;
								
						}
						errorMessage = error.message;
					}
					catch (error:com.furusystems.dconsole2.core.errors.CommandError)
					{
						passToDefault = true;
						errorMessage = error.message;
					}
					catch (error:Error)
					{
						print(error.message, ConsoleMessageTypes.ERROR);
					}
				}
				if (passToDefault && _defaultInputCallback != null)
				{
					var ret:ASAny = _defaultInputCallback(input.text);
					if (ret)
					{
						print(ret, ConsoleMessageTypes.INFO);
					}
				}
				else
				{
					print(errorMessage, ConsoleMessageTypes.ERROR);
				}
				output.scrollToBottom();
				input.clear();
				updateAssistantText();
				out.swallowEvent = true;
			}
			else if (e.keyCode == Keyboard.PAGE_DOWN)
			{
				output.scroll(-output.numLines);
				out.swallowEvent = true;
			}
			else if (e.keyCode == Keyboard.PAGE_UP)
			{
				output.scroll(output.numLines);
				out.swallowEvent = true;
			}
			else if (e.keyCode == Keyboard.HOME)
			{
				output.scrollIndex = 0;
				out.swallowEvent = true;
			}
			else if (e.keyCode == Keyboard.END)
			{
				output.scrollIndex = output.maxScroll;
				out.swallowEvent = true;
			}
			else if (e.keyCode == Keyboard.SPACE)
			{
				out.swallowEvent = true;
			}
			return out;
		}

		function onKeyDown(e:KeyboardEvent)
		{
			KeyboardManager.instance.handleKeyDown(e);
			if (!visible)
				return; // Ignore if invisible
			if (e.keyCode == Keyboard.TAB)
				stage.focus = input.inputTextField; // why?
			var result= keyHandler(e);
			if (result.swallowEvent)
			{
				if (is_air)
				{
					if (!result.autoCompleted)
					{
						if (e.keyCode == Keyboard.SPACE)
						{
							view.input.insertAtCaret(" ");
						}
					}
					else
					{
						input.moveCaretToEnd();
					}
				}

				e.stopImmediatePropagation();
				e.stopPropagation();
				e.preventDefault();
			}
		}

		function shouldCancel(keyCode:UInt):Bool
		{
			return keyCode >= 13 || keyCode == Keyboard.SPACE;
		}

		function cancelKey(e:KeyboardEvent)
		{
			if (is_air)
				return;
			_cancelNextKey = true;
			e.stopPropagation();
		}

		/**
		 * Sets the handling method for repeated messages with identical values
		 * @param	filter
		 * One of the 3 modes described in the no.doomsday.console.core.output.MessageRepeatMode enum
		 */
		public function setRepeatFilter(filter:Int)
		{
			switch (filter)
			{
				case ConsoleMessageRepeatMode.IGNORE:
					print("Repeat mode: Repeated messages are now ignored", ConsoleMessageTypes.SYSTEM);
					
				case ConsoleMessageRepeatMode.ALLOW:
					print("Repeat mode: Repeated messages are now allowed", ConsoleMessageTypes.SYSTEM);
					
				case ConsoleMessageRepeatMode.STACK:
					print("Repeat mode: Repeated messages are now stacked", ConsoleMessageTypes.SYSTEM);
					
				default:
					throw new Error("Unknown filter type");
			}
			_repeatMessageMode = filter;
		}

		function doComplete():Bool
		{
			if (!DConsole.autoComplete)
				return false;
			var flag= false;

			if (input.text.length < 1 || _overrideCallback != null)
				return false;

			var word= input.wordAtCaret;

			var isFirstWord= input.text.lastIndexOf(word) < 1;
			var firstWord:String;
			if (isFirstWord)
			{
				firstWord = word;
			}
			else
			{
				firstWord = input.firstWord;
			}
			var wordKnown:Bool;
			wordKnown = _autoCompleteManager.isKnown(word, !isFirstWord, isFirstWord);
			var wordIndex= input.firstIndexOfWordAtCaret;
			if (wordKnown || !Math.isNaN(ASCompat.toNumber(word)))
			{
				// this word is okay, so accept the completion
				// is there currently a selection?
				if (input.inputTextField.selectedText.length > 0)
				{
					input.moveCaretToIndex(input.selectionBeginIndex);
					wordIndex = input.selectionBeginIndex;
				}
				else if (input.text.charAt(input.caretIndex) == " " && input.caretIndex != input.text.length - 1)
				{
					// input.moveCaretToIndex(input.caretIndex - 1);
				}

				word = input.wordAtCaret;
				wordIndex = input.caretIndex;

				// case correction
				var temp= input.text;
				try
				{
					temp = StringTools.replace(temp, word, _autoCompleteManager.correctCase(word));
					input.text = temp;
				}
				catch (e:Error)
				{
				}

				// is there a word after the current word?
				if (wordIndex + word.length < input.text.length - 1)
				{
					input.moveCaretToIndex(wordIndex + word.length);
					input.selectWordAtCaret();
				}
				else
				{
					// if it's the last word
					if (input.text.charAt(input.text.length - 1) != " ")
					{
						input.inputTextField.appendText(" ");
					}
					input.moveCaretToEnd();
				}
				return true;
			}
			else
			{
				if (_quickSearchEnabled)
				{
					var getSet= (firstWord == _getCommand.trigger || firstWord == _setCommand.trigger);
					var call= (firstWord == _callCommand.trigger);
					var select= (firstWord == _selectCommand.trigger);
					var searchResult= doSearch(word, !isFirstWord || select, isFirstWord, call);
					if (searchResult.length == 1)
					{
						if (searchResult[0].indexOf(word) == 0)
						{
							input.selectWordAtCaret();
							input.inputTextField.replaceSelectedText(searchResult[0] + " ");
							input.moveCaretToIndex(wordIndex + searchResult[0].length + 1);
							return true;
						}
					}
					else if (searchResult.length > 1)
					{
						input.moveCaretToEnd();
						return true;
					}
				}
				if (flag)
				{
					input.selectWordAtCaret();
				}
				else
				{
					// input.moveCaretToIndex(input.firstIndexOfWordAtCaret + input.wordAtCaret.length);
				}
				return false;
			}
		}

		
		/**
		 * Get the singleton console view display object
		 */
		@:flash.property public var view(get,never):ConsoleView;
function  get_view():ConsoleView
		{
			return _mainConsoleView;
		}

		@:flash.property public var logs(get,never):DLogManager;
function  get_logs():DLogManager
		{
			return _logManager;
		}

		
		@:flash.property public var defaultInputCallback(get,set):ASFunction;
function  get_defaultInputCallback():ASFunction
		{
			return _defaultInputCallback;
		}
function  set_defaultInputCallback(value:ASAny):ASAny		{
			if (value == null)
			{
				_defaultInputCallback = null;
				return value;
			}
			if (value.length != 1)
				throw new Error("Default input callback must take exactly one argument");
			_defaultInputCallback = value;
return value;
		}

		public function lockOutput()
		{
			output.lockOutput();
		}

		public function unlockOutput()
		{
			output.unlockOutput();
		}

		public function loadStyle(themeURI:String = null, colorsURI:String = null)
		{
			_styleManager.load(themeURI, colorsURI);
		}

		@:flash.property public var scopeManager(get,never):ScopeManager;
function  get_scopeManager():ScopeManager
		{
			return _scopeManager;
		}

		@:flash.property public var persistence(get,never):PersistenceManager;
function  get_persistence():PersistenceManager
		{
			return _persistence;
		}

		@:flash.property public var pluginManager(get,never):PluginManager;
function  get_pluginManager():PluginManager
		{
			return _plugManager;
		}

		public function setHeaderText(title:String)
		{
			_mainConsoleView.toolbar.setTitle(title);
		}

		public function setOverrideCallback(callback:ASFunction)
		{
			addSystemMessage("Override callback active, hit ESC to resume normal ops");
			_overrideCallback = callback;
		}

		public function clearOverrideCallback()
		{
			addSystemMessage("Override callback cleared");
			_overrideCallback = null;
		}
		// }

		// { Statics

		/**
		 * If true, the console instance cannot be selected by the console. The default is true, which is recommended.
		 */
		public static var CONSOLE_SAFE_MODE:Bool = true;

		/**
		 * If true, the stage can't be selected by the console. The default is true, because Stage properties behave strangely when rapidly messed with.
		 * Need to examine this further.
		 */
		public static var STAGE_SAFE_MODE:Bool = true;

		public static function stackTrace()
		{
			console.stackTrace();
		}

		/**
		 * Removes the default input callback
		 * @see setDefaultInputCallback
		 */
		public static function clearDefaultInputCallback()
		{
			console.defaultInputCallback = null;
		}

		/**
		 * Declares a default input callback
		 * This callback will receive any input the console doesn't understand
		 * @param	callback
		 */
		public static function setDefaultInputCallback(callback:ASAny)
		{
			if (callback.length != 1)
				throw new Error("The default input callback must accept exactly 1 string argument");
			console.defaultInputCallback = callback;
		}

		static var _instance:DConsole;
		static var keyboardShortcut:Array<ASAny> = [];
		var _prevTabSettings:Bool = false;
		var is_air:Bool = false;
		var keyhandlerResult:KeyHandlerResult = new KeyHandlerResult(); // reuse same instance YESSss

		/**
		 * The internal tag used as the defalt for logging
		 */
		public static inline final TAG= "DConsole";

		
		@:flash.property public static var ignoreBlankLines(get,set):Bool;
static function  get_ignoreBlankLines():Bool
		{
			return cast(console, DConsole).ignoreBlankLines;
		}
static function  set_ignoreBlankLines(b:Bool):Bool		{
			return cast(console, DConsole).ignoreBlankLines = b;
		}

		/**
		 * Returns the object currently selected as the console scope
		 * @return An object
		 * @see select
		 */
		public static function getCurrentTarget():ASObject
		{
			return Std.downcast(console , DConsole).scopeManager.currentScope.targetObject;
		}

		/**
		 * Get the singleton IConsole instance
		 */
		@:flash.property public static var console(get,never):IConsole;
static function  get_console():IConsole
		{
			if (_instance == null)
			{
				_instance = new DConsole();
				if (keyboardShortcut.length > 0)
				{
					console.changeKeyboardShortcut(keyboardShortcut[0], keyboardShortcut[1]);
				}
			}
			return _instance;
		}

		/**
		 * Sets the console title bar text
		 * @param	title
		 */
		public static function setTitle(title:String)
		{
			console.setHeaderText(title);
		}
static function  get_view():DisplayObject
		{
			return ASCompat.reinterpretAs(console , DisplayObject);
		}

		/**
		 * Adds a message
		 * @param	msg
		 * The text to output
		 * @param	type
		 * The message type, one of the options available in ConsoleMessageTypes
		 * @param	tag
		 * The string tag for identifying the source or topic of this message
		 */
		public static function print(msg:String, type:String = ConsoleMessageTypes.INFO, tag:String = TAG)
		{
			console.print(msg, type, tag);
		}

		/**
		 * Add a message with system color coding
		 * @param	msg
		 * @param	tag
		 * The string tag for identifying the source or topic of this message
		 */
		public static function addSystemMessage(msg:String, tag:String = TAG)
		{
			console.print(msg, ConsoleMessageTypes.SYSTEM, tag);
		}

		/**
		 * Add a message with warning color coding
		 * @param	msg
		 * @param	tag
		 * The string tag for identifying the source or topic of this message
		 */
		public static function addWarningMessage(msg:String, tag:String = TAG)
		{
			console.print(msg, ConsoleMessageTypes.WARNING, tag);
		}

		/**
		 * Add a message with error color coding
		 * @param	msg
		 * @param	tag
		 * The string tag for identifying the source or topic of this message
		 */
		public static function addErrorMessage(msg:String, tag:String = TAG)
		{
			console.print(msg, ConsoleMessageTypes.ERROR, tag);
		}

		/**
		 * Add a message with ridiculous random color coding.
		 * For the love of god and all that is holy, use sparingly if at all!
		 * @param	msg
		 * @param	tag
		 * The string tag for identifying the source or topic of this message
		 */
		public static function addHoorayMessage(msg:String, tag:String = TAG)
		{
			console.print(msg, ConsoleMessageTypes.HOORAY, tag);
		}

		/**
		 * Add a message with fatal error color coding (incredibly vile)
		 * @param	msg
		 * @param	tag
		 * The string tag for identifying the source or topic of this message
		 */
		public static function addFatalMessage(msg:String, tag:String = TAG)
		{
			console.print(msg, ConsoleMessageTypes.FATAL, tag);
		}

		/**
		 * Create a command for calling a specific function
		 * @param	triggerPhrase
		 * The trigger word for the command
		 * @param	func
		 * The function to call
		 * @param	category
		 * Optional: The group name you want the command sorted under
		 * @param	helpText
		 * Optional: Any text you want displayed in the assistant when this command is being typed
		 */
		public static function createCommand(triggerPhrase:String, func:ASFunction, category:String = "Application", helpText:String = "")
		{
			console.createCommand(triggerPhrase, func, category, helpText);
		}

		/**
		 * Removes a command keyed by its trigger phrase
		 * @param	triggerPhrase
		 */
		public static function removeCommand(triggerPhrase:String)
		{
			console.removeCommand(triggerPhrase);
		}

		/**
		 * Use this to print event messages on dispatch
		 * (addEventListener(Event.CHANGE, ConsoleUtil.onEvent))
		 */
		@:flash.property public static var onEvent(get,never):ASFunction;
static function  get_onEvent():ASFunction
		{
			return console.onEvent;
		}

		/**
		 * Clear the console log(s)
		 */
		@:flash.property public static var clear(get,never):ASFunction;
static function  get_clear():ASFunction
		{
			return console.clear;
		}
function  get_debugDraw():DebugDraw
		{
			return _debugDraw;
		}

		/**
		 * Registers plugins and plugin bundles by their class types
		 * A plugin is an implementor of any interface deriving from IDConsolePlugin
		 * A plugin bundle is an implementor of IPluginBundle
		 * @param	...args
		 * @example
		 * The following code shows the BasicPlugins bundle being registered, alongside the JSRouterUtil plugin
		 * <listing>
		 * DConsole.registerPlugins(AllPlugins,JSRouterUtil);
		 * </listing>
		 */
		public static function registerPlugins(args:Array<ASAny> = null)
		{
if (args == null) args = [];
			var i= 0;while (i < args.length)
			{
				Std.downcast(console , DConsole).pluginManager.registerPlugin(args[i]);
i++;
			}
		}

		/**
		 * Sets the specified object as the console's current scope
		 * @param	object
		 * @see getCurrentTarget
		 */
		public static function select(object:ASObject)
		{
			console.select(object);
		}

		/**
		 * Show the console
		 * @see hide
		 */
		public static function show()
		{
			console.show();
		}

		/**
		 * Hide the console
		 * @see show
		 */
		public static function hide()
		{
			console.hide();
		}

		/**
		 * Execute a console command statement
		 * @param	statement
		 * The statement, eg. "setFrameRate 60" etc
		 * @param	echo
		 * Wether to echo this statement in the console (default false)
		 * @return
		 * The return value of the executed statement, if any.
		 */
		public static function executeStatement(statement:String, echo:Bool = false):ASAny
		{
			return console.executeStatement(statement, echo);
		}

		/**
		 * Set keyboard shortcut
		 *
		 * @param keystroke	The keystroke
		 * @param modifier	The modifier
		 */
		public static function setKeyboardShortcut(key:UInt, modifier:UInt):Bool
		{
			var success= false;
			/*
			 * If is a valid keyboard shortcut
			 *
			 * 1. If the console is not initialized store for later, and modify after creation.
			 * 2. If the console is initialized call instance.changeKeyboardShortcut
			 */
			if (KeyboardManager.instance.validateKeyboardShortcut(key, modifier))
			{
				if (_instance == null)
				{
					keyboardShortcut = [key, modifier];
				}
				else
				{
					console.changeKeyboardShortcut(key, modifier);
				}
				success = true;
			}
			return success;
		}

		/**
		 * Change keyboard shortcut.
		 *
		 * @param keystroke	The key
		 * @param modifier	The modifier
		 */
		static function changeKeyboardShortcut(key:UInt, modifier:UInt)
		{
			console.changeKeyboardShortcut(key, modifier);
		}

		/**
		 * Declares an overriding callback for all console input
		 * While active, regular console input behavior will cease, and all text input will be passed to the specified callback
		 * @param	callback
		 */
		static public function setOverrideCallback(callback:ASFunction)
		{
			console.setOverrideCallback(callback);
		}

		/**
		 * Removes the overriding callback set in setOverrideCallback
		 * @see setOverrideCallback
		 */
		static public function clearOverrideCallback()
		{
			console.clearOverrideCallback();
		}

		/**
		 * Resets all persistent data (command history, console position, docking etc)
		 */
		static public function clearPersistentData()
		{
			cast(console, DConsole).persistence.clearAll();
		}

		/**
		 * Set the console's docking state
		 * @param	mode one of the DOCK_* static constants on DConsole
		 */
		public static function dock(mode:Int)
		{
			console.view.dockingMode = mode;
		}

		public function setTheme(colors:compat.XML, theme:compat.XML)
		{
			_styleManager.setThemeXML(colors, theme);
		}

		public function getTheme():Array<ASAny>
		{
			return [_styleManager.colorXML, _styleManager.themeXML];
		}

		/**
		 * Lock
		 *
		 * @param secret The secret to lock the console with.
		 */
		public static function setMagicWord(secret:String)
		{
			cast(console, DConsole)._lock.lockWithKeycodes(KeyBindings.toCharCodes(secret), cast(console, DConsole).toggleDisplay);
		}

		/**
		 * Lock with keyCodes
		 *
		 * @param keyCodes The keyCodes to lock the console with.
		 */
		public static function setMagicSequence(keyCodes:Array<ASAny>)
		{
			cast(console, DConsole)._lock.lockWithKeycodes(keyCodes, cast(console, DConsole).toggleDisplay);
		}

		public static function setMasterKey(key:UInt)
		{
			cast(console, DConsole).setMasterKey(key);
		}

		/* INTERFACE com.furusystems.dconsole2.IConsole */

		public function refresh()
		{
			scopeManager.updateScope();
		}

		public function getPluginInstance(type:Class<Dynamic>):IDConsolePlugin
		{
			return pluginManager.getPluginByType(type);
		}

		@:flash.property public var messaging(get,never):PimpCentral;
function  get_messaging():PimpCentral
		{
			return _messaging;
		}
	}

