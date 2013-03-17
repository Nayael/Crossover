package com.nayael.crossover.states 
{
	import com.entity.engine.E;
	import com.entity.engine.fsm.IState;
	import com.entity.engine.SoundManager;
	import com.nayael.crossover.Main;
	import com.nayael.crossover.utils.Text;
	import flash.display.Sprite;
	
	public class StateMainMenu implements IState
	{
		private var _title:Text;
		private var _game:Main;
		
		public function StateMainMenu(game:Main) {
			_game = game;
			_title = new Text('Megaboy Against the World', 'PressStart2P', 28, 0xEE6600);
			_title.hCenter(E.stage);
			_title.y = E.HEIGHT >> 1 >> 1;
		}
		
		public function enter():void {
			_game.addChild(_title);
			//SoundManager.instance.playBGM( SoundManager.BGM1, 0 );
		}
		
		public function exit():void {
			_game.removeChild(_title);
			//SoundManager.instance.stopAllSound();
		}
	}
}