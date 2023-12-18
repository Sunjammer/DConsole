package com.furusystems.dconsole2.core.animation ;
	import flash.display.Shape;
	import flash.events.Event;
	
	/**
	 * A linearly interpolating tween
	 * @author Andreas Roenning
	 */
	 class LinearTween implements IConsoleTweenProcess {
		var frameSource:Shape = new Shape();
		var _object:ASObject;
		var _property:String;
		var _targetValue:Float = Math.NaN;
		var _tweenTime:Float = Math.NaN;
		var _startTime:Float = Math.NaN;
		var _origValue:Float = Math.NaN;
		var _onComplete:ASFunction;
		
		public function new(object:ASObject, property:String, targetValue:Float, tweenTime:Float, onComplete:ASFunction) {
			_onComplete = onComplete;
			_tweenTime = tweenTime;
			_targetValue = targetValue;
			_property = property;
			this._object = object;
			_origValue = this._object[_property];
			_startTime = flash.Lib.getTimer();
			frameSource.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		function onEnterFrame(e:Event) {
			var elapsed= (flash.Lib.getTimer() - _startTime) * 0.001;
			var t= elapsed / _tweenTime;
			_object[_property] = _origValue + (_targetValue - _origValue) * t;
			if (elapsed >= _tweenTime) {
				_object[_property] = _targetValue;
				_onComplete();
				stop();
			}
		}
		
		public function stop() {
			frameSource.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			ConsoleTweener.removeTween(this);
		}
		
				
		@:flash.property public var object(get,set):ASObject;
function  get_object():ASObject {
			return _object;
		}
function  set_object(value:ASObject):ASObject{
			return _object = value;
		}
	
	}

