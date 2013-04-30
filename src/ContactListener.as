package  
{
	import Box2D.Collision.Shapes.b2MassData;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Common.Math.b2Vec3;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Dynamics.Joints.b2WeldJointDef;
	import entities.B2FlxSprite;
	import entities.Beam;
	import entities.Platform;
	import entities.Player;
	import entities.Trash;
	import org.flixel.FlxPoint;
	import org.flixel.FlxG;
	import org.flixel.FlxCamera;
	import entities.Airplane;
	
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
						plane.fall()
					}
					_gamestate.DaMoon.MOONFall = true;
					var xp:Number = _gamestate._player.getScreenXY().x
					var xg:Number = _platformBody.GetWorldCenter().x * 30
					if (xp < xg && xg - xp > 95) {
						FlxG.score += 1;
						FlxG.shake(0.025, 0.2, null, true, FlxCamera.SHAKE_BOTH_AXES);
						FlxG.play(_score_sound);
						_gamestate.spawnBeam(xp,Main.SCREEN_Y-200);
					} else if (xp > xg && xp - xg > 95) {
						FlxG.score += 2;
						FlxG.shake(0.025, 0.2, null, true, FlxCamera.SHAKE_BOTH_AXES);
						FlxG.play(_score_sound);
						_gamestate.spawnBeam(xp,Main.SCREEN_Y-200);
					} else {
						FlxG.shake(0.01, 0.2, null, true, FlxCamera.SHAKE_VERTICAL_ONLY);
					}
					for each (var sprite:B2FlxSprite in _gamestate.scenery) {
						sprite._obj.SetAngularVelocity(Math.random() - 0.5);
						sprite._obj.SetLinearVelocity(new b2Vec2(sprite._obj.GetLinearVelocity().x, -3));
					}
					
					_platformBody.SetType(b2Body.b2_dynamicBody);
					_gamestate._player._obj.ApplyImpulse(new b2Vec2(_gamestate._player._obj.GetLinearVelocity().x, Math.sqrt(_gamestate._distace_traveled) * .1 + 7), _gamestate._player._obj.GetPosition());
					_gamestate.spawnBlood();
				}
				else if (_gamestate._player.getScreenXY().y > (_platformBody.GetWorldCenter().y*ratio-110))
				{
					_gamestate.endgame();
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
			if (contact.GetFixtureA().GetBody().GetUserData() == "ground"
					|| contact.GetFixtureB().GetBody().GetUserData() == "ground") {
				_ground = true;
				_platformBody = contact.GetFixtureA().GetBody().GetUserData() == "ground" ? contact.GetFixtureA().GetBody() : contact.GetFixtureB().GetBody()
			}
			if (contact.GetFixtureA().GetBody().GetUserData() == "player"
					|| contact.GetFixtureB().GetBody().GetUserData() == "player") {
				_player = true;
			}
		}
	}
}