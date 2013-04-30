package entities 
{
	import org.flixel.FlxParticle;
	/**
	 * ...
	 * @author ...
	 */
	public class movingParticle extends FlxParticle
	{
		public var game:GameState;
		public function movingParticle(gamestate:GameState) 
		{
			game = gamestate;
		}
		
		override public function update():void
		{
			super.update();
			if (alive)
			{
				x -= game.distanceDelta;
			}
		}
	}

}