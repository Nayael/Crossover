package com.nayael.crossover
{
	import com.entity.engine.E;
	import com.entity.engine.Entity;
	import com.entity.engine.EventBroker;
	import com.entity.engine.events.EntityEventType;
	import com.entity.engine.fsm.StateMachine;
	import com.entity.engine.Game;
	import com.entity.engine.Map;
	import com.entity.engine.SoundManager;
	import com.nayael.crossover.arenas.Arena;
	import com.nayael.crossover.characters.boss.Boss;
	import com.nayael.crossover.characters.boss.BossEvent;
	import com.nayael.crossover.characters.hero.Hero;
	import com.nayael.crossover.characters.hero.HeroEvent;
	import com.nayael.crossover.events.LevelEvent;
	import com.nayael.crossover.states.*;
	import com.nayael.crossover.utils.Text;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.utils.Timer;
	import net.hires.debug.Stats;
	
	/**
	 * Main game class for the Crossover game
	 * @author Nayael
	 */
	[SWF(width="800",height="600",frameRate="30",backgroundColor="0x0")]
	public class Main extends Game 
	{
		//private var _arena:Arena;
        public var enemies:Vector.<Entity> = new Vector.<Entity>();
        public var players:Vector.<Entity> = new Vector.<Entity>();
		public var hero:Hero;
		public var boss:Boss;
		
		// Game States
		public static const INTRO:String        = "game_intro_state";
		public static const INSTRUCTIONS:String = "game_instructions_state";
		public static const MAIN_MENU:String    = "game_main_menu_state";
		public static const GRID:String 	    = "game_grid_state";
		public static const ARENA:String        = "game_arena_state";
		public static const RUNNING:String      = "game_running_state";
		public static const PAUSE:String 	    = "game_pause_state";
		public static const GAME_OVER:String    = "game_over_state";
		public var fsm:StateMachine;
		
		// HUD
		//public static const UPDATE_HUD:String = "update_hud";		
		public var hud:HUD;
		
		
		[Embed(source = "../../../../lib/audio/victory.mp3")]
		private const VICTORY_CLASS:Class;
		
	////////////////////////
	// CONSTRUCTOR
	//
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.addChild(new Stats());
			
			E.stage = this.stage;
			E.WIDTH = this.stage.stageWidth;
			E.HEIGHT = this.stage.stageHeight;
			E.original_framerate = this.stage.frameRate;
			
			EventBroker.subscribe( EntityEventType.DESTROYED, onEntityDestroyed );
			EventBroker.subscribe( EntityEventType.CREATED, onEntityCreated );
			
			fsm = new StateMachine();
			fsm.addState( INTRO       , new StateIntro(this)       , [MAIN_MENU]);
			fsm.addState( MAIN_MENU   , new StateMainMenu(this)    , [GRID, INSTRUCTIONS]);
			fsm.addState( INSTRUCTIONS, new StateInstructions(this), [MAIN_MENU]);
			fsm.addState( GRID        , new StateGrid(this)        , [MAIN_MENU, ARENA]);
			fsm.addState( ARENA       , new StateArena(this)       , [GAME_OVER, PAUSE, GRID]);
			fsm.addState( PAUSE       , new StatePause(this)       , [ARENA, GRID]);
			fsm.addState( GAME_OVER   , new StateGameOver(this)    , [MAIN_MENU]);
			
			SoundManager.instance.addRessource( new VICTORY_CLASS() as Sound, SoundManager.SPECIAL1 );
			SoundManager.instance.setSFXVolume( .3 );
			
			fsm.state = INTRO;
		}
		
		/**
		 * When the player enters the level
		 * @param	arena
		 */
		public function launchLevel(arena:Arena):void {
			hero = new Hero();
			hero.group = players;
			players.push(hero);
			EventBroker.subscribe( HeroEvent.HERO_DEAD, _onHeroDead );
			EventBroker.subscribe( LevelEvent.FINISHED, _onFinishLevel );
			EventBroker.subscribe( BossEvent.BOSS_DEAD, _onBossDead );
			
			boss = arena.boss;
			boss.group = enemies;
			enemies.push(boss);
			hero.targets = Vector.<Entity>([boss]);
			boss.targets = Vector.<Entity>([hero]);
			
			_map = arena;
			hud = new HUD();
			map.draw(this);
			fsm.state = ARENA;
			
			addEntity(hero);
			addEntity(boss);
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
			} else {
				hud.heroHP = 0;
			}
			if (hero.weapon.usesAmmo) {
				hud.heroAmmo = hero.weapon.ammo;
			} else {
				hud.hideHeroAmmo();
			}
			
			// If we are inside an arena with a boss
			// Updating enemy's side HUD
			if (fsm.current == ARENA) {
				hud.showBossHUD();
				if (boss && boss.health) {
					hud.bossHP = boss.health.hp;
				} else {
					hud.bossHP = 0;
				}
			} else {
				hud.hideBossHUD();
			}
			
			addChild(hud);
		}
		
		/**
		 * When the hero is dead : Game Over
		 */
		private function _onHeroDead(e:Event = null):void {
			players.splice(players.indexOf(hero), 1);
			fsm.state = GAME_OVER;
		}
		
		private function _onBossDead(e:BossEvent):void {
			var weaponName:String = String(e.drop).replace('[class ', '').replace(']', ''),
				text:Text = new Text('New weapon : ' + weaponName + ' !', 'PressStart2P');
			var textTimer:Timer = new Timer(8000, 1);
			
			text.hCenter(this);
			text.y = E.HEIGHT >> 2;
			addChild(text);
			
			textTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent = null):void {
				removeChild(text);
			});
			textTimer.start();
			
			SoundManager.instance.playSfx( SoundManager.SPECIAL1 );
			EventBroker.unsubscribe(BossEvent.BOSS_DEAD, _onBossDead);
		}
		
		private function _onFinishLevel(e:LevelEvent = null):void {
			if (hero.health) {
				Hero.save.saveData('hp', hero.health.hp);	// We save the hero's HP
			}
			map.destroy(this);
			if (hud.parent == this) {
				removeChild(hud);
			}
			end();
			players.length = 0;
			enemies.length = 0;
			if (e.win) {
				fsm.state = GRID;
			}
		}
		
		override public function get map():Map {
			return _map as Arena;
		}
	}
}