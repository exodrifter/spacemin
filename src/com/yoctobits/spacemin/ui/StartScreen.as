package com.yoctobits.spacemin.ui
{
	import com.yoctobits.spacemin.GameState;
	import com.yoctobits.spacemin.Main;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxText;
	
	public class StartScreen extends FlxGroup
	{
		private var _gamestate:GameState;
		private var _titleText:FlxText = new FlxText(Main.SCREEN_X2 - 200, 20, 400, Main.GAME_NAME);
		private var _startText:FlxText = new FlxText(Main.SCREEN_X2 - 200 , 200, 400, "PRESS ANY BUTTON TO START");
		
		public function StartScreen(G:GameState) 
		{
			_gamestate = G;
			
			_titleText.setFormat(null, 24, 0xffffff, "center", 0);
			_startText.setFormat(null, 16, 0xffffff, "center", 0);
			
			add(_titleText);
			add(_startText);
		}
		
		override public function update():void
		{
			if ((FlxG.keys.any() || FlxG.mouse.justPressed()) && !FlxG.keys.M) {
				_gamestate.startGame();
			}
		}
	}
}