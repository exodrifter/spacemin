package
{
	import adobe.utils.CustomActions;
	import bg.ParallaxLayer;
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
		[Embed(source = 'res/TestTrash.png')] private var TrashImage:Class;
		[Embed(source = 'res/plane.png')] private var plane:Class;
		[Embed(source = 'res/Moon.png')] private var Moon:Class;
		[Embed(source = 'res/house.png')] private var house:Class;
		[Embed(source = 'res/car.png')] private var car:Class;
		

		[Embed(source="res/gameover.mp3")] private static var _gameover_sound:Class;
		[Embed(source="res/pickup.mp3")] private static var _pickup_sound:Class;

		// Game UI
		private var _score:FlxText = new FlxText(Main.SCREEN_X2 - 50, 60, 100, "0");
		private var _distance:FlxText = new FlxText(Main.SCREEN_X2 - 50, 155, 100, "0");

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
		private var _finalscore:FlxText = new FlxText(Main.SCREEN_X2 - 50, 60, 100, "0");

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

		// The total distance traveled
		public var _distace_traveled:Number;
		// The change is distance traveled
		public var _distace_delta:Number;
		public var _platform_time:Number;
		public var _platform_timer:Number;

		public var bloodEmiter:FlxEmitter;
		public static var minParticleSize:Number = 3;
		public static var maxParticleSize:Number = 7;

		public var scenery:Vector.<B2FlxSprite>;
		public var sceneryImages:Vector.<Class>;

		private var _bga:ParallaxLayer;
		private var _bgb:ParallaxLayer;
		
		public var MOON:B2FlxSprite;
		public var moonFall:Boolean = false;

		override public function create():void
		{
			// Set up the world
			setupWorld();
			_endgame = false;

			_toRemove = new Vector.<b2Body>();

			// UI:
			_score.setFormat(null, 16, 0xff7777, "center", 0);
			add(_score);

			scenery = new Vector.<B2FlxSprite>();

			sceneryImages = new Vector.<Class>();
			sceneryImages.push(house,car);
			bloodEmiter = new FlxEmitter(0, 0, 50);
			bloodEmiter.setXSpeed( -190, -30);
			bloodEmiter.setYSpeed(-100, -125);
			bloodEmiter.lifespan = .25;
			for ( var u:int = 0; u < 50; u++)
			{
				var particle:movingParticle = new movingParticle(this);
				var size:Number = Math.random() * (maxParticleSize - minParticleSize) + minParticleSize;
				particle.scale = new FlxPoint(size, size);
				particle.loadGraphic(TrashImage);
				particle.kill();
				bloodEmiter.add(particle);
			}

			// Backgrounds
			_bga = new ParallaxLayer(this, 0.25, ParallaxLayer.BG_A);
			_distance.setFormat(null, 8, 0x663333, "center", 0);
			add(_distance);
			_bgb = new ParallaxLayer(this, 0.75, ParallaxLayer.BG_B);
			add(_bga);
			add(_bgb);

			// Player:
			_player = new Player(50, 200, 20, 20, _world, this);
			this.add(_player);
			add(bloodEmiter);

			// Floor:
			_platforms = new Vector.<Platform>();
			var floor:Platform = new Platform(0, 230, _world, _player, this);
			this.add(floor);
			_platforms.push(floor);
			var floor2:Platform = new Platform(300, 230, _world, _player, this);
			this.add(floor2);
			_platforms.push(floor2);

			// Reset game variables
			_platform_time = 700;
			_platform_timer = 300;
			FlxG.score = 0;
			_distace_traveled = 0;
			_distace_delta = 0;
		}

		public function spawnBlood():void
		{
			var numOfParticles:int = Math.random() * (10 - 4) + 4;
			bloodEmiter.at(_player);
			for ( var i:int = 0; i < numOfParticles; i++)
			{
				bloodEmiter.emitParticle();
			}
		}

		// Should be between 0 and 1
		public static var minScenery:int = 0;
		public static var maxScenery:int = 4; 
		
		private static var _platform_spawn_height:int = 230;

		public function spawnPlatform():void
		{
			_platform_spawn_height = 230 + (int)(Math.random() * 50) - 25
			if (_platform_spawn_height > Main.SCREEN_Y-10) {
				_platform_spawn_height = Main.SCREEN_Y-10;
			} else if (_platform_spawn_height < Main.SCREEN_Y-100) {
				_platform_spawn_height = Main.SCREEN_Y-100;
			}
			var platform:Platform = new Platform(Main.SCREEN_X, _platform_spawn_height, _world, _player, this);
			_platforms.push(platform);
			this.add(platform);
			var numScene:int = Math.floor(Math.random() * (maxScenery - minScenery) + minScenery);
			for (var g:int; g < numScene; g++)
			{
				var newScenery:B2FlxSprite = new B2FlxSprite(Math.random() * (250) + Main.SCREEN_X, _platform_spawn_height - 30, 40, 40, _world);
				newScenery.loadGraphic(sceneryImages[Math.floor(Math.random() * sceneryImages.length)]);
				newScenery._width = newScenery.width;
				newScenery._height = newScenery.height;
				newScenery._fixDef.filter = Player.playerFilter;
				newScenery.createBody();
				scenery.push(newScenery);
				add(newScenery);
				newScenery._obj.SetLinearVelocity(new b2Vec2(-_player._obj.GetLinearVelocity().x, newScenery._obj.GetLinearVelocity().y));
				trace(scenery.length);
			}
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
				_platform_time = _platform_time * 1.05;
			}
			_platform_timer += _distace_delta;

			if (_player._obj.GetPosition().x > 2 || _player._obj.GetPosition().x < 2) {
				_player._obj.SetPosition(new b2Vec2(2,_player._obj.GetPosition().y));
			}

			_distace_delta = _player._obj.GetLinearVelocity().x;
			_player._obj.SetLinearVelocity(new b2Vec2(3 +.75 *Math.sqrt(Math.sqrt(_distace_traveled)), _player._obj.GetLinearVelocity().y));
			var ox:Number = _player._obj.GetWorldCenter().x;
			_world.Step(FlxG.elapsed, 6, 3);
			var nx:Number = _player._obj.GetWorldCenter().x;
			_distace_traveled += _distace_delta;
			_distance.text = "" + ((int)(_distace_traveled));
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
			remove(_distance);
			_endgame = true;
			_finalscore.setFormat(null, 16, 0xffffff, "center", 0);
			_finalscore.text = "" + FlxG.score;
			_endtitle.setFormat(null, 16, 0xffffff, "center", 0);
			add(_endtitle);
			add(_finalscore);
			add(_retry);
			add(_quit);
			FlxG.play(_gameover_sound);
		}
	}
}