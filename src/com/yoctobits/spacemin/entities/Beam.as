package com.yoctobits.spacemin.entities 
{
	import com.yoctobits.spacemin.GameState;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class Beam extends FlxSprite
	{
		[Embed(source = "../res/beam.png")] public const Img:Class;
		
		public var _gamestate:GameState;
		
		public function Beam(G:GameState, X:Number, Y:Number) 
		{
			super(X, Y, Img);
			_gamestate = G;
			_alpha = 0.8;
		}
		
		override public function update():void {
			if (_alpha > 0) {
				alpha -= FlxG.elapsed*2;
			} else {
				alpha = 0;
			}
			x -= _gamestate.distanceDelta/5;
			if(x+30 < 0)
				_gamestate.beams.remove(this);
		}
	}
}