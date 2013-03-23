package com.nayael.crossover.states 
{
	import com.entity.engine.E;
	import com.entity.engine.fsm.IState;
	import com.entity.engine.SoundManager;
	import com.nayael.crossover.Main;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
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
			_game.removeChild(_game.hud);
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
				// DEATH DEBUG
				case Keyboard.G:
					E.stage.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
					
					var debugDeath:uint = setInterval(function():void {
						if (!_game.hero.health) {
							clearInterval(debugDeath);
							return;
						}
						_game.hero.health.hp -= 2;
					}, 100);
					
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