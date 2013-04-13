package com.nayael.crossover.weapons 
{
	import com.entity.engine.Entity;
	import com.entity.engine.Weapon;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Nayael
	 */
	public class Shield extends Weapon
	{
	////////////////////////
	// PROPERTIES
	//
		
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function Shield(entity:Entity) {
			maxAmmo = 25;
			super( entity );
			cooldownTime = 0;
			color = 'Yellow';
		}
	
	////////////////////////
	// METHODS
	//
		override public function fire():Boolean {
			return true;
		}
		
		// When the shield is hit (by a strong weapon), it cannot be used for a moment
		public function onHit():void {
			cooldown = setTimeout(endCooldown, cooldownTime);
		}
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}