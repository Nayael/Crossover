package com.nayael.crossover.states 
{
	import com.entity.engine.E;
	import com.entity.engine.fsm.IState;
	import com.entity.engine.SoundManager;
	import com.nayael.crossover.Main;
	import com.nayael.crossover.utils.Text;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class StateInstructions implements IState
	{
		private var _texts:Vector.<Text> = new Vector.<Text>();
		private var _game:Main;
		
		public function StateInstructions(game:Main) {
			var text:Text;
			_game = game;
			
			text = new Text('Instructions', 'PressStart2P', 28, 0xEE1100);
			text.hCenter(E.stage);
			text.y = (E.HEIGHT >> 3);
			_texts.push(text);
			
			text = new Text('Move with Q/D or Left/Right', 'PressStart2P');
			text.hCenter(E.stage);
			text.y = (E.HEIGHT >> 2) + 10;
			_texts.push(text);
			
			text = new Text('Jump/Wall jump with SPACE', 'PressStart2P');
			text.hCenter(E.stage);
			text.y = (E.HEIGHT >> 2) + 90;
			_texts.push(text);
			
			text = new Text('Shoot with K', 'PressStart2P');
			text.hCenter(E.stage);
			text.y = (E.HEIGHT >> 1) + 20;
			_texts.push(text);
			
			text = new Text('Change weapon with L', 'PressStart2P');
			text.hCenter(E.stage);
			text.y = (E.HEIGHT >> 1) + 100;
			_texts.push(text);
			
			text = new Text('Pause game with ESCAPE', 'PressStart2P');
			text.hCenter(E.stage);
			text.y = (E.HEIGHT >> 1) + 180;
			_texts.push(text);
		}
		
		public function enter():void {
			for each (var text:Text in _texts) {
				_game.addChild(text);
			}
			
			E.stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeydown);
		}
		
		public function exit():void {
			for each (var text:Text in _texts) {
				text.remove();
			}
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