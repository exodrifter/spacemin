package
{
	import org.flixel.system.FlxPreloader;
	
	public class Preloader extends FlxPreloader
	{
		public function Preloader():void
		{
			className = GAME_NAME;
			super();
		}
	}
}