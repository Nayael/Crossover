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
			for (var i:int = 0; i < _game.numChildren; i++) {
				if (!_game.getChildAt(i).visible) {
					_game.getChildAt(i).visible = true;
				}
			}
			E.stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
		}
		
		public function exit():void {
			
		}
		
		private function _onKeyDown(e:KeyboardEvent):void {
			if (e.keyCode != Keyboard.ESCAPE
			 && e.keyCode != Keyboard.M
			 && e.keyCode != Keyboard.G) {
				return;
			}
			
			switch (e.keyCode) {
				case Keyboard.M:
					_game.boss.onDie();
					return;
					break;
					
				case Keyboard.G:
					_game.hero.onDie();
					return;
					break;
				
				// PAUSE GAME
				case Keyboard.ESCAPE:
					E.stage.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
					_game.fsm.state = Main.PAUSE;
					return;
					break;
			}
		}
	}
}