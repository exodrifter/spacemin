package entities 
{
	import org.flixel.FlxParticle;
	
	public class MovingParticle extends FlxParticle
	{
		public function MovingParticle() 
		{
			
		}
		
		override public function update():void
		{
			super.update();
			if (alive)
			{
				x -= Main.gamestate.distanceDelta;
			}
		}
	}
}