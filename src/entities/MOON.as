package entities 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2World;
	
	public class MOON extends B2FlxSprite
	{
		[Embed(source = '../res/Moon.png')] private var moonImage:Class;
		public var MOONFall:Boolean = false;
		public var game:GameState;
		public function MOON(X:Number, Y:Number, W:b2World, gamestate:GameState) 
		{
			super(X, Y, 250, 200, W);
			game = gamestate;
			loadGraphic(moonImage);
			_width = width;
			_height = height;
			this.createBody();
			var moonFilter:b2FilterData = new b2FilterData();
			moonFilter.categoryBits = 0x0000;
			moonFilter.maskBits = ~0x0000;
			this._obj.GetFixtureList().SetFilterData(moonFilter.Copy());
			this._obj.SetUserData("MOON");
			this._obj.SetType(b2Body.b2_kinematicBody);
		}
		
		override public function update():void {
			super.update();
			//this._obj.SetLinearVelocity(new b2Vec2(-_player._obj.GetLinearVelocity().x, this._obj.GetLinearVelocity().y));
			if (MOONFall)
			{
				this._obj.SetType(b2Body.b2_dynamicBody);
				_obj.ApplyForce(new b2Vec2(-.01, -.2), _obj.GetPosition());
			//	if (_obj.GetLinearVelocity().y >= 6)
			//		_obj.SetLinearVelocity(new b2Vec2(-.6, 6));
			}
			if (y > 180)
			{
				
				game._toRemove.push(_obj);
				visible = false;
			}
			
		}
	}
}