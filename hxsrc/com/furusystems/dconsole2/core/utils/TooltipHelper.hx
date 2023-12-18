package com.furusystems.dconsole2.core.utils ;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class TooltipHelper {
		public static var messaging:PimpCentral;
		static var helpmap:ASDictionary<ASAny,ASAny> = new ASDictionary();
		
		public static function map(object:InteractiveObject, text:String) {
			helpmap[object] = text;
			object.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			object.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		static function onMouseOut(e:MouseEvent) {
			messaging.send(Notifications.TOOLTIP_HIDE_REQUEST);
		}
		
		static function onMouseOver(e:MouseEvent) {
			messaging.send(Notifications.TOOLTIP_SHOW_REQUEST, helpmap[e.currentTarget]);
		}
	
	}

