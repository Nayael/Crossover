package com.nayael.crossover.arenas 
{
	import com.entity.engine.Map;
	import com.nayael.crossover.characters.boss.Boss;
	
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
		protected var _boss:Boss;

	////////////////////////
	// CONSTRUCTOR
	//
		public function Arena(tilemap:Array) {
			obstacles = Vector.<int>([1, 2, 3, 4, 5, 6, 7, 8]);
			super(TILE_SIZE, tilemap);
		}
	
	////////////////////////
	// METHODS
	//
		
	
	////////////////////////
	// GETTERS & SETTERS
	//
		public function get boss():Boss {
			return _boss;
		}
	}
}