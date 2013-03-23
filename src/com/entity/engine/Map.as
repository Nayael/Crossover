package com.entity.engine 
{
	/**
	 * A class to build 2D maps
	 * @author Nayael
	 */
	public class Map
	{
	////////////////////////
	// PROPERTIES
	//
		
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function Map() { }
	
	////////////////////////
	// METHODS
	//
		static public function build(tilemap:Array):Vector.<Vector.<int>> {
			var map:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
			for each (var item:* in tilemap) {
				if (!(item is Array)) {
					throw new Error('A map can only be build with a 2D array');
				}
				map.push(Vector.<int>(item));
			}
			map.fixed = true;
			return map;
		}
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}