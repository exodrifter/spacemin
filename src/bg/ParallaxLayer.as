package bg
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	public class ParallaxLayer extends FlxGroup
	{
		private var _gamestate:GameState;
		private var _ratio:Number;
		protected var _parts:Vector.<FlxSprite>;
		
		public function ParallaxLayer(G:GameState, ratio:Number)
		{
			_gamestate = G;
			_ratio = ratio;
			_parts = new Vector.<FlxSprite>;
		}

		override public function update():void
		{
			// If the game is paused or ended, don't move the parallax layer
			if (_gamestate.paused || _gamestate.gameover) {
				return;
			}
			var offset:Number = _gamestate.distanceDelta * _ratio;
			for each (var sprite:FlxSprite in _parts) {
				sprite.x -= offset;
			}
			if (_parts[0].x + 200 < 0) {
				this.remove(_parts[0]);
				_parts.splice(0, 1);
			}
		}
	}
}