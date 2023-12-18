package com.furusystems.dconsole2.core.inspector ;
	import com.furusystems.dconsole2.core.inspector.IInspectorView;
	import com.furusystems.dconsole2.core.plugins.IDConsoleInspectorPlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class AbstractInspectorView extends Sprite implements IInspectorView implements  IDConsoleInspectorPlugin {
		var _scrollXEnabled:Bool = true;
		var _scrollYEnabled:Bool = true;
		public var inspector:Inspector;
		var _scrollMargin:Float = Math.NaN;
		var _bounds:Rectangle;
		var _scrollableContent:Sprite = new Sprite();
		var _title:String;
		
		public function new(title:String) {
			super();
			_title = title;
			addChild(_scrollableContent);
			_scrollableContent.scrollRect = new Rectangle();
			_scrollMargin = 0;
			addEventListener(Event.ADDED_TO_STAGE, onAddedtoStage);
		}
		
		function onAddedtoStage(e:Event) {
			onShow();
		}
		
		function onShow() {
			
		}
		
		public function associateWithInspector(inspector:Inspector) {
			this.inspector = inspector;
		}
		
		public function scrollByDelta(x:Float, y:Float) {
			scrollX -= x;
			scrollY -= y;
		}
		
				
		@:flash.property public var scrollX(get,set):Float;
function  get_scrollX():Float {
			return scrollRect.x;
		}
		
				
		@:flash.property public var scrollY(get,set):Float;
function  get_scrollY():Float {
			return scrollRect.y;
		}
		
		public function onFrameUpdate(e:Event = null) {
		
		}
		
		public function setWidthHeight(w:Float, h:Float) {
			var s= scrollRect;
			s.width = w;
			s.height = h;
			scrollRect = s;
			scrollByDelta(0, 0);
		}
		
		override function  get_scrollRect():Rectangle {
			return _scrollableContent.scrollRect;
		}
		
		override function  set_scrollRect(value:Rectangle):Rectangle{
			return _scrollableContent.scrollRect = value;
		}
		
		public function populate(object:ASObject) {
		}
function  set_scrollX(n:Float):Float{
			var s= scrollRect;
			calcBounds();
			if (scrollXEnabled) {
				s.x = n;
				var diffX= (_bounds.width - scrollRect.width);
				s.x = Math.max(-_scrollMargin, Math.min(s.x, diffX + _scrollMargin));
			} else {
				s.x = -_scrollMargin;
			}
			scrollRect = s;
return n;
		}
		
		function calcBounds():Rectangle {
			return _bounds = _scrollableContent.transform.pixelBounds;
		}
		
				
		@:flash.property public var scrollXEnabled(get,set):Bool;
function  get_scrollXEnabled():Bool {
			if (_scrollXEnabled)
				return _bounds.width > scrollRect.width;
			return false;
		}
		
				
		@:flash.property public var scrollYEnabled(get,set):Bool;
function  get_scrollYEnabled():Bool {
			if (_scrollYEnabled)
				return _bounds.height > scrollRect.height;
			return false;
		}
		
		@:flash.property public var availableWidth(get,never):Float;
function  get_availableWidth():Float {
			return scrollRect.width;
		}
		
		@:flash.property public var availableHeight(get,never):Float;
function  get_availableHeight():Float {
			return scrollRect.height;
		}
function  set_scrollXEnabled(b:Bool):Bool{
			return _scrollXEnabled = b;
		}
function  set_scrollYEnabled(b:Bool):Bool{
			return _scrollYEnabled = b;
		}
function  set_scrollY(n:Float):Float{
			calcBounds();
			var s= scrollRect;
			if (scrollYEnabled) {
				s.y = n;
				var diffY= (_bounds.height - scrollRect.height);
				s.y = Math.max(-_scrollMargin, Math.min(s.y, diffY + _scrollMargin));
			} else {
				s.y = -_scrollMargin;
			}
			scrollRect = s;
return n;
		}
		
		@:flash.property public var maxScrollY(get,never):Float;
function  get_maxScrollY():Float {
			return _scrollableContent.transform.pixelBounds.height - scrollRect.height;
		}
		
		@:flash.property public var maxScrollX(get,never):Float;
function  get_maxScrollX():Float {
			return _scrollableContent.transform.pixelBounds.width - scrollRect.width;
		}
		
		public function beginDragging() {
			Mouse.cursor = MouseCursor.HAND;
			mouseChildren = false;
		}
		
		public function stopDragging() {
			Mouse.cursor = MouseCursor.AUTO;
			mouseChildren = true;
		}
		
		public function resize() {
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsoleInspectorPlugin */
		
		@:flash.property public var view(get,never):AbstractInspectorView;
function  get_view():AbstractInspectorView {
			return this;
		}
		
		@:flash.property public var title(get,never):String;
function  get_title():String {
			return _title;
		}
		
		public function update(pm:PluginManager) {
		
		}
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String {
			return "";
		}
		
		public function initialize(pm:PluginManager) {
		}
		
		public function shutdown(pm:PluginManager) {
		}
		
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> {
			return null;
		}
		
		@:flash.property public var content(get,never):Sprite;
function  get_content():Sprite 
		{
			return _scrollableContent;
		}
	
	}

