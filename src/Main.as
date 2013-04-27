/** package 
{
	import org.flixel.*;
	
	[SWF(width = "600", height = "400", backgroundColor = "#000000")]
	
	/**
	 * The main entry point for SpaceMin
	 /
	public class Main extends FlxGame
	{
		public const SCREEN_X:int = 300, SCREEN_Y:int = 200;
		public const ZOOM:int = 2;
		public const LOGIC_FRAMERATE:int = 60, RENDER_FRAMERATE:int = 60;
		public const USE_SYSTEM_CURSOR:Boolean = true;
		
		public function Main():void
		{
			super(SCREEN_X, SCREEN_Y, GameState, ZOOM, LOGIC_FRAMERATE,
					RENDER_FRAMERATE, USE_SYSTEM_CURSOR);
			forceDebugger = true;
		}
	}
}
*/


package
{
	import org.flixel.*;
	[SWF(width="800", height="500", backgroundColor="#000000")]
//	[Frame(factoryClass="Preloader")]

	public class Main extends FlxGame
	{
		public function Main()
		{
			super(400,250,GameState,2);
			forceDebugger = true;
		}
	}
}