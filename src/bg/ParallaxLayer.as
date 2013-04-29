package bg 
{
	import mx.core.FlexSprite;
	import org.flixel.FlxSprite;
	public class ParallaxLayer 
	{
		[Embed(source = 'res/bg-a1.png')] private var _bg_a1:Class;
		[Embed(source = 'res/bg-a2.png')] private var _bg_a2:Class;
		[Embed(source = 'res/bg-a3.png')] private var _bg_a3:Class;
		[Embed(source = 'res/bg-a4.png')] private var _bg_a4:Class;
		[Embed(source = 'res/bg-a5.png')] private var _bg_a5:Class;

		[Embed(source = 'res/bg-b.png')] private var _bg_a:Class;
		[Embed(source = 'res/bg-b1.png')] private var _bg_a1:Class;
		[Embed(source = 'res/bg-b2.png')] private var _bg_a2:Class;
		[Embed(source = 'res/bg-b3.png')] private var _bg_a3:Class;
		[Embed(source = 'res/bg-b4.png')] private var _bg_a4:Class;
		[Embed(source = 'res/bg-b5.png')] private var _bg_a5:Class;

		public static const BG_A:String = "A"; 
		public static const BG_B:String = "B"; 

		private var _ratio:Number;
		private var _gamestate:GameState;
		private var _bg:String;
		
		public function ParallaxLayer(gamestate:GameState, ratio:Number, bg:String) 
		{
			_ratio = ratio;
			_gamestate = gamestate;
			_bg = bg;
		}
		
		public function update() {
			offset = _gamestate._distace_delta;
		}
		
		public void getNextImage() {
			if (bg == BG_A) {
				var n:int = (int)(Math.random() * 5);
				switch(n) {
				case 0:
					return new FlxSprite(0, 0, _bg_a);
				}
			}
		}
	}
}