package
{
	import org.flixel.*;
	
	/**
	 * The main menu for SpaceMin
	 */
	public class MenuState extends FlxState
	{
		private var _title:FlxText = new FlxText(Main.SCREEN_X2-50, 20, 100, Main.GAME_NAME);
		private var _start:FlxButton = new FlxButton(Main.SCREEN_X2 - 40, 100, "Start", toGame);
		private var _scores:FlxButton = new FlxButton(Main.SCREEN_X2 - 40, 120, "Highscores", toScores);
		private var _settings:FlxButton = new FlxButton(Main.SCREEN_X2 - 40, 140, "Settings", toSettings);
		
		[Embed(source="res/select.mp3")] private static var _select:Class;
		[Embed(source="res/activate.mp3")] private static var _activate:Class;
		
		override public function create():void
		{
			FlxG.mouse.show();
			FlxG.bgColor = 0xFFFFBEBA;
			
			_title.setFormat(null, 16, 0xffffff, "center", 0);
			add(_title);
			add(setSounds(_start));
			add(setSounds(_scores));
			add(setSounds(_settings));
		}
		
		public static function setSounds(button:FlxButton):FlxButton
		{
			button.setSounds(_select, 1.0, null, 1.0, _activate, 1.0, null, 1.0);
			return button;
		}
		
		public static function toMenu():void {
			FlxG.switchState(new MenuState());
		}
		
		public static function toGame():void {
			FlxG.switchState(new GameState());
		}
		
		public static function toScores():void {
			// FlxG.switchState(new ScoreState());
		}
		
		public static function toSettings():void {
			// FlxG.switchState(new SettingState());
		}
	}
}