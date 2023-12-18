package com.furusystems.dconsole2.plugins.monitoring
;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import com.furusystems.dconsole2.core.gui.Window;
	import com.furusystems.dconsole2.core.style.TextFormats;

	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class Monitor extends Window
	{
		var _scope:ASDictionary<ASAny,ASAny> = new ASDictionary(true);
		public var properties:Array<ASAny>;
		public var outObj:ASObject = {};
		var outputTf:TextField = new TextField();
		var manager:MonitorManager;
		public function new(manager:MonitorManager, scope:ASObject, properties:Array<ASAny>)
		{
			this.manager = manager;
			_scope["scope"] = scope;
			this.properties = properties;
			outputTf.autoSize = TextFieldAutoSize.LEFT;
			outputTf.defaultTextFormat = TextFormats.windowDefaultFormat;
			super(Std.string(scope), new Rectangle(0, 0, 100, 100), outputTf, null, null, true, false, false);
			update(true);
		}
		@:flash.property public var scope(get,never):ASAny;
function  get_scope():ASAny
		{
			return _scope["scope"];
		}
		public function update(redraw:Bool = false)
		{
			var i= 0;while (i < properties.length)
			{
				outObj[properties[i]] = scope[properties[i]];
i++;
			}
			outputTf.text = "";
			for (s in outObj.___keys())
			{
				outputTf.appendText(s + " : " + outObj[s] + "\n");
			}
			if (redraw)
			{
				scaleToContents();
			}
		}
		public override function toString():String
		{
			return Std.string(outObj);
		}
		override function onClose(e:MouseEvent)
		{
			outObj = null;
			manager.removeMonitor(scope);
			super.onClose(e);
		}

	}

