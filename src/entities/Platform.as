package entities 
{
	import Box2D.Dynamics.b2World;
	
	public class Platform extends B2FlxTileblock
	{
		[Embed(source = '../res/box.png')] private var ImgCube:Class;
		
		public function Platform(X:Number, Y:Number, Width:Number, Height:Number, W:b2World) 
		{
			super(X, Y, Width, Height, W);
			this.createBody();
			this.loadTiles(ImgCube);
			this._obj.SetUserData("ground");
		}
	}
}