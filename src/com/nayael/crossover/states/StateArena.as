package com.nayael.crossover.states 
{
	import com.entity.engine.E;
	import com.entity.engine.fsm.IState;
	import com.entity.engine.SoundManager;
	import com.nayael.crossover.Main;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class StateArena implements IState
	{
		private var _game:Main;
		
		public function StateArena(game:Main) {
			_game = game;
		}
		
		public function enter():void {
			//SoundManager.instance.playBGM( SoundManager.BGM3 );
			E.stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
		}
		
		public function exit():void {
			//SoundManager.instance.stopAllSound();
		}
		
		private function _onKeyDown(e:KeyboardEvent):void {
			if (e.keyCode != Keyboard.SPACE
			 && e.keyCode != Keyboard.ESCAPE
			 && e.keyCode != Keyboard.G
			 && e.keyCode != Keyboard.RIGHT
			 && e.keyCode != Keyboard.LEFT) {
				return;
			}
			
			switch (e.keyCode) {
				case Keyboard.G:
					_game.fsm.state = Main.GAME_OVER;
					E.stage.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
					return;
					break;
			}
		}
	}
}