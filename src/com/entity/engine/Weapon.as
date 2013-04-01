package com.entity.engine
{
	import com.entity.engine.utils.errors.AbstractClassError;
	import flash.utils.setTimeout;
	
	public class Weapon
	{
        public var entity:Entity;
		public var x:Number;	// The weapon can have a defined coordinate to throw bullet from that point
		public var y:Number;	// The weapon can have a defined coordinate to throw bullet from that point
        public var ammo:int = 99;
		public var cooldownTime:int = 300;
		public var cooldown:uint = 0;
		
		public function Weapon(entity:Entity) {
			if (Object(this).constructor === Weapon) {
				throw new AbstractClassError(this);
			}
			this.entity = entity;
		}
		
		public function fire():Boolean {
			if (cooldown != 0) {
				return false;
			}
			
			// Only shoot if the cooldown is finished
			if (ammo >= 0) {
				ammo--;
			}
			cooldown = setTimeout(function():void {
				cooldown = 0;
			}, cooldownTime);
			return true;
		}
	}
}