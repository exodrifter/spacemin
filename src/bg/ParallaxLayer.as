package bg
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	/**
	 * A ParallaxLayer is a background that can be composed of multiple images,
	 * called parts.
	 */
	public class ParallaxLayer extends FlxGroup
	{
		// A reference to the GameState that this ParallaxLayer belongs to
		private var _gamestate:GameState;
		// Ratio of ParallaxLayer movement to movement in the GameState
		private var _ratio:Number;
		// A vector of parts that currently make up this layer
		protected var _parts:Vector.<FlxSprite>;
		
		/**
		 * Creates a new ParallaxLayer. This constructor should only be called
		 * by classes that extend it.
		 * 
		 * @param	G		The gamestate that this ParallaxLayer belongs to
		 * @param	Ratio	The ratio that the ParallaxLayer will move in
		 * 					comparison to the movement in the game
		 */
		public function ParallaxLayer(G:GameState, Ratio:Number)
		{
			_gamestate = G;
			_ratio = Ratio;
			_parts = new Vector.<FlxSprite>;
		}
		
		/**
		 * Updates the ParallaxLayer's position and removes parts that are no
		 * longer needed to render the layer.
		 */
		override public function update():void
		{
			// If the game is paused or ended, don't move the parallax layer
			if (_gamestate.paused || _gamestate.gameover) {
				return;
			}
			
			// Move the layers
			var offset:Number = _gamestate.distanceDelta * _ratio;
			for each (var sprite:FlxSprite in _parts) {
				sprite.x -= offset;
			}
			
			// Remove parts that are no longer needed
			if (_parts[0].x + 200 < 0) {
				this.remove(_parts[0]);
				_parts.splice(0, 1);
			}
		}
	}
}