package com.yoctobytes.spacemin.entities
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import com.yoctobytes.spacemin.GameState;
	import org.flixel.FlxSprite;
	
	public class B2FlxSprite extends FlxSprite
	{
		public const ratio:Number = 30;
		
		private var _world:b2World;
		public var _gamestate:GameState;
		
		public var _fixDef:b2FixtureDef;
		public var _bodyDef:b2BodyDef
		public var _obj:b2Body;
		
		// Identifies the B2FlxSprite as an entity
		public var _enum:EntityEnum;
		
		public var _width:Number;
		public var _height:Number;
		
		//Physics params default value
		public var _friction:Number = 0.8;
		public var _restitution:Number = 0.3;
		public var _density:Number = 0.7;
		
		//Default angle
		public var _angle:Number = 0;
		//Default body type
		public var _type:uint = b2Body.b2_dynamicBody;
		
		public function B2FlxSprite(W:b2World, G:GameState, X:Number, Y:Number, Width:Number, Height:Number, Enum:EntityEnum = null):void
		{
			super(X,Y);
			_fixDef = new b2FixtureDef();
			_world = W;
			_gamestate = G;
			_width = Width;
			_height = Height;
			_enum = Enum == null ? EntityEnum.UNDEFINED : Enum;
		}
		
		override public function update():void
		{
			x = (_obj.GetPosition().x * ratio) - width/2 ;
			y = (_obj.GetPosition().y * ratio) - height/2;
			angle = _obj.GetAngle() * (180 / Math.PI);
			super.update();
		}
		
		public  function createBody():void
		{
			var boxShape:b2PolygonShape = new b2PolygonShape();
			boxShape.SetAsBox((_width/2) / ratio, (_height/2) /ratio);
			
			_fixDef.density = _density;
			_fixDef.restitution = _restitution;
			_fixDef.friction = _friction;
			_fixDef.shape = boxShape;
			
			_bodyDef = new b2BodyDef();
			_bodyDef.position.Set((x + (_width/2)) / ratio, (y + (_height/2)) / ratio);
			_bodyDef.angle = _angle * (Math.PI / 180);
			_bodyDef.type = _type;
			
			_obj = _world.CreateBody(_bodyDef);
			_obj.CreateFixture(_fixDef);
		}
	}
}