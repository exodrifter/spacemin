package entities
{
	import org.flixel.*;

	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;

	public class Trash extends B2FlxSprite
	{
		[Embed(source = '../res/TestTrash.png')] private var TrashImage:Class;

		private static var _filter:b2FilterData = new b2FilterData();
		private static var _trashFixDef:b2FixtureDef = new b2FixtureDef();
		public static var _minSize:Number = 5;
		public var _player:Player;
		
		{
			_filter.categoryBits = 0x0004;
			_filter.maskBits = ~0x0004;
			_trashFixDef.density = super._density;
			_trashFixDef.friction = super._friction;
			_trashFixDef.restitution = super._restitution;
		}
		
		public function Trash(X:Number, Y:Number):void
		{
			super(X, Y, 5, 5, Main.gamestate._world);
			super.scale = new FlxPoint(_width*1.2, _height*1.2);
			this._player = player;
			super._friction = 0;
			super._restitution = 0.0;
			super._density = 0.3;
			
			createBody();
			this._obj.GetFixtureList().SetFilterData(trashFilter.Copy());
			loadGraphic(TrashImage);
			this._obj.SetUserData("trash");
		}

		override public function update():void
		{
			super.update();
			this._obj.SetLinearVelocity(new b2Vec2(-_player._obj.GetLinearVelocity().x, this._obj.GetLinearVelocity().y));
		}

/*		override public function createBody():void
		{			
			var boxShape:b2PolygonShape = new b2PolygonShape();
			boxShape.SetAsBox((_width/2) / ratio, (_height/2) /ratio);

			_fixDef = new b2FixtureDef();
			_fixDef.density = _density;
			_fixDef.restitution = _restitution;
			_fixDef.friction = _friction;
			_fixDef.shape = boxShape;
			_fixDef.filter.categoryBits = 0x0001;

			_bodyDef = new b2BodyDef();
			_bodyDef.position.Set((x + (_width/2)) / ratio, (y + (_height/2)) / ratio);
			_bodyDef.angle = _angle * (Math.PI / 180);
			_bodyDef.type = _type;

			_obj = _world.CreateBody(_bodyDef);
			_obj.CreateFixture(_fixDef);
		}*/
	}
}