package com.yoctobits.spacemin.entities 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2World;
	import com.yoctobits.spacemin.GameState;
	
	public class Scenery extends B2FlxSprite
	{
		[Embed(source = "../res/house.png")] private static const HouseImg:Class;
		[Embed(source = "../res/house2.png")] private static const House2Img:Class;
		[Embed(source = "../res/car.png")] private static const CarImg:Class;
		[Embed(source = "../res/tree.png")] private static const TreeImg:Class;
		[Embed(source = "../res/garbagecan.png")] private static const GarbageCanImg:Class;
		[Embed(source = "../res/streetlight.png")] private static const StreetLightImg:Class;
		[Embed(source = "../res/bike.png")] private static const BikeImg:Class;
		[Embed(source = "../res/truck.png")] private static const TruckImg:Class;
		[Embed(source = "../res/genie.png")] private static const GenieImg:Class;
		
		public var _filter:b2FilterData;
		
		public function Scenery(W:b2World, G:GameState, X:Number, Y:Number) 
		{
			super(W, G, X, Y, 40, 40, EntityEnum.SCENERY);
			loadGraphic(getNextImg());
			
			// Physics properties
			_width = width * .75;
			_height = height;
			_filter = new b2FilterData();
			_filter.maskBits = 0x0011;
			_filter.categoryBits = 0x0010;
			
			// Physics initialization
			createBody();
			_obj.GetFixtureList().SetFilterData(_filter);
			_obj.SetLinearVelocity(new b2Vec2(-_gamestate._player._obj.GetLinearVelocity().x, _obj.GetLinearVelocity().y));
		}
		
		override public function update():void 
		{
			super.update();
			if (this.getScreenXY().x + 100 < 0) {
				_gamestate.sceneryGroup.remove(this);
				_gamestate._toRemove.push(this._obj);
			}
		}
		
		private function getNextImg():Class {
			var n:int = (int)(Math.random() * 9);
			switch(n) {
			case 0:
				return HouseImg;
			case 1:
				return House2Img;
			case 2:
				return CarImg;
			case 3:
				return TreeImg;
			case 4:
				return GarbageCanImg;
			case 5:
				return StreetLightImg;
			case 6:
				return BikeImg;
			case 7:
				return TruckImg;
			case 8:
				return GenieImg;
			}
			return null; // Should be unreachable
		}
	}
}