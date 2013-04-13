package com.nayael.crossover.characters.boss 
{
	import com.entity.engine.Body;
	import com.entity.engine.E;
	import com.entity.engine.fsm.StateMachine;
	import com.entity.engine.Health;
	import com.entity.engine.Physics;
	import com.entity.engine.View;
	import com.nayael.crossover.characters.boss.states.link.*;
	import com.nayael.crossover.characters.hero.Hero;
	import com.nayael.crossover.weapons.Bow;
	import com.nayael.crossover.weapons.Dasher;
	import com.nayael.crossover.weapons.Shield;
	import flash.display.MovieClip;
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
		static public const SHOOT:String  = "link_shoot";
		
		private var _attackCooldown:Timer = new Timer(1000, 1);
		private var _shieldDelay:int = 3500;
		private var _shieldTimer:Timer = new Timer(_shieldDelay, 1);
		private var _runTimer:Timer = new Timer(1, 1);
		private var _strength:int = 10;
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function Link() {
			_name = 'Link';
			_weakness = Dasher;
			_drop = Shield;
			_stunDelay = 1500;
			_invulnerabilityDelay = 1000;
			
			_hSpeed = 8;
			_vHeight = 25;
			
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
			
			weapon = new Bow(this);
			
			_fsm = new StateMachine();
			_fsm.addState( STAND , new Stand(this)      , [RUN, JUMP, SHIELD, ATTACK]);
			_fsm.addState( RUN   , new Running(this)    , [STAND, JUMP, SHIELD, ATTACK]);
			_fsm.addState( JUMP  , new Jumping(this)    , [STAND, RUN, ATTACK, SHIELD]);
			_fsm.addState( SHIELD, new ShieldState(this), [STAND, RUN, JUMP]);
			_fsm.addState( ATTACK, new Attack(this)     , [STAND, RUN, SHIELD, JUMP]);
			
			state = STAND;
			body.left = true;
			
			// Controls
			controls.shield = false;
			controls.attack = false;
			controls.shoot = false;
			
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
			var activateTimer:Timer = new Timer(2000, 1);
			activateTimer.addEventListener(TimerEvent.TIMER_COMPLETE, activateAI);
			activateTimer.start();
			health.setInvulnerable(3000);
			
			function activateAI(e:TimerEvent = null):void {
				activateTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, activateAI);
				controls.left = true;	// We make it run left at the start
				controls.jump = true;
				_activateAI();
			}
		}
		
		override public function update():void {
			// SHIELD state
			if (controls.shield) {
				state = SHIELD;
				_turnTowardsHero();
			} else {
				// Turns around when he hits a wall
				if (body.onWall) {
					releaseControls();
					_startRun();
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
				if (controls.jump && state != SHIELD) {
					startJump();
					controls.jump = false;
				}
				
				// ATTACK state
				if (controls.attack && !controls.shoot) {
					state = ATTACK;
					// If the attack animation is over
					var mc:MovieClip = (view.sprite.getChildAt(0) as MovieClip);
					if (mc.currentFrame == mc.totalFrames) {
						controls.attack = false;
						state = STAND;
					}
				}
				
				// SHOOT state
				if (controls.shoot) {
					state = SHOOT;
					// If the attack animation is over
					var sprite:MovieClip = (view.sprite.getChildAt(0) as MovieClip);
					if (sprite.currentLabel == 'shoot') {
						weapon.fire();
						controls.shoot = false;
						state = STAND;
					}
				}
			}
			
			if (!body.onFloor) {
				jump();
			}
			
			// Link hits the hero on state Attack
			if (state == ATTACK && body.collide(targets[0])) {
				var hero:Hero = targets[0] as Hero,
					heroHp:int = hero.health.hp;
				hero.onHit(_strength, Shield);
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
			if (!_AIactivated || state == ATTACK) {
				return;
			}
			
			if ((body.distance(targets[0]) < targets[0].view.sprite.width * targets[0].view.scale)) {
				_attack();
				return;
			} else if (_runTimer.running || _shieldTimer.running) {
				return;
			}
			
			_action = _action ? _action : ( (1 + Math.random() * 30) | 0 );
			switch (_action) {
				// Attack
				case 1: case 5:
					_attack();
					break;
				// Protect
				case 2:
					_shieldProtect();
					break;
				// Jump
				case 3:
					if (state != JUMP && state != SHIELD && body.onFloor) {
						controls.jump = true;
					}
					break;
				// Run
				case 4:
					_startRun();
					break;
				default:
			}
			_action = 0;
		}
		
		/**
		 * Link runs
		 */
		private function _startRun(delay:int = 0):void {
			if (state == SHIELD) {
				return;
			}
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
		 * Sword attack
		 */
		private function _attack():void {
			if (_attackCooldown.running || _shieldTimer.running && _shieldTimer.delay > 3000) {
				return;
			}
			controls.attack = true;
			_attackCooldown.reset();
			_attackCooldown.start();
		}
		
		/**
		 * Bow attack
		 */
		private function _shoot():void {
			if (_attackCooldown.running || _shieldTimer.running && _shieldTimer.delay > 3000) {
				return;
			}
			controls.attack = true;
			_attackCooldown.reset();
			_attackCooldown.start();
		}
		
		/**
		 * Shield protection
		 */
		private function _shieldProtect():void {
			if (_shieldTimer.running) {	// If he was already shielding, we restart the timer
				_shieldTimer.reset();
				_shieldTimer.start();
				return;
			}
			releaseControls();
			physics.vX = 0;
			controls.shield = true;
			//if (_shieldTimer.running) {	// If he was already shielding, we restart the hield timer, but a little shorter
				//if (_shieldTimer.hasEventListener(TimerEvent.TIMER_COMPLETE)) {
					//_shieldTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, _stopShield);
				//}
				//_shieldTimer = new Timer(_shieldTimer.delay - 300, 1);
			//}
			_shieldTimer.addEventListener(TimerEvent.TIMER_COMPLETE, _stopShield);
			_shieldTimer.reset();
			_shieldTimer.start();
		}
		
		/**
		 * Stops the dash
		 * @param	e
		 */
		private function _stopShield(e:TimerEvent = null):void {
			if (_shieldTimer.hasEventListener(TimerEvent.TIMER_COMPLETE)) {
				_shieldTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, _stopShield);
			}
			_shieldTimer.reset();
			_shieldTimer = new Timer(_shieldDelay, 1);
			releaseControls();
			if (_stunTimer.running) {
				if (Math.random() <= 0.6) {
					controls.jump = true;
				} else {
					_attack();
				}
			}
		}
		
		override public function onHit(damage:int, hitWeapon:Class = null, vX:Number = 0, vY:Number = 0):void {
			if (!hitWeapon || !health.vulnerable) {
				return;
			}
			// If the weapon hitting is not the weakness, damage is poor
			if (hitWeapon != _weakness) {
				if (_stunTimer.running || _shieldTimer.running) {	// If hit while already stun, or protecting, protect with the shield
					_shieldProtect();
				} else {
					// The boss was hit by a weak weapon
					health.damage(2);
					physics.vX = 5 * (vX > 0 ? 1 : -1);
					_stun(_stunDelay, function ():void {
						if (body.onFloor && state != SHIELD) {
							if (Math.random() <= 0.6) {
								controls.jump = true;
							} else {
								_attack();
							}
						}
					});
				}
			} else {
				health.damage(damage);
				physics.vX = 5 * damage * (vX > 0 ? 1 : -1);
				_stopShield();
				_stun(900, function ():void {
					if (body.onFloor && state != SHIELD) {
						if (Math.random() <= 0.6) {
							_startRun(2000 + Math.random() * 2000);
						} else {
							_attack();
						}
					}
				});
			}
		}
		
		override protected function releaseControls():void {
			super.releaseControls();
			_stopRun();
		}
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}