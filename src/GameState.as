package
{
	import bg.CityLayer;
	import bg.MountainLayer;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	import entities.Airplane;
	import entities.B2FlxSprite;
	import entities.Beam;
	import entities.Moon;
	import entities.MovingParticle;
	import entities.Platform;
	import entities.Player;
	import entities.Scenery;
	import org.flixel.FlxButton;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxParticle;
	import org.flixel.FlxPoint;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class GameState extends FlxState
	{
		[Embed(source = 'res/TestTrash.png')] private static const TrashImg:Class;
		[Embed(source="res/gameover.mp3")] private static var GameOverSound:Class;
		
		// Game UI
		private var _score:FlxText = new FlxText(Main.SCREEN_X2 - 50, 60, 100, "0");
		private var _distance:FlxText = new FlxText(Main.SCREEN_X2 - 50, 155, 100, "0");
		private var _offscreen:FlxText = new FlxText(11, 5, 100, "0");
		private var _offscreen_disp:Boolean = false;
		
		// Pause UI
		private var _paused:Boolean = false;
		private var _title:FlxText = new FlxText(Main.SCREEN_X2-50, 20, 100, "PAUSED");
		private var _resume:FlxButton = new FlxButton(Main.SCREEN_X2 - 40, 100, "Resume", unpause);
		private var _quit:FlxButton = new FlxButton(Main.SCREEN_X2 - 40, 120, "Quit", MenuState.toMenu);
		private var _settings:FlxButton = new FlxButton(Main.SCREEN_X2 - 40, 140, "Settings", MenuState.toSettings);
		
		// Game Over UI
		private var _front_ui_group:FlxGroup;
		private var _gameover:Boolean = false;
		private var _retry:FlxButton = new FlxButton(Main.SCREEN_X2 - 40, 200, "Retry", MenuState.toGame);
		private var _quitend:FlxButton = new FlxButton(Main.SCREEN_X2 - 40, 220, "Quit", MenuState.toMenu);
		private var _endtitle:FlxText = new FlxText(Main.SCREEN_X2 - 50, 20, 100, "GAME OVER");
		private var _finalscore:FlxText = new FlxText(Main.SCREEN_X2 - 200, 94, 400, "Points: ");
		private var _finaldistance:FlxText = new FlxText(Main.SCREEN_X2 - 200, 107, 400, "Distance: ");
		private var _finaltotal:FlxText = new FlxText(Main.SCREEN_X2 - 200, 120, 400, "Total: ");
		
		// The physics world
		public var _world:b2World;
		
		// The player object
		public var _player:Player;
		
		// The platforms in the game
		public var _platforms:Vector.<Platform>;
		public var _platform_group:FlxGroup;
		
		// A list of b2Body physics objects to remove
		public var _toRemove:Vector.<b2Body>;
		
		// The total distance traveled
		private var _distance_traveled:Number;
		// The change in distance traveled
		private var _distace_delta:Number;
		private var _platform_time:Number;
		private var _platform_timer:Number;
		
		public var bloodEmiter:FlxEmitter;
		public static var minParticleSize:Number = 3;
		public static var maxParticleSize:Number = 7;
		
		public var scenery:Vector.<Scenery>;
		public var sceneryGroup:FlxGroup;
		public var beams:FlxGroup;
		public var airplanes:FlxGroup;
		public var planeEmitter:FlxEmitter;
		public var potatoes:FlxGroup;
		
		private var _bga:MountainLayer;
		private var _bgb:CityLayer;
		
		public var DaMoon:Moon;
		
		override public function create():void
		{
			// Set up the world
			setupWorld();
			_gameover = false;
			
			_toRemove = new Vector.<b2Body>();
			
			// UI initialization
			_score.setFormat(null, 16, 0xff7777, "center", 0);
			_distance.setFormat(null, 8, 0x663333, "center", 0);
			_offscreen.setFormat(null, 8, 0x663333, "center", 0);
			
			_title.setFormat(null, 16, 0xffffff, "center", 0);
			
			_endtitle.setFormat(null, 16, 0xffffff, "center", 0);
			_finalscore.setFormat(null, 8, 0xffffff, "center", 0);
			_finaldistance.setFormat(null, 8, 0xffffff, "center", 0);
			_finaltotal.setFormat(null, 16, 0xffffff, "center", 0);
			_front_ui_group = new FlxGroup();
			
			scenery = new Vector.<Scenery>();
			sceneryGroup = new FlxGroup();
			
			bloodEmiter = new FlxEmitter(0, 0, 50);
			bloodEmiter.setXSpeed( -40, 80);
			bloodEmiter.setYSpeed(-80, -140);
			bloodEmiter.lifespan = .25;
			for ( var u:int = 0; u < 50; u++)
			{
				var particle:MovingParticle = new MovingParticle(this);
				var size:Number = Math.random() * (maxParticleSize - minParticleSize) + minParticleSize;
				particle.scale = new FlxPoint(size, size);
				particle.loadGraphic(TrashImg);
				particle.kill();
				bloodEmiter.add(particle);
			}
			
			// Backgrounds
			_bga = new MountainLayer(this, 0.25);
			_bgb = new CityLayer(this, 0.75);
			
			// Objects
			var moonEmitter:FlxEmitter = new FlxEmitter(0, 0, 40);
			moonEmitter.setYSpeed( -90, -200);
			moonEmitter.setXSpeed( -100, 60);
			moonEmitter.lifespan = 6;
			moonEmitter.gravity = 9.8 * 30 ;
			var maxPWidth:int = 15;
			var minPWidth:int = 4;
			for (var i:int = 0; i < 40; i++)
			{
				var particle2:FlxParticle = new FlxParticle();
				
				particle2.scale = new FlxPoint(Math.random() * (maxPWidth - minPWidth) + minPWidth, Math.random() * (maxPWidth - minPWidth) + minPWidth);
				particle2.loadGraphic(TrashImg);
				
				particle2.kill();
				moonEmitter.add(particle2);
			}
			DaMoon = new Moon(_world, this, 250, -60, moonEmitter);
			
			airplanes = new FlxGroup();
			
			planeEmitter = new FlxEmitter(0, 0, 40);
			planeEmitter.setYSpeed( -100, -150);
			planeEmitter.setXSpeed( -100, 60);
			planeEmitter.lifespan = 6;
			planeEmitter.gravity = 9.8 * 30 ;
			var maxWidth:int = 8;
			var minWidth:int = 3;
			for ( i = 0; i < 80; i++)
			{
				var particle3:FlxParticle = new FlxParticle();
				
				particle3.scale = new FlxPoint(Math.random() * (maxWidth - minWidth) + minWidth, Math.random() * (maxWidth - minWidth) + minWidth);
				particle3.loadGraphic(TrashImg);
				
				particle3.kill();
				planeEmitter.add(particle3);
			}
			
			beams = new FlxGroup();
			
			_player = new Player(_world, this, 50, 200, 20, 20);
			
			// Floor:
			_platforms = new Vector.<Platform>();
			_platform_group = new FlxGroup();
			var floor:Platform = new Platform(_world, this, 0, 230);
			_platform_group.add(floor);
			_platforms.push(floor);
			var floor2:Platform = new Platform(_world, this, 300, 230);
			_platform_group.add(floor2);
			_platforms.push(floor2);
			
			// Back Layer
			add(_score);
			add(_bga);
			add(DaMoon);
			add(moonEmitter);
			
			// Middle layer
			add(airplanes);
			add(planeEmitter);
			potatoes = new FlxGroup();
			add(potatoes);
			add(_distance);
			add(_bgb);
			
			// Front layer
			add(beams);
			add(sceneryGroup);
			
			add(_player);
			add(bloodEmiter);
			
			add(_platform_group);
			
			add(_front_ui_group);
			
			// Reset game variables
			_platform_time = 700;
			_platform_timer = 300;
			_distance_traveled = 0;
			_distace_delta = 0;
			FlxG.score = 0;
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
		
		public function spawnBeam(X:Number, Y:Number):void
		{
			beams.add(new Beam(this, X, Y));
		}
		
		public function spawnAirplane(X:Number, Y:Number):void
		{
			airplanes.add(new Airplane(_world, this, X, Y));
		}
		
		// Should be between 0 and 1
		public static var minScenery:int = 1;
		public static var maxScenery:int = 6; 
		
		private static var _platform_spawn_height:int = 230;
		
		public function spawnPlatform():void
		{
			// Spawn the platform
			_platform_spawn_height = 230 + (int)(Math.random() * 50) - 25
			if (_platform_spawn_height > Main.SCREEN_Y-10) {
				_platform_spawn_height = Main.SCREEN_Y-10;
			} else if (_platform_spawn_height < Main.SCREEN_Y-100) {
				_platform_spawn_height = Main.SCREEN_Y-100;
			}
			var platform:Platform = new Platform(_world, this, Main.SCREEN_X, _platform_spawn_height);
			_platforms.push(platform);
			_platform_group.add(platform);
			
			// Spawn the scenery
			var numScene:int = Math.floor(Math.random() * (maxScenery - minScenery) + minScenery);
			for (var g:int = 0; g < numScene; g++)
			{
				var newScenery:Scenery = new Scenery(_world, this, Math.random() * (250) + Main.SCREEN_X, _platform_spawn_height - 30);
				scenery.push(newScenery);
				sceneryGroup.add(newScenery);
			}
			
			// Spawn an airplane
			if (Math.random() > 0.85) {
				spawnAirplane(Main.SCREEN_X, 20 + 50 * Math.random());
			}
		}
		
		override public function update():void
		{
			if (_gameover) {
				_paused = false;
				FlxG.mouse.show();
				super.update();
				_world.Step(FlxG.elapsed, 6, 3);
				return;
			}
			// Handle pause
			if (FlxG.keys.justPressed("ESCAPE")) {
				_paused = !_paused;
				if (_paused) {
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
			
			// Update UI
			_score.text = "" + FlxG.score;
			if (_player.getScreenXY().y < 0 ) {
				add(_offscreen);
			} else {
				remove(_offscreen);
			}
			_offscreen.text = "" + ((int)(-_player.getScreenXY().y));
			
			// Handle end game
			if (_player.getScreenXY().y > Main.SCREEN_Y+20) {
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
			_player._obj.SetLinearVelocity(new b2Vec2(3 +.80 * Math.sqrt(Math.sqrt(_distance_traveled)), _player._obj.GetLinearVelocity().y));
			var ox:Number = _player._obj.GetWorldCenter().x;
			_world.Step(FlxG.elapsed, 6, 3);
			var nx:Number = _player._obj.GetWorldCenter().x;
			_distance_traveled += _distace_delta;
			_distance.text = ((int)(_distance_traveled/3000))+"."+((int)(_distance_traveled/3%1000/100))+" km";
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
			if (_gameover) {
				return;
			}
			remove(_distance);
			remove(_score);
			_gameover = true;
			_finalscore.text = "Points: " + FlxG.score;
			_finaldistance.text = "Distance: " + ((int)(_distance_traveled/3000)) + "." + ((int)(_distance_traveled/3%1000/100)) + " km";
			_finaltotal.text = "Total: " + (FlxG.score+(int)(_distance_traveled/3000));
			_front_ui_group.add(_endtitle);
			_front_ui_group.add(_finalscore);
			_front_ui_group.add(_finaldistance);
			_front_ui_group.add(_finaltotal);
			_front_ui_group.add(MenuState.setSounds(_retry));
			_front_ui_group.add(MenuState.setSounds(_quitend));
			
			// Halt the scenery
			for each (var sprite:B2FlxSprite in scenery) {
				sprite._obj.SetLinearVelocity(new b2Vec2(0, sprite._obj.GetLinearVelocity().y));
			}
			FlxG.play(GameOverSound);
		}
		
		public function get paused():Boolean {
			return _paused;
		}
		
		public function get gameover():Boolean {
			return _gameover;
		}
		
		public function get distanceDelta():Number {
			return _distace_delta;
		}
	}
}