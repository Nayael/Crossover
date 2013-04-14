package com.nayael.crossover.characters.boss 
{
	import com.entity.engine.Body;
	import com.entity.engine.E;
	import com.entity.engine.fsm.StateMachine;
	import com.entity.engine.Health;
	import com.entity.engine.Physics;
	import com.entity.engine.View;
	import com.nayael.crossover.characters.boss.states.donkeykong.*;
	import com.nayael.crossover.weapons.BarrelThrower;
	import com.nayael.crossover.weapons.Shield;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * Donkey Kong, a boss of the game
	 * @author Nayael
	 */
	public class DonkeyKong extends Boss
	{
	////////////////////////
	// PROPERTIES
	//
		static public const STAND:String  = "link_stand";
		static public const RUN:String    = "link_run";
		static public const JUMP:String   = "link_jump";
		static public const ATTACK:String = "link_attack";
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function DonkeyKong() {
			_name = 'DonkeyKong';
			_weakness = Shield;
			_drop = BarrelThrower;
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
			
			weapon = new BarrelThrower(this);
			
			_fsm = new StateMachine();
			_fsm.addState( STAND , new Stand(this)  , [RUN, JUMP, ATTACK]);
			_fsm.addState( RUN   , new Running(this), [STAND, JUMP, ATTACK]);
			_fsm.addState( JUMP  , new Jumping(this), [STAND, RUN, ATTACK]);
			_fsm.addState( ATTACK, new Attack(this) , [STAND, RUN, JUMP]);
			
			state = STAND;
			body.left = true;
			
			// Controls
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
			var mc:MovieClip;
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
			if (controls.jump) {
				startJump();
				controls.jump = false;
			}
			
			// ATTACK state
			if (controls.attack) {
				state = ATTACK;
				mc = (view.sprite.getChildAt(0) as MovieClip);
				if (mc.currentFrameLabel == 'shoot' && weapon.cooldown == 0) {
					weapon.fire();
				}
				if (mc.currentFrame == mc.totalFrames) {
					controls.attack = false;
					_activateAI();
				}
			}
			
			if (!body.onFloor) {
				jump();
			}
			
			super.update();
		}
		
		/**
		 * Donkey Kong's AI
		 */
		override public function handleAI():void {
			if (!_AIactivated || state == ATTACK) {
				return;
			}
			
			if ((body.distance(targets[0]) < targets[0].view.sprite.width * targets[0].view.scale)) {
				_attack();
				return;
			} else if (_runTimer.running) {
				return;
			}
			
			_action = _action ? _action : ( (1 + Math.random() * 30) | 0 );
			switch (_action) {
				// Attack
				case 1: case 2: case 3:
					_attack();
					break;
				// Jump
				case 4:
					if (state != JUMP && body.onFloor) {
						controls.jump = true;
					}
					break;
				// Run
				case 5:
					_startRun();
					break;
				default:
			}
			_action = 0;
		}
		
		/**
		 * Attack
		 */
		private function _attack():void {
			releaseControls();
			controls.attack = true;
			_AIactivated = false;
		}
		
		override public function onHit(damage:int, hitWeapon:Class = null, vX:Number = 0, vY:Number = 0):void {
			if (!hitWeapon || !health.vulnerable) {
				return;
			}
			var critical:Boolean = (hitWeapon == _weakness) ? true : false;
			health.damage(critical ? 2 : damage);
			physics.vX = 5 * (vX > 0 ? 1 : -1);
			_stun(critical ? _stunDelay : 900, function ():void {
				if (body.onFloor) {
					if (Math.random() <= 0.6) {
						controls.jump = true;
					} else {
						_attack();
					}
				}
			});
		}
		
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}