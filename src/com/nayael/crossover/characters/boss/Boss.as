package com.nayael.crossover.characters.boss 
{
	import com.entity.engine.Entity;
	import com.entity.engine.EventBroker;
	import com.entity.engine.utils.errors.AbstractClassError;
	import com.entity.engine.utils.errors.AbstractMethodError;
	import com.entity.engine.Weapon;
	import com.nayael.crossover.characters.Character;
	import com.nayael.crossover.characters.hero.Hero;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * Abstract class for boss enemies in the game
	 * @author Nayael
	 */
	public class Boss extends Character
	{
	////////////////////////
	// PROPERTIES
	//
		protected var _stunDelay:int;
		protected var _invulnerabilityDelay:int = 1000;
		protected var _name:String;
		protected var _stunTimer:Timer = new Timer(1, 1);
		protected var _weakness:Class; 	// The class of the weapon which the boss is the most vulnerable to
		protected var _drop:Class;		// The class of the weapon to drop when the boss dies
		protected var _AIactivated:Boolean = true;
		protected var _action:int;
		protected var controls:Object = {
			left: false,
			right: false,
			jump: false
		};
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function Boss() {
			if (Object(this).constructor === Boss) {
				throw new AbstractClassError(this);
			}
		}
	
	////////////////////////
	// METHODS
	//
		override public function update():void {
			if (controls.jump) {
				startJump();
				controls.jump = false;
			}
			handleAI();
			super.update();
		}
		
		protected function _activateAI(e:TimerEvent = null):void {
			_AIactivated = true;
		}
		
		/**
		 * The boss' artificial intelligence
		 * @abstract
		 */
		public function handleAI():void {
			throw new AbstractMethodError(this, 'handleAI');
		}
		
		override public function onDie():void {
			var hero:Hero = targets[0] as Hero;
			hero.disableControls();
			dropWeapon();
			destroy();
			EventBroker.broadcast(new BossEvent(BossEvent.BOSS_DEAD, _drop));
			hero.state = Hero.WIN;
		}
		
		override public function onHurt():void {
			super.onHurt();
			view.blink(150, 4);
			health.setInvulnerable(_invulnerabilityDelay, function():void {
				view.stopBlink();
			});
		}
		
		/**
		 * Makes the boss drop a weapon and gives it to the hero
		 */
		protected function dropWeapon():void {
			var hero:Hero = targets[0] as Hero;
			hero.takeWeapon(_drop);
		}
		
		protected function releaseControls():void {
			for (var name:String in controls) {
				controls[name] = false;
			}
		}
		
		protected function _stun(delay:int = 0, callback:Function = null):void {
			releaseControls();
			if (_stunTimer.running) {
				_stunTimer.delay = delay ? delay : _stunDelay;
				_stunTimer.reset();
				_stunTimer.start();
				return;
			}
			_AIactivated = false;
			_stunTimer = new Timer(delay ? delay : _stunDelay, 1);
			_stunTimer.addEventListener(TimerEvent.TIMER_COMPLETE, _activateAI);
			if (callback != null) {
				_stunTimer.addEventListener(TimerEvent.TIMER_COMPLETE, callback);
			}
			_stunTimer.start();
		}
	
	////////////////////////
	// GETTERS & SETTERS
	//
		public function get name():String {
			return _name;
		}
	}
}