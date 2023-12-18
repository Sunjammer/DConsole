package com.furusystems.dconsole2.core.gui ;
	import com.furusystems.dconsole2.core.gui.events.DropDownEvent;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.core.style.TextFormats;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class DropDown extends Sprite {
		var titleField:TextField;
		var headerBar:Sprite = new Sprite();
		var barHeight:Int = GUIUnits.SQUARE_UNIT;
		var barWidth:Int = 0;
		var optionsList:Sprite = new Sprite();
		var options:Vector<DropDownOption> = new Vector();
		var optionHeight:Float = Math.NaN;
		//private var inverter:Shape = new Shape();
		var selection:DropDownOption;
		
		public function new(title:String = "Dropdown") {
			super();
			
			addChild(optionsList);
			addChild(headerBar);
			buttonMode = true;
			titleField = new TextField();
			titleField.autoSize = TextFieldAutoSize.LEFT;
			titleField.defaultTextFormat = TextFormats.consoleTitleFormat;
			titleField.embedFonts = titleField.defaultTextFormat.font.charAt(0) != "_";
			titleField.selectable = false;
			titleField.mouseEnabled = false;
			titleField.y = 1;
			setTitle(title, false);
			
			headerBar.addChild(titleField);
			
			headerBar.graphics.clear();
			headerBar.graphics.beginFill(Colors.DROPDOWN_FG_INACTIVE);
			headerBar.graphics.drawRect(0, 0, barWidth, barHeight);
			headerBar.graphics.endFill();
			titleField.textColor = Colors.DROPDOWN_FG_ACTIVE;
			
			optionsList.visible = false;
			//inverter.visible = false;
			//inverter.blendMode = BlendMode.INVERT;
			//optionsList.addChild(inverter);
			optionsList.y = barHeight;
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		function onMouseDown(e:MouseEvent) {
			//optionsList.setChildIndex(inverter, optionsList.numChildren - 1);
			optionsList.visible = true;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			filters = [new DropShadowFilter(4, 45, 0, 0.1, 8, 8)];
		}
		
		function onMouseMove(e:MouseEvent) {
			var idx= Math.floor(optionsList.mouseY / optionHeight);
			var b= (idx >= 0 && idx < options.length);
			//inverter.y = idx * optionHeight;
			if (b) {
				selection = options[idx];
			} else {
				selection = null;
			}
		}
		
		public function setTitle(newTitle:String, redraw:Bool = false) {
			titleField.text = newTitle;
			barWidth = Std.int(titleField.textWidth + 4);
			if (redraw)
				draw();
		}
		
		function onMouseUp(e:MouseEvent) {
			filters = [];
			if (selection != null) {
				dispatchEvent(new DropDownEvent(DropDownEvent.SELECTION, selection));
				setTitle(selection.title, true);
			}
			optionsList.visible = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		public function addOption(o:DropDownOption) {
			options.push(o);
			o.index = options.length - 1;
			optionsList.addChild(o);
			if (o.isDefault) {
				setTitle(o.title);
			}
			draw();
		}
		
		public function updateAppearance() {
			for (o in options) {
				o.updateAppearance();
			}
			draw();
		}
		
		public function removeOption(title:String) {
			//TODO: Remove options
		}
		
		public function setCurrentSelection(title:String) {
			setTitle(title, true);
		}
		
		function draw() {
			var h:Float = 0;
			var w= titleField.textWidth + 6;
			var i= 0;while (i < options.length) {
				options[i].y = h;
				optionHeight = options[i].height;
				h += options[i].height;
				if (options[i].width > w)
					w = options[i].width;
i++;
			}
			for (o in options) {
				o.setWidth(w);
			}
			barWidth = Std.int(w);
			optionsList.graphics.clear();
			//optionsList.graphics.lineStyle(Colors.DROPDOWN_BORDER);
			
			optionsList.graphics.beginFill(Colors.DROPDOWN_BG_ACTIVE);
			optionsList.graphics.drawRect(0, 0, w, h);
			
			headerBar.graphics.clear();
			headerBar.graphics.beginFill(Colors.DROPDOWN_FG_INACTIVE);
			headerBar.graphics.drawRect(0, 0, barWidth, barHeight);
			headerBar.graphics.endFill();
			titleField.textColor = Colors.DROPDOWN_FG_ACTIVE;
			titleField.backgroundColor = Colors.DROPDOWN_BG_ACTIVE;
			
			//inverter.graphics.clear();
			//inverter.graphics.beginFill(BaseColors.WHITE);
			//inverter.graphics.drawRect(1, 1, Math.max(2,barWidth-1), Math.max(2,optionHeight-1));
			//inverter.graphics.endFill();
			redrawBar();
		}
		
		function redrawBar() {
			headerBar.graphics.clear();
			headerBar.graphics.beginFill(Colors.DROPDOWN_BG_ACTIVE);
			headerBar.graphics.lineStyle(0, Colors.DROPDOWN_BORDER);
			headerBar.graphics.drawRect(0, 0, barWidth, barHeight);
			headerBar.graphics.endFill();
		}
	
	}

