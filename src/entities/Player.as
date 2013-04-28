package entities
{
	import org.flixel.*;
	
	import Box2D.Dynamics.*;
	import Box2D.Common.Math.*;
	
	public class Player extends B2FlxSprite
	{
		[Embed(source = '../res/box.png')] private var ImgCube:Class;
		
		public static var playerFilter:b2FilterData = null;
		
		private var _pressed:Boolean = false, _grounded:Boolean = false, _canJump:Boolean = false;
		/** The total weight of the trah connected to this player */
		public var _weight:Number = 0;
		
		public function Player(X:Number, Y:Number, Width:Number, Height:Number, W:b2World):void
		{
			super(X, Y, Width, Height, W);
			this._friction = 10;
			this._density = .7;
			this.createBody();
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
			if (FlxG.keys.any() && !FlxG.keys.ESCAPE) {
				if (!_pressed && _canJump) {
					this._obj.ApplyImpulse(new b2Vec2(0, -2 - 0.01 * (_weight+1)), this._obj.GetPosition());
					_pressed = true;
					_canJump = false;
				}
			} else {
				_pressed = false;
			}
		}
		
		public function ground(grounded:Boolean):void
		{
			_grounded = grounded;
			_canJump = _canJump || _grounded;
		}
		
		public function isGrounded():Boolean
		{
			return _grounded;
		}
		
		public function canJump():Boolean
		{
			return _canJump;
		}
	}
}