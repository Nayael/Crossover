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
			var onWallBefore:Boolean = entity.body.onWall;
			entity.body.onWall = super._xCollision(map);
			if (!entity.body.onFloor && entity.body.onWall && vY > 0) {
				(entity as Hero).state = Hero.WALL;
				entity.body.left = !entity.body.left;
			} else if (entity.body.onFloor) {
				entity.body.onWall = false;
			}
			return entity.body.onWall;
		}
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}