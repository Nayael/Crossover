package com.nayael.crossover.weapons 
{
	import com.entity.engine.Entity;
	import com.entity.engine.Weapon;
	
	/**
	 * ...
	 * @author Nayael
	 */
	public class BarrelThrower extends Weapon
	{
	////////////////////////
	// PROPERTIES
	//
		
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function BarrelThrower(entity:Entity) {
			maxAmmo = 25;
			super( entity );
			cooldownTime = 500;
			color = 'Red';
		}
	
	////////////////////////
	// METHODS
	//
		override public function fire():Boolean {
			return super.fire();
		}
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}