package entities
{
	import org.flixel.*;
	
	import Box2D.Dynamics.*;
	import Box2D.Common.Math.*;
	
	public class Player extends B2FlxSprite
	{
		[Embed(source = '../res/box.png')] private var ImgCube:Class;
		
		private var _pressed:Boolean = false, _grounded:Boolean = false;
		
		public static var playerFilter:b2FilterData = null;
		
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
			if (FlxG.keys.any()) {
				if(!_pressed && _grounded) {
					this._obj.ApplyImpulse(new b2Vec2(0, -2), this._obj.GetPosition());
					_pressed = true;
				}
			} else {
				_pressed = false;
			}
		}
		
		public function ground(grounded:Boolean):void
		{
			_grounded = grounded;
		}
		
		public function isGrounded():Boolean
		{
			return _grounded;
		}
	}
}