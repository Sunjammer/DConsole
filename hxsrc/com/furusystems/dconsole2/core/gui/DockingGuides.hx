package com.furusystems.dconsole2.core.gui ;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.style.BaseColors;
	import com.furusystems.messaging.pimp.IMessageReceiver;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class DockingGuides extends Shape implements IMessageReceiver {
		public static inline final TOP= 0;
		public static inline final BOT= 1;
		
		public function new() {
			super();
			//blendMode = BlendMode.INVERT;
			PimpCentral.addReceiver(this, Notifications.SHOW_DOCKING_GUIDE, [Notifications.HIDE_DOCKING_GUIDE]);
			visible = false;
		}
		
		public function resize() {
			graphics.clear();
			graphics.lineStyle(3, BaseColors.ORANGE);
			graphics.lineTo(stage.stageWidth, 0);
		}
		
		public function show(position:Int) {
			switch (position) {
				case TOP:
					y = 0;
					
				case BOT:
					y = stage.stageHeight - 1;
					
			}
			visible = true;
		}
		
		public function hide() {
			visible = false;
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.notification.IMessageReceiver */
		
		public function onMessage(d:MessageData) {
			switch (d.message) {
				case Notifications.SHOW_DOCKING_GUIDE:
					show(d.data);
					
				case Notifications.HIDE_DOCKING_GUIDE:
					hide();
					
			}
		}
	
	}

