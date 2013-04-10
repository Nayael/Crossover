package com.nayael.crossover.weapons 
{
	import com.entity.engine.Entity;
	import com.entity.engine.Weapon;
	
	/**
	 * ...
	 * @author Nayael
	 */
	public class BarrelGun extends Weapon
	{
	////////////////////////
	// PROPERTIES
	//
		
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function BarrelGun(entity:Entity) {
			maxAmmo = 25;
			super( entity );
			cooldownTime = 500;
			color = 'Red';
		}
	
	////////////////////////
	// METHODS
	//
		
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}