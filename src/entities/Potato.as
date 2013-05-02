package entities 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	import entities.B2FlxSprite;
	import Box2D.Dynamics.b2FilterData;
	
	public class Potato extends B2FlxSprite
	{
		[Embed(source = '../res/potato.png')] public const Img:Class;

		public var _filter:b2FilterData;

		public function Potato(X:Number, Y:Number) 
		{
			super(X, Y, 20, 10, Main.gamestate._world);
			loadGraphic(Img);
			
			// Physics properties
			_filter = new b2FilterData()
			_filter.categoryBits = 0x0000;
			_filter.maskBits = ~0x0000;
			
			// Physics initialization
			this.createBody();
			this._obj.GetFixtureList().SetFilterData(_filter);
			this._obj.SetType(b2Body.b2_kinematicBody);
			this._obj.SetLinearVelocity(new b2Vec2(0, 3));
			this._obj.SetAngularVelocity((Math.random() - 0.5));
		}
		
		override public function update():void {
			super.update();
			if (y > Main.SCREEN_Y + 5) {
				Main.gamestate.potatoes.remove(this);
			}
		}
	}
}