package entities 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2World;
	import flash.accessibility.Accessibility;
	import flash.text.engine.ElementFormat;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	
	public class Moon extends B2FlxSprite
	{
		[Embed(source = '../res/Moon.png')] public const Img:Class;
		[Embed(source = "../res/moonCrash.mp3")] public const CrashSnd:Class;
		
		public var _filter:b2FilterData;
		public var MOONFall:Boolean = false;
		public var moonEmitter:FlxEmitter;
		public var moonParticles:int = 40;
		public var emitted:Boolean = false;
		
		public function Moon(X:Number, Y:Number, emitter:FlxEmitter) 
		{
			super(X, Y, 250, 200, Main.gamestate._world);
			
			loadGraphic(Img);
			_width = width;
			_height = height;
			moonEmitter = emitter;
			
			// Physics properties
			_filter = new b2FilterData()
			_filter.categoryBits = 0x0000;
			_filter.maskBits = ~0x0000;
			
			// Physics initialization
			this.createBody();
			this._obj.GetFixtureList().SetFilterData(_filter);
			this._obj.SetUserData("MOON");
			this._obj.SetType(b2Body.b2_kinematicBody);
		}
		
		override public function update():void {
			super.update();
			if (MOONFall)
			{
				this._obj.SetType(b2Body.b2_dynamicBody);
				_obj.ApplyForce(new b2Vec2(-.05, -.08), _obj.GetPosition());
			}
			else
			{
				_obj.SetLinearVelocity(new b2Vec2( -0.07, 0 ));
			}
			if (Main.gamestate.gameover == true)
			{
				_obj.SetLinearVelocity(new b2Vec2());
			}
			if (!emitted && y > 170)
			{
				FlxG.play(CrashSnd, 1);
				moonEmitter.at(this);
				for (var i:int = 0; i < moonParticles; i++)
				{
					moonEmitter.emitParticle();
				}
				emitted = true;
				Main.gamestate._toRemove.push(_obj);
				visible = false;
			}
		}
	}
}