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
		[Embed(source = '../res/plane.png')] public const Img:Class;
		[Embed(source = '../res/planeCrash.mp3')] public const CrashSnd:Class;
		
		private var _filter:b2FilterData;
		
		private var _timer:Number;
		private var _time:Number;
		
		public var max:int = 18;
		public var min:int = 13;
		
		public var emitted:Boolean = false;
		
		public function Airplane(X:Number, Y:Number) 
		{
			super(X, Y, 20, 10, Main.gamestate._world);
			loadGraphic(Img);
			_timer = 2;
			_time = Math.random()*2;
			
			// Physics Properties
			_filter = new b2FilterData();
			_filter.categoryBits = 0x0000;
			_filter.maskBits = ~0x0000;
			
			// Physics initialization
			this.createBody();
			this._obj.GetFixtureList().SetFilterData(_filter);
			this._obj.SetType(b2Body.b2_kinematicBody);
			this._obj.SetLinearVelocity( new b2Vec2( -3.5, 0));
		}
		
		public function fall():void {
			this._obj.SetType(b2Body.b2_dynamicBody);
			this._obj.SetAngularVelocity(Math.random() - 1.25);
		}
		
		override public function update():void {
			super.update();
			if (_time > _timer) {
				_time = 0;
				Main.gamestate.spawnPotato(x,y);
			}
			_time += FlxG.elapsed;
			
			if(x+20 < 0)
				Main.gamestate.airplanes.remove(this);
			if (!emitted && y > 180)
			{
				FlxG.play(CrashSnd, 1);
				emitted = true;
				var count:int = Math.floor(Math.random() * (max - min) + min);
				Main.gamestate.planeEmitter.at(this);
				for ( var other:int = 0; other < count; other++)
				{
					Main.gamestate.planeEmitter.emitParticle();
				}
			}
		}
	}
}