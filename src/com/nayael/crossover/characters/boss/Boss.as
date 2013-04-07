package com.nayael.crossover.characters.boss 
{
	import com.entity.engine.Entity;
	import com.entity.engine.utils.errors.AbstractClassError;
	import com.entity.engine.utils.errors.AbstractMethodError;
	import com.entity.engine.Weapon;
	import com.nayael.crossover.characters.Character;
	import com.nayael.crossover.characters.hero.Hero;
	import flash.events.TimerEvent;
	
	/**
	 * Abstract class for boss enemies in the game
	 * @author Nayael
	 */
	public class Boss extends Character
	{
	////////////////////////
	// PROPERTIES
	//
		protected var weakness:Class; 	// The class of the weapon which the boss is the most vulnerable to
		protected var drop:Class;		// The class of the weapon to drop when the boss dies
		protected var AIactivated:Boolean = true;
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
			AIactivated = true;
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
			hero.state = Hero.WIN;
		}
		
		/**
		 * Makes the boss drop a weapon and gives it to the hero
		 */
		protected function dropWeapon():void {
			var hero:Hero = targets[0] as Hero;
			hero.takeWeapon(drop);
		}
		
		protected function releaseControls():void {
			for (var name:String in controls) {
				//trace(name);
				controls[name] = false;
			}
			//for each (var item:* in controls) {
				//item = false;
			//}
		}
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}