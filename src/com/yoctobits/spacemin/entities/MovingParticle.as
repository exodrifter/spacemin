package com.yoctobits.spacemin.entities 
{
	import com.yoctobits.spacemin.GameState;
	import org.flixel.FlxParticle;
	
	public class MovingParticle extends FlxParticle
	{
		public var _gamestate:GameState;
		
		public function MovingParticle(G:GameState) 
		{
			_gamestate = G;
		}
		
		override public function update():void
		{
			super.update();
			if (alive)
			{
				x -= _gamestate.distanceDelta;
			}
		}
	}
}