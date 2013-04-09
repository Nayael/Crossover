package com.entity.engine
{
	import com.entity.engine.utils.errors.AbstractClassError;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class Weapon
	{
        private var _ammo:int;
		
        public var entity:Entity;
		public var x:Number;	// The weapon can have a defined coordinate to throw bullet from that point
		public var y:Number;	// The weapon can have a defined coordinate to throw bullet from that point
		public var color:String;	// The color to display ammo in the HUD
        public var maxAmmo:int;
		public var usesAmmo:Boolean = true;
		public var cooldownTime:int = 300;
		public var cooldown:uint = 0;
		
		public function Weapon(entity:Entity) {
			if (Object(this).constructor === Weapon) {
				throw new AbstractClassError(this);
			}
			this.entity = entity;
			_ammo = maxAmmo;
		}
		
		public function fire():Boolean {
			if (cooldown != 0) {
				return false;
			}
			
			// Only shoot if the cooldown is finished
			if (usesAmmo && _ammo >= 0) {
				_ammo--;
			}
			cooldown = setTimeout(endCooldown, cooldownTime);
			return true;
		}
		
		public function endCooldown():void {
			clearTimeout(cooldown);
			cooldown = 0;
		}
		
		public function get ammo():int {
			return _ammo;
		}
		
		public function set ammo(value:int):void {
			if (value > maxAmmo) {
				value = maxAmmo
			}
			_ammo = value;
		}
	}
}