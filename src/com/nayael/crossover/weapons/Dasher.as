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
		public var speed:int = 13;
		public var dashTimer:Timer = new Timer(1500, 1);
		
		public function Dasher(entity:Hero) {
			usesAmmo = false;
			cooldownTime = 500;
			super( entity );
		}
		
		override public function fire():Boolean {
			if (cooldown != 0 || (entity as Hero).state == Hero.DASH) {
				return false;
			}
			//SoundManager.instance.playSfx( SoundManager.ACTION2 );
			(entity as Hero).state = Hero.DASH;
			entity.physics.vX = speed * (entity.body.left ? -1 : 1);
			
			return super.fire();
		}
		
		override public function endCooldown():void {
			clearTimeout(cooldown);
			(entity as Hero).state = Hero.STAND;
		}
		
		public function stopDash():void {
			cooldown = 0;
		}
	}
}