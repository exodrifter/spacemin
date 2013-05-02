package entities
{
	import org.flixel.*;
	
	import Box2D.Dynamics.*;
	import Box2D.Common.Math.*;
	
	public class Player extends B2FlxSprite
	{
		[Embed(source = "../res/box.png")] public const JumpImg:Class;
		[Embed(source = "../res/boxb.png")] public const CubeImg:Class;
		[Embed(source = "../res/jump.mp3")] public const JumpSnd:Class;
		[Embed(source = "../res/land.mp3")] public const LandSnd:Class;
		
		public const TARGET_ANGULAR_VELOCITY:Number = 7;
		
		public var _filter:b2FilterData;
		
		private var _pressed:Boolean = false, _grounded:Boolean = false, _canJump:Boolean = false, _landing:Boolean = false;
		
		public function Player(X:Number, Y:Number, Width:Number, Height:Number):void
		{
			super(X, Y, Width, Height, Main.gamestate._world);
			this.loadGraphic(JumpImg);
			
			// Physics properties
			_filter = new b2FilterData();
			_filter.categoryBits = 0x0002;
			_filter.maskBits = ~0x0002;
			this._restitution = 0.5;
			this._friction = 10;
			this._density = 5;
			
			// Physics initialization
			this.createBody();
			this._obj.GetFixtureList().SetFilterData(_filter);
			this._obj.SetUserData("player");
		}
		
		override public function update():void
		{
			super.update();
			if ((FlxG.keys.any() || FlxG.mouse.pressed()) && !FlxG.keys.ESCAPE) {
				if (!_pressed && !Main.gamestate.gameover && !Main.gamestate.paused) {
					if (_canJump) {
						FlxG.play(JumpSnd);
						this._obj.SetLinearVelocity(new b2Vec2(this._obj.GetLinearVelocity().x, -10));
						_pressed = true;
						_canJump = false;
						loadGraphic(CubeImg);
					} else {
						FlxG.play(LandSnd);
						_landing = true;
						_pressed = true;
						this._obj.SetLinearVelocity(new b2Vec2(this._obj.GetLinearVelocity().x, 20));
					}
				}
			} else {
				_pressed = false;
			}
			// Adjust angular velocity
			if (_obj.GetAngularVelocity() > TARGET_ANGULAR_VELOCITY) {
				_obj.SetAngularVelocity(_obj.GetAngularVelocity() - 100 * FlxG.elapsed);
				if (_obj.GetAngularVelocity() < TARGET_ANGULAR_VELOCITY) {
					_obj.SetAngularVelocity(TARGET_ANGULAR_VELOCITY);
				}
			} else if (_obj.GetAngularVelocity() < TARGET_ANGULAR_VELOCITY) {
				_obj.SetAngularVelocity(_obj.GetAngularVelocity() + 10* FlxG.elapsed);
				if (_obj.GetAngularVelocity() > TARGET_ANGULAR_VELOCITY) {
					_obj.SetAngularVelocity(TARGET_ANGULAR_VELOCITY);
				}
			}
		}
		
		public function ground(grounded:Boolean):void
		{
			_grounded = grounded;
			_canJump = _canJump || _grounded;
			loadGraphic(CubeImg);
			_landing = false;
		}
		
		public function isGrounded():Boolean
		{
			return _grounded;
		}
		
		public function isLanding():Boolean
		{
			return _landing;
		}
		
		public function canJump():Boolean
		{
			return _canJump;
		}
	}
}