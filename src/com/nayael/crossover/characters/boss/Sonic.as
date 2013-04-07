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
		static public const CHARGE:String = "sonic_dash";
		static public const DASH:String   = "sonic_charge";
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function Sonic() {
			weakness = BarrelGun;
			drop = Dasher;
			
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
			_fsm.addState( STAND , new Stand(this)  , [RUN, JUMP]);
			_fsm.addState( RUN   , new Running(this), [STAND, JUMP]);
			_fsm.addState( JUMP  , new Jumping(this), [STAND, RUN]);
			_fsm.addState( CHARGE, new Charge(this) , [STAND, RUN]);
			_fsm.addState( DASH  , new Dash(this)   , [STAND, RUN]);
			
			state = STAND;
			body.left = true;
			
			AIactivated = false;
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
			// STAND state
			if (body.onFloor && physics.vX == 0) {
				if (state == JUMP) {
					controls.left = controls.right = controls.jump = false;
				}
				state = STAND;
			}
			
			if (body.onWall) {
				controls.left = controls.right = controls.jump = false;
				if (physics.vX < 0) {
					moveRight();
				} else {
					moveLeft();
				}
			}
			
			// RUNNING state
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
			if (!body.onFloor && physics.vY != 0) {
				state = JUMP;
			}
			if (controls.jump) {
				startJump();
			}
			if (state == JUMP) {
				jump();
			}
			
			super.update();
		}
		
		override public function handleAI():void {
			if (!AIactivated) {
				return;
			}
		}
		
		public function chargeDash():void {
			
		}
		
		override public function onHit(damage:int, weapon:Weapon = null):void {
			if (!weapon) {
				return;
			}
			// If the weapon hitting is not the weakness, damage is poor
			if (weapon is weakness) {
				health.damage(4);
			} else {
				health.damage(damage);
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