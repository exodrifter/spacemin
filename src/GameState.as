
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
		
		
		
		
		public var oldPlayerX:Number;
		public var oldElapsed:Number;
		public var trash:Vector.<Trash>;
		public var cube:B2FlxSprite;

		override public function create():void
		{
			//Set up the world
			setupWorld();

			//Floor:
			var floor:B2FlxTileblock = new B2FlxTileblock(0, 230, 800, 20, _world)
			floor.createBody();
			floor.loadTiles(ImgCube);
			
			//cube:
			cube = new B2FlxSprite(50, 200, 20, 20, _world);
			cube.createBody();
			cube.loadGraphic(ImgCube);
			
			this.add(cube);
			this.add(floor);

			//debugDraw();
			
			FlxG.camera.antialiasing = true;
			oldPlayerX = cube.x;
			
			trash = new Vector.<Trash>();
			while (trash.length != 1)
				spawnTrash(trash, _world);
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
		//	if (cube.x > 75)
		//	{
		for each (var t:Trash in trash)
				{
					t._obj.SetLinearVelocity(new b2Vec2(-cube._obj.GetLinearVelocity().x, t._obj.GetLinearVelocity().y));
					//trace(75 - cube.x);
				}
				//cube._obj.SetLinearVelocity(new b2Vec2(-cube._obj.GetLinearVelocity().x, cube._obj.GetLinearVelocity().y));
				
		//	} else {
		//		cube._obj.SetLinearVelocity(new b2Vec2(oldPlayerX - cube.x, cube._obj.GetLinearVelocity().y));
		//		for each (var e:Trash in trash)
		//		{
		//			e._obj.SetLinearVelocity(new b2Vec2(oldPlayerX - cube.x, e._obj.GetLinearVelocity().y));
					//trace(oldPlayerX - cube.x);
		//		}
		//	}
			trace(cube._obj.GetLinearVelocity().x);
			
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

		}		
	}
}