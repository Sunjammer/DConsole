package com.furusystems.dconsole2.plugins.monitoring 
;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import com.furusystems.dconsole2.core.gui.DropDown;
	import com.furusystems.dconsole2.core.gui.DropDownOption;
	import com.furusystems.dconsole2.core.gui.events.DropDownEvent;
	import com.furusystems.dconsole2.core.gui.Window;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class GraphWindow extends Window
	{
		static final colors:Vector<UInt> = new Vector();
		var graphs:Vector<StatGraph> = new Vector();
		final dims:Rectangle = new Rectangle(0, 0, 300, 100);
		var content:Sprite = new Sprite();
		var graphChoiceDropdown:DropDown;
		public function new(windowName:String = "Graph") 
		{
			var windowDims= dims.clone();
			windowDims.width += 50;
			var minDims= windowDims.clone();
			minDims.width = 100;
			minDims.height = 50;
			super(windowName, windowDims, content,null, minDims,true, false, true);
			graphChoiceDropdown = new DropDown("Views");
			graphChoiceDropdown.y = dims.height-2;
			graphChoiceDropdown.x = 1;
			graphChoiceDropdown.visible = false;
			graphChoiceDropdown.addEventListener(DropDownEvent.SELECTION, onSelection);
			addChild(graphChoiceDropdown);
			
			colors.push(0xFFF2B31E);
			colors.push(0xFF5CB900);
			colors.push(0xFF800000);
			colors.push(0xFFFF0080);
			colors.push(0xFF8000FF);
			colors.push(0xFF000080);
			
			//TODO: Render all graphs to same bitmapdata
			
		}
		
		function onSelection(e:DropDownEvent) 
		{
			var i= 0;while (i < graphs.length) 
			{
				graphs[i].current = (e.selectedOption.index == i);
i++;
			}
			graphChoiceDropdown.setTitle(e.selectedOption.title);
		}
		override function onClose(e:MouseEvent) 
		{
			var i= 0;while (i < graphs.length) 
			{
				graphs[i].kill();
i++;
			}
			graphs = new Vector<StatGraph>();
			parent.removeChild(this);
			super.onClose(e);
		}
		override function onResize() 
		{
			var i= 0;while (i < graphs.length) 
			{
				graphs[i].resize(viewRect);
i++;
			}
			graphChoiceDropdown.y = viewRect.height-2;
		}
		public function addGraph(g:StatGraph) {
			var i= 0;while (i < graphs.length) 
			{
				graphs[i].current = false;
i++;
			}
			content.addChild(g);
			graphs.push(g);
			g.resize(viewRect);
			g.current = true;
			g.graphColor = colors[graphs.length - 1];
			redraw(viewRect);
			graphChoiceDropdown.addOption(new DropDownOption("Graph " + (graphs.length - 1)));
			graphChoiceDropdown.setTitle("Graph " + (graphs.length - 1));
			if (graphs.length > 1) {
				graphChoiceDropdown.visible = true;
			}
		}
		
	}

