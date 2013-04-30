package entities 
{
	import org.flixel.FlxParticle;
	
	public class movingParticle extends FlxParticle
	{
		public function movingParticle() 
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