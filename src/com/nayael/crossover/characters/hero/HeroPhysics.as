package com.nayael.crossover.characters.hero 
{
	import com.entity.engine.Entity;
	import com.entity.engine.Map;
	import com.entity.engine.Physics;
	
	/**
	 * Physics for the hero
	 * @author Nayael
	 */
	public class HeroPhysics extends Physics
	{
	////////////////////////
	// PROPERTIES
	//
		private var _onWall:Boolean = false;
		public var wallJumping:Boolean = false;
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function HeroPhysics(entity:Entity) {
			super(entity);
		}
	
	////////////////////////
	// METHODS
	//
		override protected function _xCollision(map:Map):Boolean {
			var onWallBefore:Boolean = _onWall;
			_onWall = super._xCollision(map);
			return _onWall;
		}
	
	////////////////////////
	// GETTERS & SETTERS
	//
		public function get onWall():Boolean {
			return _onWall;
		}
	}
}