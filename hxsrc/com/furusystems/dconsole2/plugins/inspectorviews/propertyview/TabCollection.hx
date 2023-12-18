package com.furusystems.dconsole2.plugins.inspectorviews.propertyview 
;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.plugins.inspectorviews.propertyview.tabs.PropertyTab;
	/**
	 * ...
	 * @author Andreas Ronning 
	 */
	 class TabCollection extends Sprite
	{
		final _tabs:Vector<PropertyTab> = new Vector();
		var _currentSelection:PropertyTab = null;
		public var singleSelectionOnly:Bool = false;
		public function new() 
		{
			super();
			
		}
		public function add(t:PropertyTab) {
			_tabs.push(t);
			addChild(t);
			t.addEventListener(Event.CHANGE, onTabChange);
			update();
		}
		function onTabChange(e:Event) 
		{
			if(singleSelectionOnly){
				var t= ASCompat.dynamicAs(e.currentTarget , PropertyTab);
				var i= 0;while (i < _tabs.length) 
				{
					if (_tabs[i] == t) {i++;continue;};
					_tabs[i].expanded = false;
i++;
				}
			}
			update();
		}
		public function update(updateAppearance:Bool = false)
		{
			var h:Float = 0;
			var i= 0;while (i < _tabs.length) 
			{
				var t= _tabs[i];
				if (updateAppearance) t.updateAppearance();
				t.y = h;
				h += t.height + GUIUnits.V_MARGIN;
i++;
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		public function clear() {
			while (_tabs.length > 0) {
				var t= _tabs.pop();
				t.removeEventListener(Event.CHANGE, onTabChange);
				removeChild(t);
			}
		}
		
		public function updateTabs()
		{
			var i= _tabs.length;while (i-- != 0) 
			{
				_tabs[i].updateFields();
			}
		}
		override function  get_width():Float { return super.width; }
		
		override function  set_width(value:Float):Float		{
			var i= 0;while (i < _tabs.length) 
			{
				_tabs[i].width = value;
i++;
			}
return value;
		}
		
	}

