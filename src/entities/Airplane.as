package entities 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	import entities.B2FlxSprite;
	import Box2D.Dynamics.b2FilterData;
	import org.flixel.FlxG;
	
	public class Airplane extends B2FlxSprite
	{
		[Embed(source = '../res/plane.png')] private var AirplaneImage:Class;
		[Embed(source = '../res/planeCrash.mp3')] private var AirplaneCrash:Class;
		
		
		private var _gamestate:GameState;
		private var _timer:Number;
		private var _time:Number;
		
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
			this._obj.SetLinearVelocity( new b2Vec2( -3.5, 0));
			_timer = 2;
			_time = Math.random()*2;
		}
		public var max:int = 18;
		public var min:int = 13;
		public function fall():void {
			this._obj.SetType(b2Body.b2_dynamicBody);
			this._obj.SetAngularVelocity(Math.random() - 1.25);
			

		}
		public var emitted:Boolean = false;
		override public function update():void {
			super.update();
			if (_time > _timer) {
				_time = 0;
				_gamestate.spawnPotato(x,y);
			}
			_time += FlxG.elapsed;
			
			if(x+20 < 0)
				_gamestate.airplanes.remove(this);
			if (!emitted && y > 180)
			{
				FlxG.play(AirplaneCrash, 1);
				emitted = true;
				var count:int = Math.floor(Math.random() * (max - min) + min);
				_gamestate.planeEmitter.at(this);
				for ( var other:int = 0; other < count; other++)
				{
					_gamestate.planeEmitter.emitParticle();
				}
			}
		}
	}
}