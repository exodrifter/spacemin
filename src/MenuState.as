package
{
	import org.flixel.*;
	
	/**
	 * The main menu for SpaceMin
	 */
	public class MenuState extends FlxState
	{
		private var text:FlxText = new FlxText(0, 0, 100, "Hello, World!");
		
		override public function create():void
		{
			add(text);
		}
	}
}