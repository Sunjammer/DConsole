package com.furusystems.dconsole2.plugins.inspectorviews.treeview.noderenderers
;
	import com.furusystems.dconsole2.core.style.TextColors;
	import com.furusystems.dconsole2.core.style.TextFormats;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;
	import com.furusystems.dconsole2.core.gui.AbstractButton;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.dconsole2.plugins.inspectorviews.treeview.buttons.*;
	import com.furusystems.dconsole2.plugins.inspectorviews.treeview.TreeViewUtil;
	
	 final class ListNode extends Sprite implements INodeRenderer
	{
		public static var table:ASDictionary<ASAny,ASAny> = new ASDictionary(true);
		static var lastSelected:ListNode = null;
		
		var displayObjectReference:ASDictionary<ASAny,ASAny> = new ASDictionary(true);
		var _labelField:TextField;
		var _name:String;
		var _selected:Bool = false;
		var _selectedOverlay:Shape;
		var childContainer:Sprite = new Sprite();
		var _firstLevelHeight:Float = 0;
		
		public var parentNode:ListNode;
		public var expanded:Bool = false;
		public var treeView:TreeViewUtil;
		public var childNodes:Vector<ListNode>;
		
		var minusButton:AbstractButton = new Minusbutton();
		var plusButton:AbstractButton = new Plusbutton();
		
				@:flash.property public var displayObject(get,set):DisplayObject;
function  get_displayObject():DisplayObject {
			if (displayObjectReference[0] != null) return cast(displayObjectReference[0], DisplayObject);
			throw new Error("Display object reference is null");
		}
		public static function clearSelections() {
			for (_tmp_ in table) {
var l:ListNode  = _tmp_;
				l.selected = false;
			}
		}
		
		public static function clearTable() 
		{
			table = new ASDictionary<ASAny,ASAny>(true);
			lastSelected = null;
		}
function  set_displayObject(d:DisplayObject):DisplayObject{
			
			displayObjectReference[0] = d;
return d;
		}
		public function new(displayObject:DisplayObject, parent:ListNode, treeView:TreeViewUtil)
		{
			super();
			this.displayObject = displayObject;
			this.treeView = treeView;
			parentNode = parent;
			table[displayObject] = this;
			_name = getQualifiedClassName(displayObject).split("::").pop();
			
			addChild(childContainer);
			
			_labelField = new TextField();
			_labelField.autoSize = TextFieldAutoSize.LEFT;
			_labelField.defaultTextFormat = TextFormats.windowDefaultFormat;
			_labelField.textColor = Colors.TREEVIEW_FG;
			_labelField.embedFonts = true;
			_labelField.selectable = false;
			_labelField.addEventListener(MouseEvent.CLICK, onClick);
			//_labelField.doubleClickEnabled = true;
			//_labelField.addEventListener(MouseEvent.DOUBLE_CLICK, onDClick);
			addChild(_labelField);
			
			setLabel();
			
			//_selectedOverlay = new Shape();
			//_selectedOverlay.blendMode = BlendMode.INVERT;
			//_selectedOverlay.visible = _selected;
			//addChild(_selectedOverlay);
			addChild(plusButton);
			addChild(minusButton);
			plusButton.visible = minusButton.visible = false;
			
			plusButton.addEventListener(MouseEvent.CLICK, onPlusClick, false, 0, true);
			minusButton.addEventListener(MouseEvent.CLICK, onMinusClick, false, 0, true);
			buildChildren();
		}
		
		function onMinusClick(e:MouseEvent) 
		{
			expanded = false;
			//treeView.setSelection(this);
			treeView.render();
			treeView.scrollTo(this);
		}
		
		function onPlusClick(e:MouseEvent) 
		{
			expanded = true;
			treeView.render();
			treeView.scrollTo(this);
		}
		function onClick(e:MouseEvent) 
		{
			treeView.onDisplayObjectSelected(displayObject);
		}
		function onMouseOut(e:MouseEvent) 
		{
			//treeView.insp.clearHighlight();
		}
		function onMouseOver(e:MouseEvent) 
		{
			//TODO: Some kind of highlight of the target
			//treeView.insp.highlightTarget(displayObject);
		}
		public function dispose() {
			_labelField.removeEventListener(MouseEvent.CLICK, onClick);
			//_labelField.addEventListener(MouseEvent.DOUBLE_CLICK, onDClick);
		}
		
		/* INTERFACE inspector.treeview.IRenderable */
		
		public function render()
		{
			_labelField.textColor = _selected?TextColors.TEXT_INFO:TextColors.TEXT_AUX;
			graphics.clear();
			graphics.lineStyle(0, Colors.TREEVIEW_FG);
			clear();
			if (parentNode != null) {
				graphics.moveTo(0, 7);
				graphics.lineTo( -7, 7);
			}
			setLabel();
			if (expanded) {
				if(childNodes == null) buildChildren();
				var y= height;
				graphics.moveTo(8, y);
				var lasty:Float = 0;
				var i= 0;while (i < childNodes.length) 
				{
					childContainer.addChild(childNodes[i]).y = y;
					childNodes[i].x = 15;
					childNodes[i].render();
					lasty = lasty < y?y:lasty;
					y += childNodes[i].height;
i++;
				}
				graphics.lineTo(8, lasty + 8);
				_firstLevelHeight = lasty + 8;
				
			}
		}
		public function refresh() {
		
		}
		
		function setLabel()
		{
			_labelField.text = _name;
			minusButton.x = plusButton.x = _labelField.width+1;
			minusButton.y = plusButton.y = Math.fround(_labelField.height * .5 - plusButton.height * .5);
			if (Std.is(displayObject , DisplayObjectContainer)) {
				if (Std.is(displayObject , DConsole)&&DConsole.CONSOLE_SAFE_MODE) {
					mouseEnabled = mouseChildren = false;
					_labelField.alpha = 0.4;
					return;
				}
				if (hasChildren) {
					if (expanded) {
						minusButton.visible = !(plusButton.visible = false);
					}else {
						minusButton.visible = !(plusButton.visible = true);
					}
				}
			}
		}
		function clearChildren() {
			var i= 0;while (i < childNodes.length) 
			{
				childNodes[i].dispose();
i++;
			}
			childNodes = new Vector<ListNode>();
		}
		public function buildChildren()
		{
			if (childNodes != null) return;
			childNodes = new Vector<ListNode>();
			if (!hasChildren) return;
			if (Std.is(displayObject , DisplayObjectContainer)) {
				var i= 0;while (i < cast(displayObject, DisplayObjectContainer).numChildren) 
				{
					var c= cast(displayObject, DisplayObjectContainer).getChildAt(i);
					childNodes.push(new ListNode(c, this, treeView));
i++;
				}
			}
		}
		@:flash.property var hasChildren(get,never):Bool;
function  get_hasChildren():Bool {
			if (Std.is(displayObject , DisplayObjectContainer)) {
				var doc= cast(displayObject, DisplayObjectContainer);
				return doc.numChildren > 0;
			}
			return false;
		}
		function clear() {
			while (childContainer.numChildren > 0) {
				childContainer.removeChildAt(0);
			}
		}
		
		public function expand() {
			expanded = true;
			render();
		}
		public function collapse() {
			expanded = false;
			render();
		}
		/**
		 * Test children for existence, if discrepancy is found, rebuild
		 */
		public function validate():Bool {
			return true;
		}
		
				
		/**
		 * Sets wether this is the currently selected item in the tree
		 */
		@:flash.property public var selected(get,set):Bool;
function  get_selected():Bool { return _selected; }
function  set_selected(value:Bool):Bool		{
			if (_selected == value) return value;
			if (lastSelected != null && lastSelected != this) lastSelected.selected = false;
			var rect= _labelField.getRect(this);
			_selected = value;
			_labelField.textColor = _selected?TextColors.TEXT_INFO:TextColors.TEXT_AUX;
			//_selectedOverlay.graphics.clear();
			//_selectedOverlay.graphics.beginFill(BaseColors.BLACK);
			//_selectedOverlay.graphics.drawRect(0, 0, hasChildren?rect.width + 12:rect.width, rect.height);
			//_selectedOverlay.graphics.endFill();
			lastSelected = this;
return value;
		}
		
		/**
		 * Returns the height of the root item sans children
		 */
		@:flash.property public var firstLevelHeight(get,never):Float;
function  get_firstLevelHeight():Float { return _firstLevelHeight; }
		
	}

