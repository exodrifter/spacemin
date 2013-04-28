package  
{
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.Contacts.*;
	
	/**
	 * Contains a few callbacks that are used to check for certain collisions
	 */
	public class ContactListener extends b2ContactListener
	{
		private var _gamestate:GameState;
		
		private var _ground:Boolean, _player:Boolean;
		
		public function ContactListener(gamestate:GameState) 
		{
			_gamestate = gamestate
		}
		
		/**
		 * Called when two fixtures begin to touch.
		 */
		override public function BeginContact(contact:b2Contact):void
		{
			DetectContact(contact);
			
			if (_player && _ground) {
				_gamestate._player.ground(true);
			}
		}

		/**
		 * Called when two fixtures cease to touch.
		 */
		override public function EndContact(contact:b2Contact):void
		{
			DetectContact(contact);
			
			if (_player && _ground) {
				_gamestate._player.ground(false);
			}
		}
		
		private function DetectContact(contact:b2Contact):void
		{
			_ground = false;
			_player = false;
			if (contact.GetFixtureA().GetBody().GetUserData() == "ground"
					|| contact.GetFixtureB().GetBody().GetUserData() == "ground") {
				_ground = true;
			}
			if (contact.GetFixtureA().GetBody().GetUserData() == "player"
					|| contact.GetFixtureB().GetBody().GetUserData() == "player") {
				_player = true;
			}
		}
	}
}