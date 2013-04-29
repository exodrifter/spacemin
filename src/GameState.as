package
{
	import adobe.utils.CustomActions;
	import Box2D.Dynamics.Joints.b2JointEdge;
	import org.flixel.*;
	import org.flixel.plugin.TimerManager;

	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	import entities.*;

	public class GameState extends FlxState
	{
		[Embed(source = 'res/box.png')] private var ImgCube:Class;
		[Embed(source = 'res/ball.png')] private var ImgBall:Class;
		[Embed(source = 'res/rect.png')] private var ImgRect:Class;
		
		[Embed(source="res/gameover.mp3")] private static var _gameover_sound:Class;
		[Embed(source="res/pickup.mp3")] private static var _pickup_sound:Class;

		// Game UI
		private var _score:FlxText = new FlxText(Main.SCREEN_X2 - 50, 70, 100, "0");

		// Is the game paused?
		public var _paused:Boolean = false;
		// Pause Menu
		private var _title:FlxText = new FlxText(Main.SCREEN_X2-50, 20, 100, "PAUSED");
		private var _resume:FlxButton = new FlxButton(Main.SCREEN_X2 - 40, 100, "Resume", unpause);
		private var _quit:FlxButton = new FlxButton(Main.SCREEN_X2 - 40, 120, "Quit", MenuState.toMenu);
		private var _settings:FlxButton = new FlxButton(Main.SCREEN_X2 - 40, 140, "Settings", MenuState.toSettings);
		
		// Has the game ended?
		public var _endgame:Boolean = false;
		private var _retry:FlxButton = new FlxButton(Main.SCREEN_X2 - 40, 100, "Retry", MenuState.toGame);
		private var _endtitle:FlxText = new FlxText(Main.SCREEN_X2-50, 20, 100, "GAME OVER");
		
		// The physics world
		public var _world:b2World;

		// Ratio of pixels to meters
		public static const RATIO:Number = 30;
		
		// The player object
		public var _player:Player;
		// The platforms in the game
		public var _platforms:Vector.<Platform>;
		
		public var _toRemove:Vector.<b2Body>;
		
		public static var debug:Boolean;

		public var _platform_time:Number;
		public var _platform_timer:Number;
		
		override public function create():void
		{
			// Set up the world
			setupWorld();
			_endgame = false;
			
			_toRemove = new Vector.<b2Body>();

			// UI:
			_score.setFormat(null, 16, 0xffffff, "center", 0);
			add(_score)

			// Player:
			_player = new Player(50, 200, 20, 20, _world, this);
			this.add(_player);

			// Floor:
			_platforms = new Vector.<Platform>();
			var floor:Platform = new Platform(0, 230, _world, _player);
			this.add(floor);
			_platforms.push(floor);
			var floor2:Platform = new Platform(300, 230, _world, _player);
			this.add(floor2);
			_platforms.push(floor2);
			_platform_time = 2;
			_platform_timer = 0;
			FlxG.score = 0;
			}

		// Should be between 0 and 1
		public static var minTrash:int = 3;
		public static var maxTrash:int = 7;
		
		private static var _platform_spawn_height:int = 230;
		
		public function spawnPlatform():void
		{
			_platform_spawn_height = 230 + (int)(Math.random() * 50) - 25
			if (_platform_spawn_height > Main.SCREEN_Y-10) {
				_platform_spawn_height = Main.SCREEN_Y-10;
			} else if (_platform_spawn_height < Main.SCREEN_Y-100) {
				_platform_spawn_height = Main.SCREEN_Y-100;
			}
			var platform:Platform = new Platform(Main.SCREEN_X, _platform_spawn_height, _world, _player);
			_platforms.push(platform);
			this.add(platform);
		}
		
		override public function update():void
		{
			if (_endgame) {
				_paused = false;
				FlxG.mouse.show();
				super.update();
				return;
			}
			// Handle pause
			if (FlxG.keys.justPressed("ESCAPE")) {
				_paused = !_paused;
				if (_paused) {
					_title.setFormat(null, 16, 0xffffff, "center", 0);
					add(_title);
					add(MenuState.setSounds(_resume));
					add(MenuState.setSounds(_quit));
					add(MenuState.setSounds(_settings));
				} else {
					unpause();
				}
			}
			if (_paused) {
				FlxG.mouse.show();
				super.update();
				return;
			} else {
				FlxG.mouse.hide();
			}
			
			_score.text = ""+FlxG.score;
			
			// Handle end game
			if (_player.getScreenXY().y > Main.SCREEN_Y) {
				endgame();
			}
			
			// Spawn Platforms
			if(_platform_timer > _platform_time) {
				spawnPlatform();
				_platform_timer = 0;
				_platform_time += 0.1;
			}
			_platform_timer += FlxG.elapsed;
		
			if (_player._obj.GetPosition().x > 2 || _player._obj.GetPosition().x < 2) {
				_player._obj.SetPosition(new b2Vec2(2,_player._obj.GetPosition().y));
			}

			
			_player._obj.SetLinearVelocity(new b2Vec2(3 + 50 * _player._weight, _player._obj.GetLinearVelocity().y));
			_world.Step(FlxG.elapsed, 6, 3);
			super.update();
			while (_toRemove.length != 0)
			{
				_world.DestroyBody(_toRemove.pop());
			}
		}

		private function setupWorld():void
		{
			//gravity
			var gravity:b2Vec2 = new b2Vec2(0, 15);

			//Ignore sleeping objects
			var ignoreSleeping:Boolean = true;

			_world = new b2World(gravity, ignoreSleeping);
			_world.SetContinuousPhysics(false);
			// Setup collision callbacks
			var contactListener:ContactListener = new ContactListener(this);
            _world.SetContactListener(contactListener);
		}
		
		private function unpause():void {
			_paused = false;
			remove(_title);
			remove(_resume);
			remove(_quit);
			remove(_settings);
		}
		
		public function endgame():void {
			if (_endgame) {
				return;
			}
			_endgame= true;
			_endtitle.setFormat(null, 16, 0xffffff, "center", 0);
			add(_endtitle);
			add(_retry);
			add(_quit);
			FlxG.play(_gameover_sound);
		}
	}
}