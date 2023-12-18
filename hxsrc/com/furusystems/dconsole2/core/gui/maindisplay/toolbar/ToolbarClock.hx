package com.furusystems.dconsole2.core.gui.maindisplay.toolbar ;
	import com.furusystems.dconsole2.core.gui.TextFieldFactory;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class ToolbarClock extends Sprite {
		var _tf:TextField;
		var _mouseOver:Bool = false;
		
		public function new(messaging:PimpCentral) {
			super();
			_tf = TextFieldFactory.getLabel("test");
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.textColor = Colors.HEADER_FG;
			
			_tf.mouseEnabled = false;
			addChild(_tf);
			messaging.addCallback(Notifications.FRAME_UPDATE, updateClock);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		function onMouseOut(e:MouseEvent) {
			_mouseOver = false;
		}
		
		function onMouseOver(e:MouseEvent) {
			_mouseOver = true;
		}
		
		public function setColor(color:UInt) {
			_tf.textColor = color;
		}
		
		public function updateClock(md:MessageData) {
			if (_mouseOver) {
				_tf.text = Date.now().toString();
				_tf.alpha = 1;
			} else {
				_tf.text = Date.now().toTimeString();
				_tf.alpha = 0.5;
			}
			_tf.x = -_tf.width - 10;
		}
	
	}

