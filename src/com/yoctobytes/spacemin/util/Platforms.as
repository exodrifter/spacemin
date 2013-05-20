package com.yoctobytes.spacemin.util 
{
	import Box2D.Dynamics.b2World;
	import com.yoctobytes.spacemin.Main;
	import com.yoctobytes.spacemin.GameState;
	import com.yoctobytes.spacemin.entities.Platform;
	import com.yoctobytes.spacemin.entities.Scenery;
	import org.flixel.FlxGroup;
	
	/**
	 * Manages the platforms in the game.
	 */
	public class Platforms extends FlxGroup
	{
		public var _platforms:Vector.<Platform>;
		public var _world:b2World;
		public var _gamestate:GameState;
		
		public var _minScenery:int = 1;
		public var _maxScenery:int = 6; 
		public var _platform_spawn_height:int = 230;
		
		private var _platform_timer:Timer;
		
		private var _screenX:Number = Main.SCREEN_X;
		private var _screenY:Number = Main.SCREEN_Y;
		
		public function Platforms(W:b2World, G:GameState) 
		{
			_platforms = new Vector.<Platform>();
			_world = W;
			_gamestate = G;
			
			// Initialize the first two platforms
			var floor:Platform = new Platform(_world, _gamestate, 0, 230);
			this.add(floor);
			_platforms.push(floor);
			var floor2:Platform = new Platform(_world, _gamestate, 300, 230);
			this.add(floor2);
			_platforms.push(floor2);
			
			_platform_timer = new Timer(1200, 350);
		}
		
		override public function update():void
		{
			super.update();
			if(_platform_timer.update(_gamestate.distanceDelta)) {
				spawnPlatform();
				_platform_timer._time *= 1.05;
			}
		}
		
		public function spawnPlatform():void
		{
			// Spawn platforms
			addPlatform(new Platform(_world, _gamestate, _screenX, randHeight()));
			
			// Spawn the scenery
			var numScene:int = Math.floor(Math.random() * (_maxScenery - _minScenery) + _minScenery);
			for (var g:int = 0; g < numScene; g++)
			{
				var newScenery:Scenery = new Scenery(_world, _gamestate, Math.random() * (250) + _screenX, _platform_spawn_height - 30);
				_gamestate.scenery.push(newScenery);
				_gamestate.sceneryGroup.add(newScenery);
			}
			
			// Spawn an airplane
			if (Math.random() > 0.85)
			{
				_gamestate.spawnAirplane(_screenX, 20 + 50 * Math.random());
			}
		}
		
		private function addPlatform(platform:Platform):void {
			_platforms.push(platform);
			this.add(platform);
		}
		
		private function randHeight():Number {
			_platform_spawn_height = 230 + (int)(Math.random() * 50) - 25
			if (_platform_spawn_height > _screenY-10) {
				_platform_spawn_height = _screenY-10;
			} else if (_platform_spawn_height < _screenY-100) {
				_platform_spawn_height = _screenY-100;
			}
			return _platform_spawn_height;
		}
	}
}