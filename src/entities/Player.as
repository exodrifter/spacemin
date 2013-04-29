package entities
{
	import org.flixel.*;
	
	import Box2D.Dynamics.*;
	import Box2D.Common.Math.*;
	
	public class Player extends B2FlxSprite
	{
		[Embed(source = '../res/box.png')] private var ImgCube:Class;
		[Embed(source = '../res/boxb.png')] private var ImgLand:Class;
		[Embed(source="../res/jump.mp3")] private static var _jump_sound:Class;
		[Embed(source="../res/land.mp3")] private static var _land_sound:Class;
		
		public static var playerFilter:b2FilterData = null;
		
		public static const targetAngularVelocity:Number = 7;
		
		private var _pressed:Boolean = false, _grounded:Boolean = false, _canJump:Boolean = false, _landing:Boolean = false;
		/** The total weight of the trah connected to this player */
		public var _weight:Number = 0;
		
		private var _gamestate:GameState;
		
		public function Player(X:Number, Y:Number, Width:Number, Height:Number, W:b2World, G:GameState):void
		{
			super(X, Y, Width, Height, W);
			this._restitution = 0.5;
			this._friction = 10;
			this._density = 5;
			this.createBody();
			this._gamestate = G;
			if (playerFilter == null)
			{
				playerFilter = new b2FilterData();
				playerFilter.categoryBits = 0x0002;
				playerFilter.maskBits = ~0x0002;
			}
			this._obj.GetFixtureList().SetFilterData(playerFilter.Copy());
			this.loadGraphic(ImgCube);
			this._obj.SetUserData("player");
		}
		
		override public function update():void
		{
			super.update();
			if ((FlxG.keys.any() || FlxG.mouse.pressed()) && !FlxG.keys.ESCAPE) {
				if (!_pressed && !_gamestate._endgame && !_gamestate._paused) {
					if (_canJump) {
						FlxG.play(_jump_sound);
						this._obj.SetLinearVelocity(new b2Vec2(this._obj.GetLinearVelocity().x, -10 - 0.1 * (_weight+1)));
						_pressed = true;
						_canJump = false;
						loadGraphic(ImgLand);
					} else {
						FlxG.play(_land_sound);
						_landing = true;
						_pressed = true;
						this._obj.SetLinearVelocity(new b2Vec2(this._obj.GetLinearVelocity().x, 20 - 0.1 * (_weight+1)));
					}
				}
			} else {
				_pressed = false;
			}
			
			// Adjust angular velocity
			if (_obj.GetAngularVelocity() > targetAngularVelocity) {
				_obj.SetAngularVelocity(_obj.GetAngularVelocity() - 40 * FlxG.elapsed);
				if (_obj.GetAngularVelocity() < targetAngularVelocity) {
					_obj.SetAngularVelocity(targetAngularVelocity);
				}
			} else if (_obj.GetAngularVelocity() < targetAngularVelocity) {
				_obj.SetAngularVelocity(_obj.GetAngularVelocity() + 10* FlxG.elapsed);
				if (_obj.GetAngularVelocity() > targetAngularVelocity) {
					_obj.SetAngularVelocity(targetAngularVelocity);
				}
			}
			trace(_obj.GetAngularVelocity());
		}
		
		public function ground(grounded:Boolean):void
		{
			_grounded = grounded;
			_canJump = _canJump || _grounded;
			loadGraphic(ImgCube);
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