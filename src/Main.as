package 
{
	import org.flixel.*;
	
	[SWF(width = "800", height = "500", backgroundColor = "#FFBEBA")]
	
	/**
	 * The main entry point for SpaceMin
	 */
	public class Main extends FlxGame
	{
		public static const GAME_NAME:String = "SpaceMin";
		public static const SCREEN_X:int = 400, SCREEN_Y:int = 250;
		public static const SCREEN_X2:int = SCREEN_X / 2, SCREEN_Y2:int = SCREEN_Y / 2;
		public static const ZOOM:int = 2;
		public static const LOGIC_FRAMERATE:int = 60, RENDER_FRAMERATE:int = 60;
		public static const USE_SYSTEM_CURSOR:Boolean = false;
		
		public function Main():void
		{
			super(SCREEN_X, SCREEN_Y, MenuState, ZOOM, LOGIC_FRAMERATE,
					RENDER_FRAMERATE, USE_SYSTEM_CURSOR);
			forceDebugger = true;
		}
	}
}