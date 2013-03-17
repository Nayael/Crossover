package com.nayael.crossover
{
	import com.entity.engine.E;
	import com.entity.engine.Entity;
	import com.entity.engine.fsm.StateMachine;
	import com.entity.engine.Game;
	import com.nayael.crossover.hero.Hero;
	import com.nayael.crossover.states.*;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Main game class for the Crossover game
	 * @author Nayael
	 */
	[SWF(width="800",height="600",frameRate="30",backgroundColor="0x0")]
	public class Main extends Game 
	{
        public var enemies:Vector.<Entity> = new Vector.<Entity>();
        public var players:Vector.<Entity> = new Vector.<Entity>();
		public var hero:Hero;
		
		// Game States
		public static const MAIN_MENU:String = "game_main_menu_state";
		public static const GRID:String 	 = "game_grid_state";
		public static const ARENA:String     = "game_arena_state";
		public static const PAUSE:String 	 = "game_pause_state";
		public static const GAME_OVER:String = "game_over_state";
		public var fsm:StateMachine;
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			E.stage = stage;
			
			fsm = new StateMachine();
			fsm.addState( MAIN_MENU, new StateMainMenu(this), [GRID]);
			fsm.addState( GRID     , new StateGrid(this)    , [MAIN_MENU, ARENA]);
			fsm.addState( ARENA    , new StateArena(this)   , [GAME_OVER, PAUSE]);
			fsm.addState( PAUSE    , new StatePause(this)   , [ARENA]);
			fsm.addState( GAME_OVER, new StateGameOver(this), [MAIN_MENU]);
			
			fsm.state = MAIN_MENU;
		}
	}
}