package
{
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
		private var _world:b2World;

		// Ratio of pixels to meters
		public static const RATIO:Number = 30;
		
		// The player object
		public var _player:Player;
		// The trash in the game
		public var _trash:Vector.<Trash>;
		
		// The player's old x position
		public var _oldPlayerX:Number;

		override public function create():void
		{
			// Set up the world
			setupWorld();

			// Floor:
			var floor:Platform = new Platform(0, 230, 250, 20, _world);
			this.add(floor);

			// Player:
			_player = new Player(50, 200, 20, 20, _world);
			this.add(_player);

			FlxG.camera.antialiasing = true;
			_oldPlayerX = _player.x;
			
			_trash = new Vector.<Trash>();
			while (_trash.length != 1)
				spawnTrash(_trash, _world);
		}

		// Should be between 0 and 1
		public var spawnRate:Number = .99;
		
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
			for each (var t:Trash in _trash)
			{
				t._obj.SetLinearVelocity(new b2Vec2(-_player._obj.GetLinearVelocity().x, t._obj.GetLinearVelocity().y));
			}
			if (_player._obj.GetPosition().x > 2) {
				_player._obj.SetPosition(new b2Vec2(2,_player._obj.GetPosition().y));
			} else if (_player._obj.GetPosition().x < 0) {
				_player._obj.SetPosition(new b2Vec2(0,_player._obj.GetPosition().y));
			}
			
			_oldPlayerX = _player.x;
			_player._obj.SetAngularVelocity(3);
			_world.Step(FlxG.elapsed, 10, 10);
			super.update();
		}

		private function setupWorld():void
		{
			//gravity
			var gravity:b2Vec2 = new b2Vec2(0, 9.8);

			//Ignore sleeping objects
			var ignoreSleeping:Boolean = true;

			_world = new b2World(gravity, ignoreSleeping);
			
			// Setup collision callbacks
			var contactListener:ContactListener = new ContactListener(this);
            _world.SetContactListener(contactListener);
		}
	}
}