package com.entity.engine
{
	
	public class Weapon
	{
        public var entity:Entity;
        public var ammo:int = 99;
		
		public function Weapon(entity:Entity)
		{
			this.entity = entity;
		}
		
		public function fire():void
		{
			if (ammo >= 0) {
				ammo--;
			}			
		}
	
	}

}