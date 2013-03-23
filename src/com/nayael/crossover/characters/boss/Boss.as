package com.nayael.crossover.characters.boss 
{
	import com.entity.engine.utils.errors.AbstractClassError;
	import com.nayael.crossover.characters.Character;
	
	/**
	 * Abstract class for boss enemies in the game
	 * @author Nayael
	 */
	public class Boss extends Character
	{
	////////////////////////
	// PROPERTIES
	//
		
	
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
		
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}