package com.yoctobits.spacemin 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	import com.yoctobits.spacemin.bg.CityLayer;
	import com.yoctobits.spacemin.bg.MountainLayer;
	import com.yoctobits.spacemin.entities.Airplane;
	import com.yoctobits.spacemin.entities.B2FlxSprite;
	import com.yoctobits.spacemin.entities.Beam;
	import com.yoctobits.spacemin.entities.Moon;
	import com.yoctobits.spacemin.entities.MovingParticle;
	import com.yoctobits.spacemin.entities.Player;
	import com.yoctobits.spacemin.entities.Scenery;
	import com.yoctobits.spacemin.ui.GameOverScreen;
	import com.yoctobits.spacemin.ui.StartScreen;
	import com.yoctobits.spacemin.util.Platforms;
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
		[Embed(source = "res/TestTrash.png")] private static const TrashImg:Class;
		[Embed(source = "res/gameover.mp3")] private static var GameOverSound:Class;
		
		[Embed(source="res/select.mp3")] private static var _select:Class;
		[Embed(source="res/activate.mp3")] private static var _activate:Class;
		
		// Game UI
		private var _score:FlxText = new FlxText(Main.SCREEN_X2 - 50, 60, 100, "0");
		private var _offscreen:FlxText = new FlxText(11, 5, 100, "0");
		private var _offscreen_disp:Boolean = false;
		
		public var _front_ui:FlxGroup;
		private var _gameoverScreen:GameOverScreen;
		private var _startScreen:StartScreen;
		
		// Pause UI
		private var _paused:Boolean = false;
		private var _title:FlxText = new FlxText(Main.SCREEN_X2-50, 20, 100, "PAUSED");
		private var _resume:FlxButton = new FlxButton(Main.SCREEN_X2 - 40, 100, "Resume", unpause);
		
		// Game Over UI
		private var _gameover:Boolean = false;
		private var _started:Boolean = false;
		
		// The total distance traveled
		private var _distance_traveled:Number;
		// The change in distance traveled
		private var _distace_delta:Number;
		
		// The physics world
		public var _world:b2World;
		// A list of b2Body physics objects to remove
		public var _toRemove:Vector.<b2Body>;
		
		// The player object
		public var _player:Player;
		
		// The platforms in the game
		public var _platforms:Platforms;
		
		public var bloodEmiter:FlxEmitter;
		public static var minParticleSize:Number = 3;
		public static var maxParticleSize:Number = 7;
		
		public var scenery:Vector.<Scenery>;
		public var sceneryGroup:FlxGroup;
		public var beams:FlxGroup;
		public var airplanes:FlxGroup;
		public var planeEmitter:FlxEmitter;
		
		private var _bga:MountainLayer;
		private var _bgb:CityLayer;
		
		public var DaMoon:Moon;
		
		override public function create():void
		{
			FlxG.bgColor = 0xFFFFBEBA;
			
			// Set up the world
			setupWorld();
			
			_toRemove = new Vector.<b2Body>();
			
			// UI initialization
			_score.setFormat(null, 16, 0xff7777, "center", 0);
			_offscreen.setFormat(null, 8, 0x663333, "center", 0);
			
			_title.setFormat(null, 16, 0xffffff, "center", 0);
			
			_front_ui = new FlxGroup();
			_gameoverScreen = new GameOverScreen(this);
			_startScreen = new StartScreen(this);
			
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
			
			// Add the layers in correct rendering order
			
			// Back Layer
			add(_score);
			add(_bga);
			add(DaMoon);
			add(moonEmitter);
			
			// Middle layer
			add(airplanes);
			add(planeEmitter);
			add(_bgb);
			
			// Front layer
			add(beams);
			add(sceneryGroup);
			
			add(bloodEmiter);
			
			_front_ui.add(_startScreen);
			add(_front_ui);
			
			// Reset game variables
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
		
		override public function update():void
		{
			if (!_started) {
				super.update();
				_world.Step(FlxG.elapsed, 6, 3);
				return;
			}
			if (_gameover) {
				_paused = false;
				super.update();
				_world.Step(FlxG.elapsed, 6, 3);
				return;
			}
			// Handle pause
			if (FlxG.keys.justPressed("ESCAPE")) {
				_paused = !_paused;
				if (_paused) {
					add(_title);
					add(setSounds(_resume));
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
				endGame();
			}
			
			// Spawn Platforms
			_platforms.update();
			
			_player._obj.SetPosition(new b2Vec2(2,_player._obj.GetPosition().y));
			
			_player._obj.SetLinearVelocity(new b2Vec2(3 +.80 * Math.sqrt(Math.sqrt(_distance_traveled)), _player._obj.GetLinearVelocity().y));
			_distace_delta = _player._obj.GetLinearVelocity().x;
			_world.Step(FlxG.elapsed, 6, 3);
			_distance_traveled += _distace_delta;
			
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
		}
		
		/** Starts the game */
		public function startGame():void {
			if (_started) {
				return;
			}
			_started = true;
			
			_front_ui.remove(_startScreen);
			
			_player = new Player(_world, this, 50, 150, 20, 20);
			add(_player);
			_platforms = new Platforms(_world, this);
			add(_platforms);
		}
		
		/** Restarts the game by switching to a new instance of GameState */
		public function restartGame():void {
			// Check if the game can be restarted
			if(!_gameover) {
				return;
			}
			
			// Start over
			FlxG.switchState(new GameState());
		}
		
		public function endGame():void {
			// Check if the game can be ended
			if (_gameover) {
				return;
			}
			_gameover = true;
			
			remove(_score);
			_gameoverScreen.score = FlxG.score;
			_front_ui.add(_gameoverScreen);
			
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
		
		public function get distanceTraveled():Number {
			return _distance_traveled;
		}
		
		public function get distanceDelta():Number {
			return _distace_delta;
		}
		
		private function setSounds(button:FlxButton):FlxButton
		{
			button.setSounds(_select, 1.0, null, 1.0, _activate, 1.0, null, 1.0);
			return button;
		}
	}
}