package com.nayael.crossover.characters.boss 
{
	import com.entity.engine.Body;
	import com.entity.engine.E;
	import com.entity.engine.fsm.StateMachine;
	import com.entity.engine.Health;
	import com.entity.engine.Physics;
	import com.entity.engine.View;
	import com.nayael.crossover.characters.boss.states.link.*;
	import com.nayael.crossover.weapons.Dasher;
	import com.nayael.crossover.weapons.Shield;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * Link, a boss of the game
	 * @author Nayael
	 */
	public class Link extends Boss
	{
	////////////////////////
	// PROPERTIES
	//
		static public const STAND:String  = "link_stand";
		static public const HURT:String   = "link_hurt";
		static public const RUN:String    = "link_run";
		static public const JUMP:String   = "link_jump";
		static public const SHIELD:String = "link_shield";
		static public const ATTACK:String = "link_attack";
		
		private var _runTimer:Timer = new Timer(1, 1);
		private var _strength:int = 10;
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function Link() {
			_name = 'Link';
			_weakness = Dasher;
			_drop = Shield;
			_stunDelay = 500;
			_invulnerabilityDelay = 500;
			
			_hSpeed = 13;
			_vHeight = 30;
			
			body = new Body(this);
			body.x = E.WIDTH - (E.WIDTH >> 2);
			body.y = E.HEIGHT - 40;
			body.angle = 90;
			
			physics = new Physics(this);
			physics.vX = 0;
			physics.vY = 8;
			
			view = new View(this);
			view.scale = 2;
			view.draw();
			
			health = new Health(this);
			health.maxHp = 100;
			health.hp = health.maxHp;
			
			_fsm = new StateMachine();
			_fsm.addState( STAND , new Stand(this)  , [RUN, JUMP, SHIELD, ATTACK]);
			_fsm.addState( RUN   , new Running(this), [STAND, JUMP, SHIELD, ATTACK]);
			_fsm.addState( JUMP  , new Jumping(this), [STAND, RUN, ATTACK]);
			_fsm.addState( SHIELD, new ShieldState(this) , [STAND, RUN, ATTACK]);
			_fsm.addState( ATTACK, new Attack(this) , [STAND, RUN, SHIELD]);
			
			state = STAND;
			body.left = true;
			
			// Controls
			controls.shield = false;
			controls.attack = false;
			
			_AIactivated = false;
			view.sprite.addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}
	
	////////////////////////
	// METHODS
	//
		/**
		 * Called when the boss is added to the stage (init)
		 * @param	e
		 */
		private function _onAddedToStage(e:Event):void {
			view.sprite.removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			// Starting a timer to activate the AI after 2 seconds
			var activateTimer:Timer = new Timer(1000, 1);
			activateTimer.addEventListener(TimerEvent.TIMER_COMPLETE, activateAI);
			activateTimer.start();
			
			function activateAI(e:TimerEvent = null):void {
				activateTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, activateAI);
				controls.left = true;	// We make it run left at the start
				controls.jump = true;
				_activateAI();
			}
		}
		
		override public function update():void {
			// Turns around when he hits a wall
			if (body.onWall) {
				controls.left = controls.right = controls.jump = false;
				if (physics.vX <= 0) {
					controls.right = true;
				} else {
					controls.left = true;
				}
			}
			
			// STAND state
			if (body.onFloor && physics.vX == 0) {
				if (state == JUMP) {
					releaseControls();
				}
				state = STAND;
			}
			
			// RUNNING state
			physics.vX = 0;
			if (controls.left) {
				moveLeft();
				if (body.onFloor) {
					state = RUN;
				}
			} else if (controls.right) {
				moveRight();
				if (body.onFloor) {
					state = RUN;
				}
			}
			
			// JUMP state
			if (!body.onFloor) {
				state = JUMP;
			}
			if (controls.jump) {
				startJump();
			}
			if (state == JUMP) {
				jump();
			}
			
			// SHIELD state
			if (controls.shield) {
				state = SHIELD;
			}
			
			// ATTACK state
			if (controls.attack) {
				state = ATTACK;
			}
			
			// Link hits the hero on state Attack
			if (state == ATTACK && body.collide(targets[0])) {
				//var hero:Hero = targets[0] as Hero,
					//heroHp:int = hero.health.hp;
				//hero.onHit(_strength, Dasher);
				//if (hero.physics && hero.health.hp != heroHp) {
					//hero.physics.vX += _strength * (body.right ? 1 : -1);
					//hero.physics.vY = - (5 + Math.random() * 10);
				//}
			}
			
			super.update();
		}
		
		/**
		 * Sonic's AI
		 */
		override public function handleAI():void {
			if (!_AIactivated || state == ATTACK || _runTimer.running) {
				return;
			}
			_action = _action ? _action : ( (1 + Math.random() * 30) | 0 );
			switch (_action) {
				// Attack
				case 1:
					_attack();
					break;
				// Run
				case 2:
					_startRun();
					break;
				default:
			}
			_action = 0;
		}
		
		private function _attack():void {
			
		}
		
		/**
		 * Link runs
		 */
		private function _startRun(delay:int = 0):void {
			_runTimer = new Timer(delay ? delay : ( (1000 + Math.random() * 4000) | 0 ), 1 );
			_runTimer.addEventListener(TimerEvent.TIMER_COMPLETE, _stopRun);
			controls.left = Math.random() >= 0.5 ? true : false;
			controls.right = !controls.left;
			_strength = 5;
			_runTimer.start();
		}
		
		/**
		 * Stops the running
		 * @param	e
		 */
		private function _stopRun(e:TimerEvent = null):void {
			_runTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, _stopRun);
			_runTimer.reset();
			controls.left = controls.right = false;
		}
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}