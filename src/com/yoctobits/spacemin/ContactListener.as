package com.yoctobits.spacemin 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.Contacts.b2Contact;
	import com.yoctobits.spacemin.entities.Airplane;
	import com.yoctobits.spacemin.entities.B2FlxSprite;
	import com.yoctobits.spacemin.entities.EntityEnum;
	import com.yoctobits.spacemin.entities.Platform;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	
	/**
	 * Contains a few callbacks that are used to check for certain collisions
	 */
	public class ContactListener extends b2ContactListener
	{
		[Embed(source = "res/ground.mp3")] private static var _ground_sound:Class;
		[Embed(source="res/score.mp3")] private static var _score_sound:Class;
		
		private var _gamestate:GameState;
		
		private var _ground:Boolean, _player:Boolean;
		
		private var _platformBody:b2Body;
		
		private var _platform:Platform;
		
		private var ratio:Number = 30;
		
		public function ContactListener(gamestate:GameState) 
		{
			_gamestate = gamestate
		}
		
		/**
		 * Called when two fixtures begin to touch.
		 */
		override public function BeginContact(contact:b2Contact):void
		{
			DetectContact(contact);
			
			if (_player && _ground) {
				if (_gamestate._player.isLanding()) {
					for each(var plane:Airplane in _gamestate.airplanes.members) {
						if(plane!=null)
							plane.fall();
					}
					_gamestate.DaMoon.MOONFall = true;
					var xp:Number = _gamestate._player.getScreenXY().x
					var xg:Number = _platformBody.GetWorldCenter().x * 30
					var SLAM:Number = 0;
					if (xp < xg && xg - xp > _platform.width/2 - _platform.leftEdge) {
						FlxG.score += 1;
						SLAM = 2;
						FlxG.shake(0.025, 0.2, null, true, FlxCamera.SHAKE_BOTH_AXES);
						FlxG.play(_score_sound);
						_gamestate.spawnBeam(xp,Main.SCREEN_Y-200);
					} else if (xp > xg && xp - xg > _platform.width/2 - _platform.rightEdge) {
						FlxG.score += 2;
						SLAM = 2;
						FlxG.shake(0.025, 0.2, null, true, FlxCamera.SHAKE_BOTH_AXES);
						FlxG.play(_score_sound);
						_gamestate.spawnBeam(xp,Main.SCREEN_Y-200);
					} else {
						SLAM = 1;
						FlxG.shake(0.01, 0.2, null, true, FlxCamera.SHAKE_VERTICAL_ONLY);
					}
					for each (var sprite:B2FlxSprite in _gamestate.scenery) {
						sprite._obj.SetAngularVelocity(Math.random() * SLAM - 0.5);
						sprite._obj.SetLinearVelocity(new b2Vec2(sprite._obj.GetLinearVelocity().x, -3 - SLAM));
					}
					
					_platformBody.SetType(b2Body.b2_dynamicBody);
					_gamestate._player._obj.ApplyImpulse(new b2Vec2(_gamestate._player._obj.GetLinearVelocity().x, Math.sqrt(_gamestate.distanceDelta) * .1 + 7), _gamestate._player._obj.GetPosition());
					_gamestate.spawnBlood();
				}
				else if (_gamestate._player.getScreenXY().y > (_platformBody.GetWorldCenter().y*ratio-110))
				{
					_gamestate.endGame();
				}
				_gamestate._player.ground(true);
				FlxG.play(_ground_sound);
			}
		}
		
		/**
		 * Called when two fixtures cease to touch.
		 */
		override public function EndContact(contact:b2Contact):void
		{
			DetectContact(contact)
			
			if (_player && _ground) 
				_gamestate._player.ground(false);
		}
		
		private function DetectContact(contact:b2Contact):void
		{
			_ground = false;
			_player = false;
			
			var a:B2FlxSprite = contact.GetFixtureA().GetBody().GetUserData() as B2FlxSprite;
			var b:B2FlxSprite = contact.GetFixtureB().GetBody().GetUserData() as B2FlxSprite;
			
			if ( a != null && a._enum.id == EntityEnum.PLATFORM.id)
			{
				_ground = true;
				_platformBody = contact.GetFixtureA().GetBody();
				_platform = contact.GetFixtureA().GetBody().GetUserData() as Platform;
			}
			else if (b != null && b._enum.id == EntityEnum.PLATFORM.id)
			{
				_ground = true;
				_platformBody = contact.GetFixtureB().GetBody()
				_platform = contact.GetFixtureB().GetBody().GetUserData() as Platform;
			}
			if ((a != null && a._enum.id == EntityEnum.PLAYER.id )|| (b != null && b._enum.id == EntityEnum.PLAYER.id))
			{
				_player = true;
			}
		}
	}
}