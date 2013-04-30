package bg
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	public class ParallaxLayer extends FlxGroup
	{
		[Embed(source = '../res/bg-a.png')] private var _bg_a:Class;
		[Embed(source = '../res/bg-a1.png')] private var _bg_a1:Class;
		[Embed(source = '../res/bg-a2.png')] private var _bg_a2:Class;
		[Embed(source = '../res/bg-a3.png')] private var _bg_a3:Class;
		[Embed(source = '../res/bg-a4.png')] private var _bg_a4:Class;
		[Embed(source = '../res/bg-a5.png')] private var _bg_a5:Class;

		[Embed(source = '../res/bg-b.png')] private var _bg_b:Class;
		[Embed(source = '../res/bg-b1.png')] private var _bg_b1:Class;
		[Embed(source = '../res/bg-b2.png')] private var _bg_b2:Class;
		[Embed(source = '../res/bg-b3.png')] private var _bg_b3:Class;
		[Embed(source = '../res/bg-b4.png')] private var _bg_b4:Class;
		[Embed(source = '../res/bg-b5.png')] private var _bg_b5:Class;

		public static const BG_A:String = "A";
		public static const BG_B:String = "B";

		private var _bg:String;
		private var _ratio:Number;

		//private var _group:FlxGroup;
		private var _parts:Vector.<FlxSprite>;

		public function ParallaxLayer(ratio:Number, bg:String)
		{
			_ratio = ratio;
			_bg = bg;
			//_group = new FlxGroup();
			_parts = new Vector.<FlxSprite>;
			for (var x:int = 0; x < Main.SCREEN_X + 200; x += 200) {
				var sprite:FlxSprite = getNextPart(x);
				_parts.push(sprite);
				this.add(sprite);
			}
		}

		override public function update():void {
			// If the game is paused or ended, don't move the parallax layer
			if (Main.gamestate.paused || Main.gamestate.gameover) {
				return;
			}
			var offset:Number = Main.gamestate.distanceDelta * _ratio;
			for each (var sprite:FlxSprite in _parts) {
				sprite.x -= offset;
			}
			if (_parts[0].x + 200 < 0) {
				this.remove(_parts[0]);
				_parts.splice(0, 1);
			}
			if (_parts[_parts.length-1].x + 200 < Main.SCREEN_X + 100) {
				var spr:FlxSprite = getNextPart(_parts[_parts.length-1].x+200);
				_parts.push(spr);
				this.add(spr);
			}
		}

		private function getNextPart(offset:Number):FlxSprite {
			var n:int = 0;
			if (_bg == BG_A) {
				n = (int)(Math.random() * 5);
				switch(n) {
				case 0:
					return new FlxSprite(offset, Main.SCREEN_Y-200, _bg_a1);
				case 1:
					return new FlxSprite(offset, Main.SCREEN_Y-200, _bg_a2);
				case 2:
					return new FlxSprite(offset, Main.SCREEN_Y-200, _bg_a3);
				case 3:
					return new FlxSprite(offset, Main.SCREEN_Y-200, _bg_a4);
				case 4:
					return new FlxSprite(offset, Main.SCREEN_Y-200, _bg_a5);
				}
			} else if (_bg == BG_B) {
				n = (int)(Math.random() * 5);
				switch(n) {
				case 0:
					return new FlxSprite(offset, Main.SCREEN_Y-100, _bg_b1);
				case 1:
					return new FlxSprite(offset, Main.SCREEN_Y-100, _bg_b2);
				case 2:
					return new FlxSprite(offset, Main.SCREEN_Y-100, _bg_b3);
				case 3:
					return new FlxSprite(offset, Main.SCREEN_Y-100, _bg_b4);
				case 4:
					return new FlxSprite(offset, Main.SCREEN_Y-100, _bg_b5);
				}
			}
			return null;
		}
	}
}