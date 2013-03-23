package com.nayael.crossover.characters 
{
	import com.entity.engine.Entity;
	
	/**
	 * Abstract character class
	 * @author Nayael
	 */
	public class Character extends Entity
	{
	////////////////////////
	// PROPERTIES
	//
		protected var _hSpeed:int = 8;
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function Character() {
			if (Object(this).constructor === Character) {
				throw new Error('Character is an abstract class');
			}
		}
	
	////////////////////////
	// METHODS
	//
		public function turnLeft():void {
			physics.vX = -_hSpeed;
			body.left = true;
		}
		
		public function turnRight():void {
			physics.vX = _hSpeed;
			body.right = true;
		}
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}