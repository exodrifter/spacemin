package entities 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	import entities.B2FlxSprite;
	import Box2D.Dynamics.b2FilterData;
	
	public class Potato extends B2FlxSprite
	{
		[Embed(source = '../res/potato.png')] private var PotatoImage:Class;
		
		private var _gamestate:GameState;
		
		public function Potato(X:Number, Y:Number, G:GameState, W:b2World) 
		{
			super(X, Y, 20, 10, W);
			this.createBody();
			var filter:b2FilterData = new b2FilterData();
			filter.categoryBits = 0x0000;
			filter.maskBits = ~0x0000;
			this._obj.GetFixtureList().SetFilterData(filter.Copy());
			loadGraphic(PotatoImage);
			_gamestate = G;
			this.x = X;
			this.y = Y;
			this._obj.SetType(b2Body.b2_kinematicBody);
			this._obj.SetLinearVelocity(new b2Vec2(0, 3));
			this._obj.SetAngularVelocity((Math.random() - 0.5));
		}
		
		override public function update():void {
			super.update();
			if (y > Main.SCREEN_Y + 5) {
				_gamestate.potatoes.remove(this);
			}
		}
	}
}