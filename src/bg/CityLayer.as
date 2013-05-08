package bg 
{
	import org.flixel.FlxSprite;
	
	/**
	 * A ParallaxLayer background that looks like a cityscape.
	 */
	public class CityLayer extends ParallaxLayer
	{
		// [Embed(source = '../res/bg-b.png')] private var _bg_b:Class;
		[Embed(source = '../res/bg-b1.png')] private var _bg_b1:Class;
		[Embed(source = '../res/bg-b2.png')] private var _bg_b2:Class;
		[Embed(source = '../res/bg-b3.png')] private var _bg_b3:Class;
		[Embed(source = '../res/bg-b4.png')] private var _bg_b4:Class;
		[Embed(source = '../res/bg-b5.png')] private var _bg_b5:Class;
		
		private const SCREEN_Y:int = Main.SCREEN_Y;
		
		public function CityLayer(G:GameState, Ratio:Number) 
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
				return new FlxSprite(offset, SCREEN_Y-100, _bg_b1);
			case 1:
				return new FlxSprite(offset, SCREEN_Y-100, _bg_b2);
			case 2:
				return new FlxSprite(offset, SCREEN_Y-100, _bg_b3);
			case 3:
				return new FlxSprite(offset, SCREEN_Y-100, _bg_b4);
			case 4:
				return new FlxSprite(offset, SCREEN_Y-100, _bg_b5);
			}
			return null; // Should be unreachable
		}
	}
}