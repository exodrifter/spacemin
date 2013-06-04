package com.yoctobits.spacemin.util 
{
	import org.flixel.FlxG;
	
	/**
	 * The timer can record a specific aount of time repeatedly.
	 */
	public class Timer
	{
		/* The amount of time to record */
		public var _time:Number;
		/* The amount of time elapsed */
		public var _elapsed:Number;
		
		public function Timer(Time:Number, Elapsed:Number = 0)
		{
			_time = Time;
			_elapsed = Elapsed;
		}
		
		public function update(Delta:Number):Boolean
		{
			_elapsed += Delta;
			var ret:Boolean = false;
			if (_time < _elapsed) {
				ret = true;
				_elapsed = 0;
			}
			return ret;
		}
	}

}