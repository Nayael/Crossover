package com.nayael.crossover.states 
{
	import com.entity.engine.fsm.IState;
	import com.entity.engine.SoundManager;
	import com.nayael.crossover.Main;
	
	public class StatePause implements IState
	{
		private var _game:Main;
		//private var _pauseClip:PauseMC;
		
		public function StatePause(game:Main) {
			_game = game;
			//_pauseClip = new PauseMC;
		}
		
		public function enter():void {
			//_game.addChild( E.setProps(_pauseClip, {x:282, y:int(E.HEIGHT*1/3)} ) );
		}
		
		public function exit():void {
			//_game.removeChild( _pauseClip );
		}
	}
}