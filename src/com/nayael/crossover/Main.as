package com.nayael.crossover
{
	import com.entity.engine.E;
	import com.entity.engine.Entity;
	import com.entity.engine.EventBroker;
	import com.entity.engine.events.EntityEventType;
	import com.entity.engine.fsm.StateMachine;
	import com.entity.engine.Game;
	import com.nayael.crossover.hero.Hero;
	import com.nayael.crossover.states.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
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
		public static const INTRO:String     = "game_intro_state";
		public static const MAIN_MENU:String = "game_main_menu_state";
		public static const GRID:String 	 = "game_grid_state";
		public static const ARENA:String     = "game_arena_state";
		public static const RUNNING:String    = "game_running_state";
		public static const PAUSE:String 	 = "game_pause_state";
		public static const GAME_OVER:String = "game_over_state";
		public var fsm:StateMachine;
		
		// HUD
		//public static const UPDATE_HUD:String = "update_hud";		
		public var hud:HUD;
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			E.stage = this.stage;
			E.WIDTH = this.stage.stageWidth;
			E.HEIGHT = this.stage.stageHeight;
			E.original_framerate = this.stage.frameRate;
			
			EventBroker.subscribe( EntityEventType.DESTROYED, onEntityDestroyed );
			EventBroker.subscribe( EntityEventType.CREATED, onEntityCreated );
			
			fsm = new StateMachine();
			fsm.addState( INTRO    , new StateIntro(this)   , [MAIN_MENU]);
			fsm.addState( MAIN_MENU, new StateMainMenu(this), [GRID]);
			fsm.addState( GRID     , new StateGrid(this)    , [MAIN_MENU, ARENA]);
			fsm.addState( ARENA    , new StateArena(this)   , [GAME_OVER, PAUSE]);
			fsm.addState( PAUSE    , new StatePause(this)   , [ARENA, GRID]);
			fsm.addState( GAME_OVER, new StateGameOver(this), [MAIN_MENU]);
			
			fsm.state = INTRO;
		}
		
		public function startNewGame():void {
			trace('New game');
			hero = new Hero();
			players.push(hero);
		}
		
		public function launchLevel(index:int):void {
			trace('Entering level ' + index);
			hud = new HUD();
			fsm.state = ARENA;
			
			addEntity(hero);
			begin();
		}
		
		override protected function update():void {
			if (fsm.current != ARENA && fsm.current != RUNNING) {
				return;
			}
			
			super.update();
			updateHud();
		}
		
		public function updateHud(e:Event = null):void {
			if (fsm.current != ARENA && fsm.current != RUNNING) {
				return;
			}
			
			// Updating hero's side HUD
			if (hero.health) {
				hud.heroHP = hero.health.hp;
				//hud.heroAmmo = hero.weapon.ammo;
			} else {
				hud.heroHP = 0;
			}
			
			// If we are inside an arena with a boss
			// Updating enemy's side HUD
			/*if (fsm.current == ARENA) {
				if (boss.health) {
					hud.bossHP = boss.health.hp;
					hud.bossAmmo = boss.weapon.ammo;
				} else {
					hud.bossHP = 0;
				}
			}*/
			
			addChild(hud);
		}
	}
}