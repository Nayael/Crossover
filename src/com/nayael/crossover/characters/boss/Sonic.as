package com.nayael.crossover.characters.boss 
{
	import com.entity.engine.Body;
	import com.entity.engine.E;
	import com.entity.engine.fsm.StateMachine;
	import com.entity.engine.Game;
	import com.entity.engine.Health;
	import com.entity.engine.Physics;
	import com.entity.engine.View;
	import com.entity.engine.Weapon;
	import com.nayael.crossover.characters.boss.states.sonic.*;
	import com.nayael.crossover.characters.hero.Hero;
	import com.nayael.crossover.weapons.BarrelGun;
	import com.nayael.crossover.weapons.Dasher;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * Sonic, a boss of the game
	 * @author Nayael
	 */
	public class Sonic extends Boss
	{
	////////////////////////
	// PROPERTIES
	//
		static public const STAND:String  = "sonic_stand";
		static public const HURT:String   = "sonic_hurt";
		static public const RUN:String    = "sonic_run";
		static public const JUMP:String   = "sonic_jump";
		static public const CHARGE:String = "sonic_charge";
		static public const DASH:String   = "sonic_dash";
		
		private var _chargeTimer:Timer;
		private var _dashTimer:Timer;
		private var _runTimer:Timer = new Timer(1, 1);
		private var _strength:int = 10;
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function Sonic() {
			_name = 'Sonic';
			_weakness = BarrelGun;
			_drop = Dasher;
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
			_fsm.addState( STAND , new Stand(this)  , [RUN, JUMP, CHARGE]);
			_fsm.addState( RUN   , new Running(this), [STAND, JUMP, CHARGE]);
			_fsm.addState( JUMP  , new Jumping(this), [STAND, RUN]);
			_fsm.addState( CHARGE, new Charge(this) , [STAND, RUN, DASH]);
			_fsm.addState( DASH  , new Dash(this)   , [STAND, RUN, JUMP, CHARGE]);
			
			state = STAND;
			body.left = true;
			
			// Controls
			controls.charge = false;
			controls.dash = false;
			
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
					//moveRight();
				} else {
					controls.left = true;
					//moveLeft();
				}
				if (state == DASH) {
					var reboundVY:int = (-10 + Math.random() * 15) | 0;
					physics.vY = body.y < reboundVY ? physics.vY : reboundVY;
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
				if (body.onFloor && state != DASH) {
					state = RUN;
				}
			} else if (controls.right) {
				moveRight();
				if (body.onFloor && state != DASH) {
					state = RUN;
				}
			}
			
			// JUMP state
			if (!body.onFloor && (state != DASH || _dashTimer.running == false)) {
				state = JUMP;
			}
			if (controls.jump) {
				startJump();
			}
			if (state == JUMP) {
				jump();
			}
			
			if (controls.charge) {
				state = CHARGE;
			}
			
			// DASH state
			if (controls.dash) {
				state = DASH;
				if (body.left) {
					controls.left = true;
					controls.right = false;
				} else {
					controls.left = false;
					controls.right = true;
				}
			}
			
			if ((state == DASH || state == CHARGE) && body.collide(targets[0])) {
				var hero:Hero = targets[0] as Hero,
					heroHp:int = hero.health.hp;
				hero.onHit(_strength, Dasher);
				if (hero.physics && hero.health.hp != heroHp) {
					hero.physics.vX += _strength * (body.right ? 1 : -1);
					hero.physics.vY = - (5 + Math.random() * 10);
				}
			}
			
			super.update();
		}
		
		/**
		 * Sonic's AI
		 */
		override public function handleAI():void {
			if (!_AIactivated || state == JUMP || state == CHARGE || state == DASH || _runTimer.running) {
				return;
			}
			_action = _action ? _action : ( (1 + Math.random() * 30) | 0 );
			switch (_action) {
				// Charge the dash
				case 1:
					_chargeDash();
					break;
				// Run
				case 2:
					_startRun();
					break;
				default:
			}
			_action = 0;
		}
		
		/**
		 * Sonic runs
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
		
		/**
		 * Sonic charges the dash
		 */
		private function _chargeDash():void {
			if (state == CHARGE || state == DASH) {
				return;
			}
			releaseControls();
			controls.charge = true;
			_chargeTimer = new Timer(1000, 1);
			_chargeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, _dash);
			_chargeTimer.start();
		}
		
		/**
		 * Sonic attacks
		 * @param	e
		 */
		private function _dash(e:TimerEvent):void {
			_chargeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, _dash);
			controls.dash = true;
			_hSpeed = 30;
			_strength = 15;
			_dashTimer = new Timer((1500 + Math.random() * 4000 | 0), 1);
			_dashTimer.addEventListener(TimerEvent.TIMER_COMPLETE, _stopDash);
			_dashTimer.start();
		}
		
		/**
		 * Stops the dash
		 * @param	e
		 */
		private function _stopDash(e:TimerEvent = null):void {
			if (_dashTimer.hasEventListener(TimerEvent.TIMER_COMPLETE)) {
				_dashTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, _stopDash);
			}
			_hSpeed = 13;
			releaseControls();
		}
		
		override public function onHit(damage:int, weapon:Class = null, vX:Number = 0, vY:Number = 0):void {
			if (!weapon) {
				return;
			}
			// If the weapon hitting is not the weakness, damage is poor
			if (weapon != _weakness) {
				var hitProbability:Number = 0.2;	// The probability for the weak weapon to make damage to the boss in CHARGE or DASH state
				if (state != CHARGE && state != DASH || Math.random() <= hitProbability) {
					// The boss was hit by a weak weapon
					health.damage(2);
					physics.vX = 5 * (vX > 0 ? 1 : -1);
					_stun(300, function ():void {
						if (body.onFloor) {
							if (Math.random() <= 0.6) {
								_startRun(2000 + Math.random() * 2000);
							} else {
								_chargeDash();
							}
						}
					});
				}
			} else {
				health.damage(damage);
				physics.vX = 5 * damage * (vX > 0 ? 1 : -1);
				_stun(900, function ():void {
					if (body.onFloor) {
						if (Math.random() <= 0.6) {
							_startRun(2000 + Math.random() * 2000);
						} else {
							_chargeDash();
						}
					}
				});
			}
		}
		
		override public function onDie():void {
			super.onDie();
		}
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}