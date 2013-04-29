package entities 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class Beam extends FlxSprite
	{
		[Embed(source = '../res/beam.png')] private var BeamImage:Class;
		
		private var _gamestate:GameState;
		
		public function Beam(X:Number, Y:Number, G:GameState) 
		{
			loadGraphic(BeamImage);
			_alpha = 0.8;
			_gamestate = G;
			this.x = X;
			this.y = Y;
		}
		
		override public function update():void {
			if (_alpha > 0) {
				alpha -= FlxG.elapsed*2;
			} else {
				alpha = 0;
			}
			x -= _gamestate._distace_delta/5;
		}
	}
}