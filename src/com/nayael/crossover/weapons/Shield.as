package com.nayael.crossover.weapons 
{
	import com.entity.engine.Entity;
	import com.entity.engine.Weapon;
	
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
		
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}