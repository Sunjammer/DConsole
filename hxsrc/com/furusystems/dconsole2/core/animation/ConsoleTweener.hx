package com.furusystems.dconsole2.core.animation ;
	
	/**
	 * Minimalistic tweener for handling some minor transitions
	 * @author Andreas Roenning
	 */
	 class ConsoleTweener {
		static var tweens:ASDictionary<ASAny,ASAny> = new ASDictionary();
		
		public static function tween(object:ASObject, property:String, targetValue:Float, tweenTime:Float, onComplete:ASFunction, tweenType:Class<Dynamic>) {
			if (tweens[object]) {
				cast(tweens[object], IConsoleTweenProcess).stop();
				tweens.remove(object);
			}
			tweens[object] = Type.createInstance(tweenType, [object, property, targetValue, tweenTime, onComplete]);
		}
		
		@:allow(com.furusystems.dconsole2.core.animation) static function removeTween(t:IConsoleTweenProcess) {
			tweens.remove(t.object);
		}
	}

