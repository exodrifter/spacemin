package entities 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2World;
	import flash.geom.Rectangle;
	import org.flixel.FlxRect;
	
	public class Platform extends B2FlxSprite
	{
		/** The shape of the platform */
		public var shape:FlxRect;
		
		public var _filter:b2FilterData;
		
		public function Platform(W:b2World, G:GameState, X:Number, Y:Number) 
		{
			super(W, G, X, Y, 250, 200);
			this.makeGraphic(250, 200, 0xffff6060);
			this._pixels.fillRect(new Rectangle(30, 0, 190, 200), 0xffc60d00);
			this.resetHelpers();
			
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
			if(_gamestate.gameover) {
				this._obj.SetLinearVelocity(new b2Vec2(0, this._obj.GetLinearVelocity().y));
			} else {
				this._obj.SetLinearVelocity(new b2Vec2(-_gamestate._player._obj.GetLinearVelocity().x, this._obj.GetLinearVelocity().y));
			}
			if (this.getScreenXY().x + 250 < 0) {
				_gamestate._platform_group.remove(this);
				_gamestate._toRemove.push(this._obj);
			}
		}
	}
}