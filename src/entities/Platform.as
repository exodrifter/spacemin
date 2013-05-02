package entities 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2World;
	
	public class Platform extends B2FlxSprite
	{
		[Embed(source = '../res/platform.png')] public const Img:Class;
		
		public var _filter:b2FilterData;

		public function Platform(X:Number, Y:Number) 
		{
			super(X, Y, 250, 200, Main.gamestate._world);
			loadGraphic(Img);
			
			// Physics Properties
			_filter = new b2FilterData();
			_filter.categoryBits = 0x0001;
			_filter.maskBits = ~0x0001;
			
			// Physics initialization
			this.createBody();
			this._obj.GetFixtureList().SetFilterData(_filter);
			this._obj.SetUserData("ground");
			this._obj.SetType(b2Body.b2_kinematicBody);
		}
		
		override public function update():void {
			super.update();
			if(Main.gamestate.gameover) {
				this._obj.SetLinearVelocity(new b2Vec2(0, this._obj.GetLinearVelocity().y));
			} else {
				this._obj.SetLinearVelocity(new b2Vec2(-Main.gamestate._player._obj.GetLinearVelocity().x, this._obj.GetLinearVelocity().y));
			}
			if (this.getScreenXY().x + 250 < 0) {
				Main.gamestate._platform_group.remove(this);
				Main.gamestate._toRemove.push(this._obj);
			}
		}
	}
}