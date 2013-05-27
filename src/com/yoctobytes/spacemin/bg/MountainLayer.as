package com.yoctobytes.spacemin.bg 
{
	import com.yoctobytes.spacemin.GameState;
	import org.flixel.FlxSprite;
	
	/**
	 * A ParallaxLayer background that looks like mountains.
	 */
	public class MountainLayer extends ParallaxLayer
	{
		[Embed(source = "../res/bg1-a1.png")] private var _bg1:Class;
		[Embed(source = "../res/bg1-a2.png")] private var _bg2:Class;
		[Embed(source = "../res/bg1-a3.png")] private var _bg3:Class;
		[Embed(source = "../res/bg1-a4.png")] private var _bg4:Class;
		[Embed(source = "../res/bg1-a5.png")] private var _bg5:Class;
		
		private const SCREEN_X:int = com.yoctobytes.spacemin.Main.SCREEN_X;
		private const SCREEN_Y:int = com.yoctobytes.spacemin.Main.SCREEN_Y;
		
		public function MountainLayer(G:GameState, Ratio:Number) 
		{
			super(G, Ratio);
			
			// Initialize the layer
			for (var x:int = 0; x < SCREEN_X + 200; x += 200) {
				var sprite:FlxSprite = getNextPart(x);
				_parts.push(sprite);
				this.add(sprite);
			}
		}
		
		override public function update():void
		{
			super.update();
			
			// Add new part if necessary
			if (_parts[_parts.length-1].x + 200 < SCREEN_X + 100) {
				var spr:FlxSprite = getNextPart(_parts[_parts.length-1].x+200);
				_parts.push(spr);
				this.add(spr);
			}
		}
		
		private function getNextPart(offset:Number):FlxSprite
		{
			var n:int = (int)(Math.random() * 5);
			switch(n) {
			case 0:
				return new FlxSprite(offset, SCREEN_Y-200, _bg1);
			case 1:
				return new FlxSprite(offset, SCREEN_Y-200, _bg2);
			case 2:
				return new FlxSprite(offset, SCREEN_Y-200, _bg3);
			case 3:
				return new FlxSprite(offset, SCREEN_Y-200, _bg4);
			case 4:
				return new FlxSprite(offset, SCREEN_Y-200, _bg5);
			}
			return null; // Should be unreachable
		}
	}
}