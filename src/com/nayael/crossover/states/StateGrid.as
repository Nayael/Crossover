package com.nayael.crossover.states 
{
	import com.entity.engine.E;
	import com.entity.engine.fsm.IState;
	import com.entity.engine.SoundManager;
	import com.nayael.crossover.Main;
	import com.nayael.crossover.ui.BossGrid;
	import com.nayael.crossover.utils.Text;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class StateGrid implements IState
	{
		private var _text:Text;
		private var _game:Main;
		private var _grid:BossGrid;
		
		public function StateGrid(game:Main) {
			_game = game;
		}
		
		public function enter():void {
			_text = new Text('Choose your enemy', 'PressStart2P');
			_text.hCenter(E.stage);
			_text.y = 50;
			_game.addChild(_text);
			//SoundManager.instance.playBGM( SoundManager.BGM3 );
			
			_grid = new BossGrid();
			_game.addChild(_grid);
			
			E.stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
		}
		
		public function exit():void {
			_game.removeChild(_grid);
			_text.remove();
			//SoundManager.instance.stopAllSound();
		}
		
		private function _onKeyDown(e:KeyboardEvent):void {
			if (e.keyCode != Keyboard.SPACE
			 && e.keyCode != Keyboard.UP
			 && e.keyCode != Keyboard.DOWN
			 && e.keyCode != Keyboard.RIGHT
			 && e.keyCode != Keyboard.LEFT) {
				return;
			}
			
			switch (e.keyCode) {
				case Keyboard.SPACE:
					E.stage.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
					_game.launchLevel(1);
					return;
					break;
			}
		}
	}
}