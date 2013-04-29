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

		// Is the game paused?
		public var _paused:Boolean = false;
		// Pause Menu
		private var _title:FlxText = new FlxText(Main.SCREEN_X2-50, 20, 100, "PAUSED");
		private var _resume:FlxButton = new FlxButton(Main.SCREEN_X2 - 40, 100, "Resume", unpause);
		private var _quit:FlxButton = new FlxButton(Main.SCREEN_X2 - 40, 120, "Quit", MenuState.toMenu);
		private var _settings:FlxButton = new FlxButton(Main.SCREEN_X2 - 40, 140, "Settings", MenuState.toSettings);
		
		// Has the game ended?
		public var _endgame:Boolean = false;
		private var _endtitle:FlxText = new FlxText(Main.SCREEN_X2-50, 20, 100, "GAME OVER");
		
		// The physics world
		public var _world:b2World;

		// Ratio of pixels to meters
		public static const RATIO:Number = 30;
		
		// The player object
		public var _player:Player;
		// The trash in the game
		public var _trash:Vector.<Trash>;
		// The platforms in the game
		public var _platforms:Vector.<Platform>;
		
		public var _toRemove:Vector.<b2Body>;
		
		public var _toAddToPlayer:Vector.<b2FixtureDef>;
		
		public static var debug:Boolean;

		public var _platform_time:Number;
		public var _platform_timer:Number;
		
		override public function create():void
		{
			// Set up the world
			setupWorld();
			_endgame = false;
			
			_toRemove = new Vector.<b2Body>();
			_toAddToPlayer = new Vector.<b2FixtureDef>();

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

			FlxG.camera.antialiasing = true;
			
			_trash = new Vector.<Trash>();
			while (_trash.length != 15)
				spawnTrash(_trash, _world);
		}

		// Should be between 0 and 1
		public var spawnRate:Number = .98;
		
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
		
		public function spawnTrash(list:Vector.<Trash>, W:b2World):void
		{
			if (Math.random() > spawnRate)
			{
				var newTrash:Trash = new Trash((Math.random() * (FlxG.width + 1)), W, _player);
				list.push(newTrash);
				this.add(newTrash);
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
					FlxG.camera.antialiasing = false;
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
			
			
			var playerJoints:b2JointEdge = _player._obj.GetJointList();
			var count:int = 1;
			if(playerJoints != null)
				while (playerJoints.next != null )
				{
					count++;
					playerJoints = playerJoints.next;
				}
				
			for (var i:int = 0; i < _trash.length;i++ )
			{
				if (_trash[i].x < 0)
				{
					_toRemove.push(_trash[i]._obj);
					_trash[i].destroy();
					_trash[i].kill();
					_trash.splice(i, 1);
				}
			}
		
			if (_player._obj.GetPosition().x > 2 || _player._obj.GetPosition().x < 2) {
				_player._obj.SetPosition(new b2Vec2(2,_player._obj.GetPosition().y));
			}
			
			_player._obj.SetLinearVelocity(new b2Vec2(3 + 0.75 * _player._weight, _player._obj.GetLinearVelocity().y));
			_world.Step(FlxG.elapsed, 6, 3);
			super.update();
			spawnTrash(_trash, _world);
			while (_toRemove.length != 0)
			{
				_world.DestroyBody(_toRemove.pop());
			}
			if (_toAddToPlayer.length > 0) {
				FlxG.play(_pickup_sound);
			}
			while (_toAddToPlayer.length != 0)
			{
				var huh:ShapeSprite = new ShapeSprite();
				var j:b2FixtureDef = _toAddToPlayer.pop();
				huh._fixture = _player._obj.CreateFixture(j);
				_player._weight += 1;
				add(huh);
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
			FlxG.camera.antialiasing = true;
		}
		
		public function endgame():void {
			if (_endgame) {
				return;
			}
			_endgame= true;
			_endtitle.setFormat(null, 16, 0xffffff, "center", 0);
			add(_endtitle);
			add(_quit);
			FlxG.play(_gameover_sound);
			FlxG.camera.antialiasing = false;
		}
	}
}