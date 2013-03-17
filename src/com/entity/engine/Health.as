package com.entity.engine 
{
	import com.entity.engine.events.EntityEvent;
	import com.entity.engine.events.EntityEventType;
	import flash.events.Event;
	
	public class Health 
	{
		public var entity:Entity;
		public var hp:int;
		
		public function Health(entity:Entity) 
		{
			this.entity = entity;
		}
		
		public function damage(entity:Entity):void
		{			
			if (hp>0) {
				entity.onHit();
			}else {
				entity.onDie();
			}
		}		
	}

}