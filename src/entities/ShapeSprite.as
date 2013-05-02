package entities
{
	import org.flixel.*;

	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;

	public class ShapeSprite extends FlxSprite
	{
		[Embed(source = '../res/TestTrash.png')] private static const TrashImage:Class;
		private var ratio:Number = 30;

		public var _fixDef:b2FixtureDef;
		public var _fixture:b2Fixture;


		public function ShapeSprite():void
		{
			super(0, 0);
			loadGraphic(TrashImage);
		}

		override public function update():void
		{
			x = (_fixture.GetAABB().GetCenter().x  * ratio) - width / 2 ;
			y = (_fixture.GetAABB().GetCenter().y * ratio) - height/2;
	//		x = (_obj.GetPosition().x * ratio) - width/2 ;
	//		y = (_obj.GetPosition().y * ratio) - height/2;
	//		angle = _obj.GetAngle() * (180 / Math.PI);
			super.update();
		}
	}
}