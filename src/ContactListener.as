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
	import entities.Platform;
	import entities.Player;
	import entities.Trash;
	
	/**
	 * Contains a few callbacks that are used to check for certain collisions
	 */
	public class ContactListener extends b2ContactListener
	{
		private var _gamestate:GameState;
		
		private var _ground:Boolean, _player:Boolean, _trash:Boolean;
		
		private var _platformBody:b2Body, _trashBody:b2Body, _touchedTrash:b2Body;
		
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
				if (_gamestate._player.getScreenXY().y > (_platformBody.GetWorldCenter().y*ratio-100))
				{
					_gamestate.endgame();
				}
				_gamestate._player.ground(true);
			}
			
			if (_player && _trash) {
				var worthless:Boolean = false;
				for (var q:int = 0; q < _gamestate._trash.length; q++)
				{
					if (_gamestate._trash[q]._obj == _trashBody && !_gamestate._trash[q].alive)
					{
						worthless = true;
					}
				}
				if (!worthless)
				{
					//	var weldJointDef:b2WeldJointDef = new b2WeldJointDef();
					//	weldJointDef.Initialize(_touchedTrash, _trashBody, _touchedTrash.GetWorldCenter());
					//	_gamestate._world .CreateJoint(weldJointDef);
					var newTrashDef:b2FixtureDef = new b2FixtureDef();
					var newTrashShape:b2PolygonShape = new b2PolygonShape();
					var newTrashPosition:b2Vec2 = _trashBody.GetWorldCenter().Copy();
					
					newTrashPosition.Subtract(_gamestate._player._obj.GetPosition());
					
					var x:Number = newTrashPosition.x;
					var y:Number = newTrashPosition.y;
					newTrashPosition.x = x * Math.cos(-_gamestate._player._obj.GetAngle()) - y * Math.sin(-_gamestate._player._obj.GetAngle());
					newTrashPosition.y = x * Math.sin(-_gamestate._player._obj.GetAngle()) + y * Math.cos(-_gamestate._player._obj.GetAngle());

					newTrashShape.SetAsOrientedBox(Trash._width/2/ratio, Trash._height/2/ratio,newTrashPosition);
					newTrashDef.density = _trashBody.GetFixtureList().GetDensity();
					newTrashDef.shape = newTrashShape;
					newTrashDef.filter = Player.playerFilter.Copy();
					newTrashDef.friction = _touchedTrash.GetFixtureList().GetFriction();
					newTrashDef.restitution = _touchedTrash.GetFixtureList().GetRestitution();
					_gamestate._toAddToPlayer.push(newTrashDef);
					for (q = 0; q < _gamestate._trash.length; q++)
					{
						if (_gamestate._trash[q]._obj == _trashBody)
						{
							_gamestate._toRemove.push(_gamestate._trash[q]._obj);
							_gamestate._trash[q].destroy();
							_gamestate._trash[q].kill();
					
							_gamestate._trash.splice(q, 1);
						}
					}
					/*
					var newTrashDef:b2FixtureDef = new b2FixtureDef();
					var fuckingStuff:b2PolygonShape = new b2PolygonShape();
					var iHateAS3:b2Vec2 = _trashBody.GetPosition().Copy();
					iHateAS3.Subtract(_gamestate._player._obj.GetWorldCenter());
					fuckingStuff.SetAsOrientedBox(Trash._width/2/ratio, Trash._height/2/ratio, iHateAS3, -_gamestate._player._obj.GetAngle());
					newTrashDef.shape = fuckingStuff;
					newTrashDef.density = _trashBody.GetFixtureList().GetDensity();
					newTrashDef.filter = Player.playerFilter.Copy();
					newTrashDef.friction = _touchedTrash.GetFixtureList().GetFriction();
					newTrashDef.restitution = _touchedTrash.GetFixtureList().GetRestitution();
					_gamestate._toAddToPlayer.push(newTrashDef);
					for (var q:int = 0; q < _gamestate._trash.length; q++)
					{
						if (_gamestate._trash[q]._obj == _trashBody)
						{
							_gamestate._toRemove.push(_gamestate._trash[q]._obj);
							_gamestate._trash[q].destroy();
							_gamestate._trash[q].kill();
					
							_gamestate._trash.splice(q, 1);
						}
					}
				*/
				}
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
			_trash = false;
			if (contact.GetFixtureA().GetBody().GetUserData() == "ground"
					|| contact.GetFixtureB().GetBody().GetUserData() == "ground") {
				_ground = true;
				_platformBody = contact.GetFixtureA().GetBody().GetUserData() == "ground" ? contact.GetFixtureA().GetBody() : contact.GetFixtureB().GetBody()
			}
			if (contact.GetFixtureA().GetBody().GetUserData() == "player"
					|| contact.GetFixtureB().GetBody().GetUserData() == "player") {
				_player = true;
			}
			if (contact.GetFixtureA().GetBody().GetUserData() == "trash")
			{
				_trash = true;
				_trashBody = contact.GetFixtureA().GetBody();
				_touchedTrash = contact.GetFixtureB().GetBody();

			}
			if (contact.GetFixtureB().GetBody().GetUserData() == "trash") {
				_trash = true;
				_trashBody = contact.GetFixtureB().GetBody();
				_touchedTrash = contact.GetFixtureA().GetBody();

			}
		}
	}
}