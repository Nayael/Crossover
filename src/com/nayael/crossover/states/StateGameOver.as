package com.nayael.crossover.states 
{
	import com.entity.engine.E;
	import com.entity.engine.fsm.IState;
	import com.entity.engine.SoundManager;
	import com.nayael.crossover.Main;
	
	public class StateGameOver implements IState
	{
		private var _game:Main;
		//private var _goMC:GameOverMC;
		
		public function StateGameOver(game:Main) {
			_game = game;
			//_goMC = new GameOverMC;
		}
		
		public function enter():void {
			//_game.addChild( E.setProps(_goMC, { x:400 , y:int(E.HEIGHT * 1 / 3) } ) );
			//_goMC.gotoAndPlay( 1 );
			//
			//SoundManager.instance.playBGM( SoundManager.BGM2, 0 );
		}
		
		public function exit():void {
			//SoundManager.instance.stopAllSound();
			//if(_goMC.stage){
				//_game.removeChild( _goMC );
			//}
		}
	}
}