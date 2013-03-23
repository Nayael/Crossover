package com.nayael.crossover.arenas 
{
	import com.nayael.crossover.errors.AbstractClassError;
	
	/**
	 * Abstract class for representing arenas
	 * @author Nayael
	 */
	public class Arena
	{
	////////////////////////
	// PROPERTIES
	//
		protected var _map:Vector.<Vector.<int>>;	// The game's tilemap
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function Arena() {
			if (Object(this).constructor === Arena) {
				throw new AbstractClassError(this);
			}
		}
	
	////////////////////////
	// METHODS
	//
		
	
	////////////////////////
	// GETTERS & SETTERS
	//
		public function get map():Vector.<Vector.<int>> {
			return _map;
		}
	}
}