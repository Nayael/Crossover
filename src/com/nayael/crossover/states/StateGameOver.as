package com.nayael.crossover.states 
{
	import com.entity.engine.E;
	import com.entity.engine.fsm.IState;
	import com.entity.engine.SoundManager;
	import com.nayael.crossover.Main;
	import com.nayael.crossover.utils.Text;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class StateGameOver implements IState
	{
		private var _texts:Vector.<Text> = new Vector.<Text>();
		private var _game:Main;
		
		public function StateGameOver(game:Main) {
			var text:Text;
			_game = game;
			
			text = new Text('Game Over', 'PressStart2P', 42, 0xEE1100);
			text.hCenter(E.stage);
			text.y = (E.HEIGHT >> 1 >> 1) - 25;
			_texts.push(text);
			
			text = new Text('Press Start to retry', 'PressStart2P');
			text.hCenter(E.stage);
			text.y = (E.HEIGHT >> 1) + 100;
			_texts.push(text);
		}
		
		public function enter():void {
			_game.exitLevel();
			for each (var text:Text in _texts) {
				_game.addChild(text);
			}
			//SoundManager.instance.playBGM( SoundManager.BGM2, 0 );
			E.stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeydown);
		}
		
		public function exit():void {
			for each (var text:Text in _texts) {
				text.remove();
			}
			//SoundManager.instance.stopAllSound();
		}
		
		/**
		 * Keydown listener. Used to go to the main menu
		 * @param	e
		 */
		private function _onKeydown(e:KeyboardEvent):void {
			if (e.keyCode != Keyboard.SPACE) {
				return;
			}
			E.stage.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeydown);
			_game.fsm.state = Main.MAIN_MENU;
		}
	}
}