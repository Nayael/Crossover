package com.entity.engine 
{
	import com.entity.engine.events.EntityEvent;
	import com.entity.engine.events.EntityEventType;
	import flash.events.Event;
	
	public class Health 
	{
		public var entity:Entity;
		private var _hp:int;
		
		public function Health(entity:Entity) {
			this.entity = entity;
		}
		
		public function damage(value:int):void {
			hp -= value;
		}		
		
		public function get hp():int {
			return _hp;
		}
		
		public function set hp(value:int):void {
			_hp = value;
			if (_hp > 0) {
				entity.onHit();
			} else {
				entity.onDie();
			}
		}
	}

}