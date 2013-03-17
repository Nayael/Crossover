package com.nayael.crossover.states 
{
	import com.entity.engine.fsm.IState;
	import com.entity.engine.SoundManager;
	import com.nayael.crossover.Main;
	
	public class StateGrid implements IState
	{
		private var _game:Main;
		
		public function StateGrid(game:Main) {
			_game = game;
		}
		
		public function enter():void {
			//SoundManager.instance.playBGM( SoundManager.BGM3 );
		}
		
		public function exit():void {
			//SoundManager.instance.stopAllSound();
		}
	}
}