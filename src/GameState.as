package
{
	import adobe.utils.CustomActions;
	import Box2D.Dynamics.Joints.b2JointEdge;
	import org.flixel.*;

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

		// The physics world
		public var _world:b2World;

		// Ratio of pixels to meters
		public static const RATIO:Number = 30;
		
		// The player object
		public var _player:Player;
		// The trash in the game
		public var _trash:Vector.<Trash>;
		
		public var _toRemove:Vector.<b2Body>;
		
		public var _toAddToPlayer:Vector.<b2FixtureDef>;

		override public function create():void
		{
			// Set up the world
			setupWorld();
			
			_toRemove = new Vector.<b2Body>();
			_toAddToPlayer = new Vector.<b2FixtureDef>();

			// Floor:
			var floor:Platform = new Platform(0, 230, 400, 20, _world);
			this.add(floor);

			// Player:
			_player = new Player(50, 200, 20, 20, _world);
			this.add(_player);

			FlxG.camera.antialiasing = true;
			
			_trash = new Vector.<Trash>();
			while (_trash.length != 15)
				spawnTrash(_trash, _world);
		}

		// Should be between 0 and 1
		public var spawnRate:Number = .98;
		
		public function spawnTrash(list:Vector.<Trash>, w:b2World):void
		{
			if (Math.random() > spawnRate)
			{
				var newTrash:Trash = new Trash((Math.random() * (FlxG.width + 1)), w);
				list.push(newTrash);
				this.add(newTrash);
			}
		}
		
		override public function update():void
		{
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
				} else
				_trash[i]._obj.SetLinearVelocity(new b2Vec2(-_player._obj.GetLinearVelocity().x, _trash[i]._obj.GetLinearVelocity().y));
			}
		
			if (_player._obj.GetPosition().x > 2) {
				_player._obj.SetPosition(new b2Vec2(2,_player._obj.GetPosition().y));
			} else if (_player._obj.GetPosition().x < 0) {
				_player._obj.SetPosition(new b2Vec2(0,_player._obj.GetPosition().y));
			}
			
			if (_player._obj.GetAngularVelocity() <= .06 && _player.isGrounded())
			{
				_player._obj.ApplyTorque(.06 * count);
			}else
				_player._obj.SetAngularVelocity(3);
			_world.Step(FlxG.elapsed, 6, 3);
			super.update();
			spawnTrash(_trash, _world);
			while (_toRemove.length != 0)
			{
				_world.DestroyBody(_toRemove.pop());
			}	
			while (_toAddToPlayer.length != 0)
			{
				var huh:ShapeSprite = new ShapeSprite();
				var j:b2FixtureDef = _toAddToPlayer.pop();
				huh._fixture = _player._obj.CreateFixture(j);
				_player._weight += 1;
				trace(huh._fixture.GetAABB().GetCenter().x + " " + huh._fixture.GetAABB().GetCenter().x);
				add(huh);
			}
			var stuff:b2Fixture = _player._obj.GetFixtureList();
			var welp:int = 0;
			while (stuff != null)
			{
				welp++;
				stuff = stuff.GetNext();
			}
		}

		private function setupWorld():void
		{
			//gravity
			var gravity:b2Vec2 = new b2Vec2(0, 9.8);

			//Ignore sleeping objects
			var ignoreSleeping:Boolean = true;

			_world = new b2World(gravity, ignoreSleeping);
			_world.SetContinuousPhysics(false);
			// Setup collision callbacks
			var contactListener:ContactListener = new ContactListener(this);
            _world.SetContactListener(contactListener);
		}
	}
}