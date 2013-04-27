
package
{
	import org.flixel.*;

	import flash.display.Sprite;
	import flash.events.Event;

	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;


	public class GameState extends FlxState
	{
		[Embed(source = 'res/box.png')] private var ImgCube:Class;
		[Embed(source = 'res/ball.png')] private var ImgBall:Class;
		[Embed(source = 'res/rect.png')] private var ImgRect:Class;

		private var _world:b2World;

		//ration of pixels to meters
		public static const RATIO:Number = 30;
		public var cube:Player;
		
		public var oldPlayerX:Number;
		public var oldElapsed:Number;
		public var trash:FlxGroup;

		override public function create():void
		{
			//Set up the world
			setupWorld();

			//Floor:
			var floor:B2FlxTileblock = new B2FlxTileblock(0, 230, 400, 20, _world)
			floor.createBody();
			floor.loadTiles(ImgCube);
			floor._obj.SetUserData("ground");
			
			//cube:
			cube = new Player(50, 200, 20, 20, _world);
			cube._obj.SetUserData("player");
			
			this.add(cube);
			this.add(floor);

			//debugDraw();
			
			FlxG.camera.antialiasing = true;
			oldPlayerX = cube.x;
		}

		override public function update():void
		{
			if (cube.x > 75)
			{
				cube._obj.SetLinearVelocity(new b2Vec2(75 - cube.x, cube._obj.GetLinearVelocity().y));
			} else {
				cube._obj.SetLinearVelocity(new b2Vec2(oldPlayerX - cube.x, cube._obj.GetLinearVelocity().y));
			}
			oldPlayerX = cube.x;
			cube._obj.SetAngularVelocity(3);
			_world.Step(FlxG.elapsed, 10, 10);
			super.update();
		}

		/*private function debugDraw():void
		{
			var spriteToDrawOn:Sprite = new Sprite();
			addChild(spriteToDrawOn);
			
			var artistForHire:b2DebugDraw = new b2DebugDraw();
			artistForHire.SetSprite(spriteToDrawOn);
			artistForHire.SetXFormScale(30);
			artistForHire.SetFlags(b2DebugDraw.e_shapeBit);
			artistForHire.SetLineThickness(2.0);
			artistForHire.SetFillAlpha(0.6);
			
			_world.SetDebugDraw(artistForHire);
		}*/


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
