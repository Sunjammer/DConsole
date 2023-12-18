package com.furusystems.dconsole2.plugins.monitoring
;

	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 final class GraphValueStack
	{
		public var storeHistory:Bool = false;
		public var allValues:Vector<Float> = new Vector();
		var values:GraphValue = new GraphValue();
		var head:GraphValue = values;
		var count:Int = 0;
		var _maxValues:Int = 0;
		var _lastValue:Float = Math.NaN;
		var startTime:Int = 0;
		@:flash.property public var totalValues(get,never):Int;
function  get_totalValues():Int
		{
			return count;
		}
		public function new(maxValues:Int)
		{
			_maxValues = maxValues;
		}
		public function add(n:Float)
		{
			if (startTime == 0)
			{
				startTime = flash.Lib.getTimer();
			}
			var v= new GraphValue();
			_lastValue = n;
			v.value = n;
			v.creationTime = flash.Lib.getTimer() - startTime;
			if (storeHistory)
				ASCompat.ASArray.pushMultiple(allValues, v.creationTime, n);
			head.next = v;
			head = v;
			count++;
			if (count > _maxValues)
			{
				values = values.next;
				count--;
			}
		}
		public function clear()
		{
			allValues = new Vector<Float>();
			values.next = null;
			head = values;
			count = 0;
		}
		public function extend()
		{
			add(_lastValue);
		}
		@:flash.property public var average(get,never):Float;
function  get_average():Float
		{
			if (count > 0)
				return sum / count;
			return 0;
		}
		@:flash.property public var sum(get,never):Float;
function  get_sum():Float
		{
			var v= values;
			var total:Float = 0;
			while (v.next != null)
			{
				v = v.next;
				total += v.value;
			}
			return total;
		}
		public function getValueAt(index:Int):GraphValue
		{
			var v= values;
			var idx= 0;
			while (v.next != null)
			{
				v = v.next;
				if (idx == index)
				{
					return v;
				}
				idx++;
			}
			throw new Error("The index " + index + " is out of range");
		}

		
		@:flash.property public var maxValues(get,set):Int;
function  get_maxValues():Int
		{
			return _maxValues;
		}
function  set_maxValues(value:Int):Int		{
			_maxValues = value;
			while (count > _maxValues)
			{
				values = values.next;
				count--;
			}
return value;
		}

		public function forEach(func:ASFunction)
		{
			var v= values;
			var idx= 0;
			while (v.next != null)
			{
				v = v.next;
				func(v.value, idx);
				idx++;
			}
		}

		public function toString():String
		{
			var out:String = null;
			var v= values;
			var total:Float = 0;
			while (v.next != null)
			{
				v = v.next;
				if (!ASCompat.stringAsBool(out))
				{
					out = Std.string(v.value) + "\n";
				}
				else
				{
					out += v.value + "\n";
				}
			}
			if (!ASCompat.stringAsBool(out))
				out = "";
			return out;
		}

		@:flash.property public var lastValue(get,never):Float;
function  get_lastValue():Float
		{
			return _lastValue;
		}

	}

