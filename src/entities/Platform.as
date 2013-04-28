package entities 
{
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2World;
	
	public class Platform extends B2FlxTileblock
	{
		[Embed(source = '../res/box.png')] private var ImgCube:Class;
		public static var platformFilter:b2FilterData = null;
		
		public function Platform(X:Number, Y:Number, Width:Number, Height:Number, W:b2World) 
		{
			super(X, Y, Width, Height, W);
			this.createBody();
			if (platformFilter == null)
			{
				platformFilter = new b2FilterData();
				platformFilter.categoryBits = 0x0001;
				platformFilter.maskBits = ~0x0001;
			}
			this._obj.GetFixtureList().SetFilterData(platformFilter.Copy());
			this.loadTiles(ImgCube);
			this._obj.SetUserData("ground");
		}
	}
}