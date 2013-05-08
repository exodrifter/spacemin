package bg 
{
	import org.flixel.FlxSprite;
	
	/**
	 * A ParallaxLayer background that looks like mountains.
	 */
	public class MountainLayer extends ParallaxLayer
	{
		[Embed(source = '../res/bg-a1.png')] private var _bg_a1:Class;
		[Embed(source = '../res/bg-a2.png')] private var _bg_a2:Class;
		[Embed(source = '../res/bg-a3.png')] private var _bg_a3:Class;
		[Embed(source = '../res/bg-a4.png')] private var _bg_a4:Class;
		[Embed(source = '../res/bg-a5.png')] private var _bg_a5:Class;
		
		private const SCREEN_Y:int = Main.SCREEN_Y;
		
		public function MountainLayer(G:GameState, Ratio:Number) 
		{
			super(G, Ratio);
			
			// Initialize the layer
			for (var x:int = 0; x < Main.SCREEN_X + 200; x += 200) {
				var sprite:FlxSprite = getNextPart(x);
				_parts.push(sprite);
				this.add(sprite);
			}
		}
		
		override public function update():void
		{
			super.update();
			
			// Add new part if necessary
			if (_parts[_parts.length-1].x + 200 < Main.SCREEN_X + 100) {
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
				return new FlxSprite(offset, SCREEN_Y-200, _bg_a1);
			case 1:
				return new FlxSprite(offset, SCREEN_Y-200, _bg_a2);
			case 2:
				return new FlxSprite(offset, SCREEN_Y-200, _bg_a3);
			case 3:
				return new FlxSprite(offset, SCREEN_Y-200, _bg_a4);
			case 4:
				return new FlxSprite(offset, SCREEN_Y-200, _bg_a5);
			}
			return null; // Should be unreachable
		}
	}
}