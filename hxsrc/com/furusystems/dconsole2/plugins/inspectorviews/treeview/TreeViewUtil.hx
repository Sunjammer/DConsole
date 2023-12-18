package com.furusystems.dconsole2.plugins.inspectorviews.treeview 
;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.messaging.pimp.MessageData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import com.furusystems.dconsole2.core.inspector.AbstractInspectorView;
	import com.furusystems.dconsole2.core.interfaces.IThemeable;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.core.style.Alphas;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.plugins.inspectorviews.treeview.buttons.EyeDropperButton;
	import com.furusystems.dconsole2.plugins.inspectorviews.treeview.dfs.DFS;
	import com.furusystems.dconsole2.plugins.inspectorviews.treeview.noderenderers.ListNode;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class TreeViewUtil extends AbstractInspectorView implements IRenderable implements IThemeable
	{
		var _console:IConsole;
		var _pm:PluginManager;
		
		var _root:DisplayObjectContainer;
		var _rootNode:ListNode;
		
		var _mouseSelectButton:EyeDropperButton;
		public function new() 
		{
			super("Display list");
			_mouseSelectButton = new EyeDropperButton();
			//addChild(_mouseSelectButton).y = 2; //TODO: Show button when functionality implemented
			_mouseSelectButton.addEventListener(MouseEvent.MOUSE_DOWN, activateMouseSelect);
		}
		
		function onScopeChangeComplete() 
		{
			consolidateSelection();
		}
		
		function consolidateSelection() 
		{
			if (Std.is(_pm.scopeManager.currentScope.targetObject , DisplayObject)) {
				//trace("\tIt's a display object");
				if (cast(_pm.scopeManager.currentScope.targetObject, DisplayObject).stage != null) {
					//trace("\tIt's on stage");
					if (ListNode.table[_pm.scopeManager.currentScope.targetObject] != null) {
						//trace("\tThere's a node for it");
						select(ASCompat.dynamicAs(_pm.scopeManager.currentScope.targetObject , DisplayObject));
					}else {
						//trace("\tThere is no node for it");
					}
				}
			}else {
				//trace("NEGATIVE");
				clearSelection();
			}
		}
		
		public function clearSelection() 
		{
			ListNode.clearSelections();
		}
		
		function activateMouseSelect(e:MouseEvent) 
		{
			
		}
		public function setSelection(node:ListNode) {
			select(node.displayObject);
			//scrollTo(node);
		}
		public function render()
		{
			if (_rootNode == null) return;
			var rect= inspector.dims.clone();
			rect.height -= GUIUnits.SQUARE_UNIT;
			scrollRect = rect;
			_rootNode.render();
			graphics.clear();
			graphics.beginFill(Colors.TREEVIEW_BG, Alphas.TREEVIEW_BG_ALPHA);
			graphics.drawRect(0, 0, scrollRect.width, scrollRect.height);
		}
		
		@:flash.property public var rootNode(never,set):DisplayObjectContainer;
function  set_rootNode(value:DisplayObjectContainer):DisplayObjectContainer		{
			if (_rootNode != null) {
				content.removeChild(_rootNode);
			}
			ListNode.clearTable();
			_rootNode = new ListNode(value, null, this);
			content.addChildAt(_rootNode, 0);
			render();
			scrollByDelta(0, 0);
return value;
		}
		override public function scrollByDelta(x:Float, y:Float) 
		{
			if (_rootNode == null) return;
			super.scrollByDelta(x, y);
		}
		override function  get_maxScrollY():Float {
			var rect= _rootNode.transform.pixelBounds;
			return rect.height-scrollRect.height;
		}
		override function  get_maxScrollX():Float {
			var rect= _rootNode.transform.pixelBounds;
			return rect.width-scrollRect.width;
		}
		override function calcBounds():Rectangle 
		{
			return _bounds = _rootNode.transform.pixelBounds;
		}
		override function onShow() 
		{
			populate(stage);
			consolidateSelection();
			super.onShow();
		}
		public function rebuild() {
			
		}
		public function select(target:DisplayObject) {
			//trace("Select: " + target);
			var node:ListNode;
			if (ListNode.table[target] != null) {
				//not found
				node = ListNode.table[target];
			}else {
				node = DFS.search(target, _rootNode);
			}
			//collapseAll();
			if (node == null) return;
			while (node.parentNode != null) {
				node = node.parentNode;
				node.expanded = true;
			}
			render();
			scrollTo(ListNode.table[target]);
			ListNode.table[target].selected = true;
		}
		public function collapseAll() {
			for (_tmp_ in ListNode.table) 
			{
var node:ListNode  = _tmp_;
				node.expanded = false;
			}
		}
		public function scrollTo(node:ListNode) {
			//TODO: Refine targeting; Target should be framed center
			var rect= node.getRect(this);
			var s= scrollRect;
			var diffX= rect.x - (s.x + s.width * .5);
			var diffY= (rect.y +node.firstLevelHeight * .5) - (s.y + s.height * .5);
			scrollByDelta(-diffX, -diffY);
		}
		
		public function onDisplayObjectSelected(displayObject:DisplayObject)
		{
			_pm.messaging.send(Notifications.SCOPE_CHANGE_REQUEST, displayObject, this);
		}
		override public function populate(object:ASObject) {
			if (Std.is(object , DisplayObjectContainer)) {
				rootNode = cast(object, DisplayObjectContainer);
			}
		}
		override public function resize() 
		{
			render();
			_mouseSelectButton.x = availableWidth - _mouseSelectButton.width - 2;
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.interfaces.IThemeable */
		
		public function onThemeChange(md:MessageData)
		{
			render();
			_mouseSelectButton.updateAppearance();
		}
		
		override function  get_descriptionText():String { 
			return "Adds a tree view representing the current displaylist";
		}
		override public function initialize(pm:PluginManager) 
		{
			_pm = pm;
			pm.messaging.addCallback(Notifications.THEME_CHANGED, onThemeChange);
			pm.messaging.addCallback(Notifications.SCOPE_CHANGE_COMPLETE, onScopeChangeComplete);
			_console = pm.console;
			consolidateSelection();
			_console.createCommand("searchDlByName", searchDisplayListByName, "Display", "Searches the display list for a named display object");
			super.initialize(pm);
		}
		
		function searchDisplayListByName(name:String) 
		{
			for (_tmp_ in ListNode.table) {
var dl:ListNode  = _tmp_;
				if (dl.displayObject != null&&dl.displayObject.name!=null) {
					if (dl.displayObject.name.toLowerCase() == name.toLowerCase()) {
						_pm.messaging.send(Notifications.SCOPE_CHANGE_REQUEST, dl.displayObject);
						return;
					}
				}
			}
		}
		public override function shutdown(pm:PluginManager) 
		{
			_console.removeCommand("searchDlByName");
			pm.messaging.removeCallback(Notifications.THEME_CHANGED, onThemeChange);
			pm.messaging.removeCallback(Notifications.SCOPE_CHANGE_COMPLETE, onScopeChangeComplete);
			_pm = null;
			_console = null;
			super.shutdown(pm);
		}
	}
