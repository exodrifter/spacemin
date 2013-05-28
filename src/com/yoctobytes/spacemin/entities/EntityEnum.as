package com.yoctobytes.spacemin.entities 
{
	/**
	 * Enums to identify entities
	 */
	public class EntityEnum 
	{
		public static const UNDEFINED:EntityEnum = new EntityEnum(0);
		// public static const AIRPLANE:EntityEnum = new EntityEnum(1);
		// public static const BEAM:EntityEnum = new EntityEnum(2);
		public static const MOON:EntityEnum = new EntityEnum(3);
		public static const PLATFORM:EntityEnum = new EntityEnum(4);
		public static const PLAYER:EntityEnum = new EntityEnum(5);
		public static const SCENERY:EntityEnum = new EntityEnum(6);
		
		private static var _enumsCreated:Boolean = false;
		
		{
			// Executed after all static members have been set
			_enumsCreated = true;
		}
		
		private var _id:uint;
		
		public function EntityEnum(ID:uint)
		{
			if (_enumsCreated) {
				throw new Error("The enums have already been created");
			}
			_id = ID;
		}
		
		public function get id():uint {
			return _id;
		}
	}
}