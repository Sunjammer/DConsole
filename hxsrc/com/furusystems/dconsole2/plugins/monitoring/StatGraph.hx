package com.furusystems.dconsole2.plugins.monitoring
;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import com.furusystems.dconsole2.core.bitmap.Bresenham;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class StatGraph extends Sprite
	{
		final valueHistory:Vector<Float> = new Vector();
		public var maxValues:Int = 60;
		final values:GraphValueStack = new GraphValueStack(maxValues);
		final dims:Rectangle = new Rectangle(0, 0, 300, 100);
		var graphBitmap:BitmapData = new BitmapData(Std.int(dims.width), Std.int(dims.height));
		var tagBitmap:BitmapData = new BitmapData(Std.int(dims.width), Std.int(dims.height));
		var renderStart:Point = new Point();
		var renderEnd:Point = new Point();
		var max:Float = 0;
		var min:Float = 0;
		var median:Float = Std.int(dims.height)>>1;
		var graphDisplay:Bitmap = new Bitmap(graphBitmap);
		var tagDisplay:Bitmap = new Bitmap(tagBitmap);
		var maxTF:TextField;
		var midTF:TextField;
		var minTF:TextField;
		var queryTF:TextField;
		var prevQuery:GraphValue;
		var prevQueryIndex:Int = 0;
		var dirty:Bool = true;
		var paused:Bool = false;
		var content:Sprite = new Sprite();
		var _disposed:Bool = false;
		var switchMode:Bool = false;
		var acceptDuplicateValues:Bool = false;
		var _bg:UInt = 0x00000000;
		var _graphColor:UInt = 0xFFAAAAAA;
		var _barColor:UInt = 0x88000000;
		@:flash.property public var disposed(get,never):Bool;
function  get_disposed():Bool {
			return _disposed;
		}
		public function new(booleanMode:Bool = false,acceptDuplicateValues:Bool = false,storeHistory:Bool = true) 
		{
			super();
			values.storeHistory = storeHistory;
			content.addChild(tagDisplay);
			content.addChild(graphDisplay);
			
			this.switchMode = booleanMode;
			this.acceptDuplicateValues = acceptDuplicateValues;
			
			maxTF = new TextField();
			midTF = new TextField();
			minTF = new TextField();
			queryTF = new TextField();
			content.addChild(maxTF);
			content.addChild(midTF);
			content.addChild(minTF);
			content.addChild(queryTF);
			var tf= new TextFormat("_sans", 9, 0);
			maxTF.defaultTextFormat = midTF.defaultTextFormat = minTF.defaultTextFormat = queryTF.defaultTextFormat = tf;
			maxTF.mouseEnabled = midTF.mouseEnabled = minTF.mouseEnabled = queryTF.mouseEnabled = false;
			maxTF.autoSize = midTF.autoSize = minTF.autoSize = queryTF.autoSize = TextFieldAutoSize.LEFT;
			queryTF.background = true;	
			queryTF.border = true;
			queryTF.visible = false;
			
			maxTF.x = dims.width;
			minTF.x = dims.width;
			minTF.y = dims.height-13;
			midTF.x = dims.width;
			midTF.y = median - 8;
			content.addEventListener(MouseEvent.MOUSE_DOWN, startSampling);
			content.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			content.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			content.doubleClickEnabled = true;
			
			var menu= new ContextMenu();
			var item= new ContextMenuItem("Clear");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onDoubleClick);
			menu.customItems.push(item);
			
			if(storeHistory){
				item = new ContextMenuItem("Save xml");
				//item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, saveXML, false, 0, true);
				menu.customItems.push(item);
			}
			content.contextMenu = menu;
			addChild(content);
			
		}
				@:flash.property public var current(get,set):Bool;
function  set_current(b:Bool):Bool{
			visible = b;
			paused = !b;
			//maxTF.visible = minTF.visible = midTF.visible = b;
			if (b) parent.setChildIndex(this, parent.numChildren - 1);
return b;
		}
function  get_current():Bool {
			return visible;
		}
		function initialize() {
			graphBitmap.dispose();
			tagBitmap.dispose();
			median = Std.int(dims.height )>> 1;
			graphBitmap = new BitmapData(Std.int(dims.width - 50), Std.int(dims.height));
			tagBitmap = new BitmapData(Std.int(dims.width - 50), Std.int(dims.height));
			tagDisplay.bitmapData = tagBitmap;
			graphDisplay.bitmapData = graphBitmap;
			
			maxTF.x = dims.width-50;
			minTF.x = dims.width-50;
			midTF.x = dims.width-50;
			minTF.y = dims.height-13;
			midTF.y = median - 8;
			
			//content.removeChild(tagDisplay);
			//content.removeChild(graphDisplay);
			//graphDisplay = new Bitmap(graphBitmap);
			//tagDisplay = new Bitmap(tagBitmap);
			//content.addChild(tagDisplay);
			//content.addChild(graphDisplay);
			render();
		}
		public function resize(dims:Rectangle) {
			this.dims.height = dims.height;
			this.dims.width = dims.width;
			initialize();
		}
		@:flash.property public var graphColor(never,set):UInt;
