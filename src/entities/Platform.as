package entities 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2World;
	
	public class Platform extends B2FlxSprite
	{
		[Embed(source = '../res/platform.png')] private var ImgCube:Class;
		public static var platformFilter:b2FilterData = null;
		private var _player:Player;
		private var _gamestate:GameState;
		
		public function Platform(X:Number, Y:Number, W:b2World, player:Player, gamestate:GameState) 
		{
			super(X, Y, 250, 200, W);
			this._player = player;
			this.createBody();
			_gamestate = gamestate;
			if (platformFilter == null)
			{
				platformFilter = new b2FilterData();
				platformFilter.categoryBits = 0x0001;
				platformFilter.maskBits = ~0x0001;
			}
			this._obj.GetFixtureList().SetFilterData(platformFilter.Copy());
			loadGraphic(ImgCube);
			this._obj.SetUserData("ground");
			this._obj.SetType(b2Body.b2_kinematicBody);
		}
		
		override public function update():void {
			super.update();
			if(_gamestate._endgame) {
				this._obj.SetLinearVelocity(new b2Vec2(0, this._obj.GetLinearVelocity().y));
			} else {
				this._obj.SetLinearVelocity(new b2Vec2(-_player._obj.GetLinearVelocity().x, this._obj.GetLinearVelocity().y));
			}
			if (this.getScreenXY().x + 250 < 0) {
				_gamestate.remove(this);
				_gamestate._toRemove.push(this._obj);
			}
		}
	}
}