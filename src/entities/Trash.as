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

		public static var trashFilter:b2FilterData = null;
		public static var _trashFixDef:b2FixtureDef = null;
		public static var _width:Number = 4;
		public static var _height:Number = 4;
		public var _player:Player;
		
		public function Trash(X:Number, w:b2World, player:Player):void
		{
			super(X, 170, _width, _height, w);
			this._player = player;
			super._friction = 0;
			super._restitution = 0.0;
			super._density = 0.3;
			if (_trashFixDef == null)
			{
				_trashFixDef = new b2FixtureDef();
				_trashFixDef.density = super._density;
				_trashFixDef.friction = super._friction;
				_trashFixDef.restitution = super._restitution;
			}
			
			createBody();
			if (trashFilter == null)
			{
				trashFilter = new b2FilterData();
				trashFilter.categoryBits = 0x0004;
				trashFilter.maskBits = ~0x0004;
			}
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