package com.nayael.crossover.arenas 
{
	import com.entity.engine.Map;
	
	/**
	 * Abstract class for representing arenas
	 * @author Nayael
	 */
	public class Arena extends Map
	{
	////////////////////////
	// PROPERTIES
	//
		private static const TILE_SIZE:int = 40;
	////////////////////////
	// CONSTRUCTOR
	//
		public function Arena(tilemap:Array) {
			super(TILE_SIZE, tilemap);
		}
	
	////////////////////////
	// METHODS
	//
		
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}