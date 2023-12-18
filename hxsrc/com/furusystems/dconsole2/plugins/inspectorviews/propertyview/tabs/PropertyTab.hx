package com.furusystems.dconsole2.plugins.inspectorviews.propertyview.tabs
;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.core.style.TextFormats;
	import com.furusystems.dconsole2.plugins.inspectorviews.propertyview.fieldtypes.PropertyField;
	import com.furusystems.dconsole2.plugins.inspectorviews.propertyview.TabContent;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class PropertyTab extends Sprite
	{
		var headerField:TextField;
		var headerBar:Sprite = new Sprite();
		var contents:Sprite = new Sprite();
		var _expanded:Bool = false;
		var _contentFields:Vector<TabContent> = new Vector();
		var _prevWidth:Float = 0;
		public function new(title:String,startsExpanded:Bool = false) 
		{
			super();
			headerField = new TextField();
			headerField.height = GUIUnits.SQUARE_UNIT;
			headerField.defaultTextFormat = TextFormats.windowDefaultFormat;
			headerField.embedFonts = true;
			headerField.textColor = Colors.INSPECTOR_TAB_HEADER_FG;
			headerField.text = title;
			contents.y = GUIUnits.SQUARE_UNIT + GUIUnits.V_MARGIN;
			headerBar.addChild(headerField);
			headerField.mouseEnabled = false;
			headerBar.buttonMode = true;
			headerBar.addEventListener(MouseEvent.CLICK, toggleExpanded);
			addChild(headerBar);
			expanded = startsExpanded;
		}
		public function addField(p:TabContent):TabContent {
			p.addEventListener(Event.CHANGE, onPropertyFieldSplitChange,false,0,true);
			_contentFields.push(p);
			render(_prevWidth); //TODO: SOme optimization here? 
			return p;
		}
		public function sortFields() {
			_contentFields.sort(sortAlphabetical);
			render(_prevWidth);
		}
		
		function sortAlphabetical(a:TabContent,b:TabContent):Int
		{
			if (a.title > b.title) return 1;
			if (a.title < b.title) return -1;
			return 0;
		}
		public function averageSplits() {
			var tally:Float = 0;
			for (_tmp_ in _contentFields) {
var p:PropertyField  = _tmp_;
				p.splitToName();
				tally += p.splitRatio;
			}
			tally /= _contentFields.length;
			tally += 0.1; //slight bias
			for (_tmp_ in _contentFields) {
var p :ASAny = _tmp_;
				p.splitRatio = tally;
			}
		}
		
		function onPropertyFieldSplitChange(e:Event) 
		{
			if (Std.is(e.target , PropertyField)) {
				var newSplit= cast(e.target, PropertyField).splitRatio;
				var i= _contentFields.length;while (i-- != 0) 
				{
					if (Std.is(_contentFields[i] , PropertyField)) {
						cast(_contentFields[i], PropertyField).splitRatio = newSplit;
					}
				}
			}
		}
		
		function updateLayout(updateAppearance:Bool = false)
		{
			var h:Float = 0;
			var i= 0;while (i < _contentFields.length) 
			{
				var c= _contentFields[i];
				if (updateAppearance) c.updateAppearance();
				contents.addChild(c).y = h;
				h += Math.fceil(c.height) + GUIUnits.V_MARGIN;
				c.width = _prevWidth;
i++;
			}
		}
		override function  get_width():Float { return super.width; }
		
		override function  set_width(value:Float):Float		{
			render(value);
return value;
		}
		function toggleExpanded(e:MouseEvent) 
		{
			expanded = !expanded;
			dispatchEvent(new Event(Event.CHANGE));
		}
		override function  get_height():Float { 
			if (_expanded) {
				return super.height; 
			}else {
				return headerBar.height;
			}
		}
		public function updateAppearance() {
			render(_prevWidth, true);
		}
		
		public function updateFields()
		{
			if (!_expanded) return;
			var i= _contentFields.length;while (i-- != 0) 
			{
				_contentFields[i].updateFromSource();
			}
		}
		function render(w:Float, updateAppearance:Bool = false) {
			headerField.textColor = Colors.INSPECTOR_TAB_HEADER_FG;
			if(w!=_prevWidth||updateAppearance){
				headerBar.graphics.clear();
				headerBar.graphics.beginFill(Colors.INSPECTOR_TAB_HEADER_BG);
				headerBar.graphics.drawRect(0, 0, w, GUIUnits.SQUARE_UNIT);
				headerBar.graphics.endFill();
				headerField.width = w;
				contents.graphics.clear();
				contents.graphics.beginFill(Colors.INSPECTOR_TAB_CONTENT_BG);
				contents.graphics.drawRect(0, 0, w, getNumProperties() * (GUIUnits.SQUARE_UNIT+GUIUnits.V_MARGIN));
				contents.graphics.endFill();
			}
			//contents.scrollRect = new Rectangle(0, 0, w, getNumProperties() * GUIUnits.SQUARE_UNIT);
			_prevWidth = w;
			updateLayout(updateAppearance);
		}
		function getNumProperties():Int {
			return _contentFields.length;
		}
				
		@:flash.property public var expanded(get,set):Bool;
function  get_expanded():Bool { return _expanded; }
function  set_expanded(value:Bool):Bool		{
			_expanded = value;
			if (_expanded) {
				addChild(contents);
			}else {
				if (!contains(contents)) return value;
				removeChild(contents);
			}
return value;
		}
		
	}

