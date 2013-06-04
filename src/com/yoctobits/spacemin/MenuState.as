package com.yoctobits.spacemin 
{
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	/**
	 * The main menu for SpaceMin
	 */
	public class MenuState extends FlxState
	{
		private var _title:FlxText = new FlxText(Main.SCREEN_X2-200, 20, 400, Main.GAME_NAME);
		private var _authors:FlxText = new FlxText(Main.SCREEN_X2-200, Main.SCREEN_Y-40, 400, "Made by Chris Mika and Darwin Pek for the Ludum Dare 26 Jam");
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
			_authors.setFormat(null, 8, 0xffffff, "center", 0);
			add(_authors);
			add(setSounds(_start));
			//add(setSounds(_scores));
			//add(setSounds(_settings));
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