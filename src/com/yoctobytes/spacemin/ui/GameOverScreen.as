package com.yoctobytes.spacemin.ui
{
	import com.yoctobytes.spacemin.util.Timer;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxText;
	import com.yoctobytes.spacemin.GameState;
	import com.yoctobytes.spacemin.Main;
	
	public class GameOverScreen extends FlxGroup
	{
		[Embed(source = "../res/end-hits.mp3")] private static var GameOverSound:Class;
		
		private var _gamestate:GameState;
		private var _titleText:FlxText = new FlxText(Main.SCREEN_X2 - 50, 20, 100, "GAME OVER");
		private var _scoreText:FlxText = new FlxText(Main.SCREEN_X2 - 200, 120, 400, "FINAL SCORE: ");
		private var _startText:FlxText = new FlxText(Main.SCREEN_X2 - 200 , 200, 400, "PRESS ANY BUTTON TO RESTART");
		private var _score:uint;
		
		private var _done:Boolean = false;
		private var _titleTimer:Timer = new Timer(0.5);
		private var _scoreTimer:Timer = new Timer(1.0);
		private var _startTimer:Timer = new Timer(1.5);
		
		public function GameOverScreen(G:GameState)
		{
			_gamestate = G;
			
			_titleText.setFormat(null, 24, 0xffffff, "center", 0);
			_scoreText.setFormat(null, 24, 0xffffff, "center", 0);
			_startText.setFormat(null, 16, 0xffffff, "center", 0);
		}
		
		override public function update():void
		{
			if (FlxG.keys.any() || FlxG.mouse.justPressed()) {
				_gamestate.restartGame();
				return;
			}
			if (!_done && _titleTimer.update(FlxG.elapsed)) {
				add(_titleText);
				FlxG.play(GameOverSound);
			}
			if (!_done && _scoreTimer.update(FlxG.elapsed)) {
				add(_scoreText);
				FlxG.play(GameOverSound);
			}
			if (!_done && _startTimer.update(FlxG.elapsed)) {
				add(_startText);
				_done = true;
				FlxG.play(GameOverSound);
			}
		}
		
		public function set score(score:uint):void {
			_score = score;
			_scoreText.text = "FINAL SCORE: " + _score;
		}
		
		public function get score():uint {
			return score;
		}
	}
}