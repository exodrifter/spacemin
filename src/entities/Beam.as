package entities 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class Beam extends FlxSprite
	{
		[Embed(source = '../res/beam.png')] private var BeamImage:Class;
		
		public function Beam(X:Number, Y:Number) 
		{
			loadGraphic(BeamImage);
			_alpha = 0.8;
			this.x = X;
			this.y = Y;
		}
		
		override public function update():void {
			if (_alpha > 0) {
				alpha -= FlxG.elapsed*2;
			} else {
				alpha = 0;
			}
			x -= Main.gamestate.distanceDelta/5;
			if(x+30 < 0)
				Main.gamestate.beams.remove(this);
		}
	}
}