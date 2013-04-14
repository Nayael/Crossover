package com.nayael.crossover.weapons 
{
	import com.entity.engine.SoundManager;
	import com.entity.engine.Weapon;
	import com.nayael.crossover.characters.hero.Hero;
	import flash.events.TimerEvent;
	import flash.utils.clearTimeout;
	import flash.utils.Timer;
	
	/**
	 * Makes the character dash
	 */
	public class Dasher extends Weapon
	{
		public var speed:int = 40;
		public var strength:int = 10;
		public var dashTimer:Timer = new Timer(500, 1);	// The time during which the hero is dashing
		
		public function Dasher(entity:Hero) {
			maxAmmo = 25;
			super( entity );
			cooldownTime = 3000;
			color = 'Blue';
		}
		
		override public function fire():Boolean {
			if (cooldown != 0 || ammo == 0 || (entity as Hero).state == Hero.DASH) {
				return false;
			}
			//SoundManager.instance.playSfx( SoundManager.ACTION2 );
			(entity as Hero).state = Hero.DASH;
			dashTimer.addEventListener(TimerEvent.TIMER_COMPLETE, stopDash);
			dashTimer.start();
			
			return super.fire();
		}
		
		override public function endCooldown():void {
			clearTimeout(cooldown);
			dashTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, stopDash);
			dashTimer.reset();
			cooldown = 0;
		}
		
		public function stopDash(e:TimerEvent = null):void {
			dashTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, stopDash);
			dashTimer.reset();
		}
	}
}