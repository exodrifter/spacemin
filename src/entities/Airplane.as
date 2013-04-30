package entities 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	import entities.B2FlxSprite;
	import Box2D.Dynamics.b2FilterData;
	
	public class Airplane extends B2FlxSprite
	{
		[Embed(source = '../res/plane.png')] private var AirplaneImage:Class;
		
		private var _gamestate:GameState;
		
		public function Airplane(X:Number, Y:Number, G:GameState, W:b2World) 
		{
			super(X, Y, 20, 10, W);
			this.createBody();
			var filter:b2FilterData = new b2FilterData();
			filter.categoryBits = 0x0000;
			filter.maskBits = ~0x0000;
			this._obj.GetFixtureList().SetFilterData(filter.Copy());
			loadGraphic(AirplaneImage);
			_gamestate = G;
			this.x = X;
			this.y = Y;
			this._obj.SetType(b2Body.b2_kinematicBody);
			this._obj.SetLinearVelocity( new b2Vec2(-1, 0));
		}
		
		public function fall():void {
			this._obj.SetType(b2Body.b2_dynamicBody);
		}
	}
}