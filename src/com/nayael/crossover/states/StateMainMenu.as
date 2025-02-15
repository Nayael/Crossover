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
	
	public class StateMainMenu implements IState
	{
		private var _texts:Vector.<Text>    = new Vector.<Text>();
		private var _options:Vector.<Array> = new Vector.<Array>();
		private var _cursor:Text            = new Text('> ', 'PressStart2P');
		private var _selected:int           = 0;
		private var _game:Main;
		
		public function StateMainMenu(game:Main) {
			var text:Text;
			_game = game;
			
			text = new Text('Megaboy', 'PressStart2P', 42, 0xEE1100);
			text.hCenter(E.stage);
			text.y = (E.HEIGHT >> 1 >> 1) - 25;
			_texts.push(text);
			
			text = new Text('Against the World', 'PressStart2P', 28, 0xEE1100);
			text.hCenter(E.stage);
			text.y = (E.HEIGHT >> 1 >> 1) + 40;
			_texts.push(text);
			
			text = new Text('New Game', 'PressStart2P');
			text.x = 252;
			text.y = (E.HEIGHT >> 1) + 100;
			_texts.push(text);
			
			_options.push([Main.GRID, text]);
			
			text = new Text('Instructions', 'PressStart2P');
			text.x = 252;
			text.y = (E.HEIGHT >> 1) + 180;
			_texts.push(text);
			
			_options.push([Main.INSTRUCTIONS, text]);
		}
		
		public function enter():void {
			for each (var text:Text in _texts) {
				_game.addChild(text);
			}
			_selectOption(0);
			
			E.stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeydown);
		}
		
		public function exit():void {
			for each (var text:Text in _texts) {
				text.remove();
			}
			_cursor.remove();
		}
		
		/**
		 * Keydown listener.
		 * @param	e
		 */
		private function _onKeydown(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case Keyboard.UP: case Keyboard.Z:
					E.stage.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeydown);
					_selectOption(_selected - 1);
					E.stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeydown);
					break;
					
				case Keyboard.DOWN: case Keyboard.S:
					E.stage.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeydown);
					_selectOption(_selected + 1);
					E.stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeydown);
					break;
					
				// Validate the selected option
				case Keyboard.SPACE:
					E.stage.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeydown);
					_game.fsm.state = _options[_selected][0];
					break;
			}
		}
		
		/**
		 * Moves the cursor to select an option in the menu
		 * @param	index
		 */
		private function _selectOption(index:int):void {
			if (index < 0 || index >= _options.length) {
				return;
			}
			if (_cursor.stage == null) {
				_game.addChild(_cursor);
			}
			_selected = index;
			_cursor.x = _options[_selected][1].x - _cursor.width;
			_cursor.y = _options[_selected][1].y;
		}
	}
}