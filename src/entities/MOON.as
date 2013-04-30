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
	
	public class MOON extends B2FlxSprite
	{
		[Embed(source = '../res/Moon.png')] private var moonImage:Class;
		[Embed(source="../res/moonCrash.mp3")] private static var _mooncrash:Class;
		public var MOONFall:Boolean = false;
		public var game:GameState;
		public var moonEmitter:FlxEmitter;
		public var moonParticles:int = 40;
		public var emitted:Boolean = false;
		
		
		public function MOON(X:Number, Y:Number, W:b2World, gamestate:GameState, emitter:FlxEmitter) 
		{
			super(X, Y, 250, 200, W);
			
			game = gamestate;
			loadGraphic(moonImage);
			_width = width;
			_height = height;
			moonEmitter = emitter;
			
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
				_obj.ApplyForce(new b2Vec2(-.05, -.08), _obj.GetPosition());
			//	if (_obj.GetLinearVelocity().y >= 6)
			//		_obj.SetLinearVelocity(new b2Vec2(-.6, 6));
			} else
			{
				_obj.SetLinearVelocity(new b2Vec2( -0.07, 0 ));
			}
			if (game._endgame == true)
				_obj.SetLinearVelocity(new b2Vec2());
			if (!emitted && y > 170)
			{
				FlxG.play(_mooncrash, 1);
				moonEmitter.at(this);
				for (var i:int = 0; i < moonParticles; i++)
				{
					moonEmitter.emitParticle();
				}
				emitted = true;
				game._toRemove.push(_obj);
				visible = false;
			}
			
		}
	}
}