function  set_graphColor(color:UInt):UInt{
			return _graphColor = color;
		}
		@:flash.property public var barColor(never,set):UInt;
function  set_barColor(color:UInt):UInt{
			return _barColor = color;
		}
		
		public function kill(e:Event = null) 
		{
			_disposed = true;
			content.removeEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			content.removeEventListener(MouseEvent.MOUSE_DOWN, startSampling);
			content.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			content.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopSampling);
			graphBitmap.dispose();
			tagBitmap.dispose();
			parent.removeChild(this);
		}
		
		function onDoubleClick(e:Event) 
		{
			values.clear();
			min = max = 0;
		}
		
		function onMouseWheel(e:MouseEvent) 
		{
			maxValues += e.delta;
			maxValues = Std.int(Math.max(4, maxValues));
			values.maxValues = maxValues;
			min = max = 0;
			values.forEach(checkMinMax);
		}
		
		function checkMinMax(value:Float,index:Int)
		{
			if (value < min) min = value;
			if (value > max) max = value;
		}
		function startSampling(e:Event) {
			onMouseMove();
			paused = true;
			queryTF.visible = true;
			content.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopSampling);
		}
		function stopSampling(e:Event) {
			paused = false;
			queryTF.visible = false;
			content.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopSampling);
		}
		
		function onMouseMove(e:MouseEvent = null) 
		{
			try{
				getValueAt(Std.int(mouseX));
			}catch (e:Error) {
				
			}
		}
		public function add(newValue:Float):Float {
			if (paused || _disposed) return newValue;
			if (switchMode) {
				newValue = toSwitch(newValue);
			}
			if (newValue == values.lastValue&&!acceptDuplicateValues) {
				return newValue;
			}
			
			if (newValue < min) min = newValue;
			if (newValue > max) max = newValue;
			dirty = true;
			values.add(newValue);
			if (visible) render();
			return newValue;
		}
		function toSwitch(value:Float):Int {
			return (value > 0) ? 1 : 0;
		}
		function render()
		{	
			if (!dirty) return;
			if(switchMode){
				maxTF.text = "1";
				minTF.text = "0";
				midTF.text = "AVG:" + Std.string(Math.fround(values.average));
			}else {
				maxTF.text = ASCompat.toPrecision(max, 2);
				minTF.text = ASCompat.toPrecision(min, 2);
				midTF.text = "AVG:" + ASCompat.toPrecision(values.average, 2);
			}
			
			graphBitmap.lock();
			tagBitmap.lock();
			
			graphBitmap.fillRect(dims, _bg);
			tagBitmap.fillRect(dims, _bg);
			
			renderStart.x = renderStart.y = 0;
			values.forEach(drawLines);
			
			graphBitmap.unlock();
			tagBitmap.unlock();
		}
		
		function drawLines(value:Float,index:Int)
		{
			var x= Std.int(index / (values.totalValues-1) * (dims.width-50));
			var mul= (value-min) / (max - min);
			var y= Std.int((1-mul) * (dims.height-1));
			if (index == 0) {
				renderStart.x = 0;
				renderStart.y = y;
			}else {
				renderEnd.x = x;
				renderEnd.y = y;
				Bresenham.line_pixel32(renderStart, renderEnd, graphBitmap, _graphColor);
				renderStart.y = median;
				renderStart.x = x;
				//Bresenham.line_pixel32(renderStart, renderEnd, tagBitmap, _barColor);
				renderStart.y = y;
			}
		}
		public function getValueAt(x:Int):Float {
			x = Std.int(Math.min(x, dims.width-50));
			var idx= Std.int(x / (dims.width-50) * (values.totalValues - 1));
			prevQueryIndex = idx;
			prevQuery = values.getValueAt(idx);
			var mul= (prevQuery.value-min) / (max - min);
			var y= Std.int((1-mul) * (dims.height-25));
			//queryTF.y = median;
			queryTF.y = y;
			queryTF.x = idx / (values.totalValues-1) * (dims.width-50);
			queryTF.text = (prevQuery.creationTime/1000)+"\n"+Std.string(prevQuery.value);
			return prevQuery.value;
		}
		
	}

