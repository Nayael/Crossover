package com.entity.engine 
{
	import com.entity.engine.events.EntityEvent;
	import com.entity.engine.events.EntityEventType;
	import flash.events.Event;
	
	public class Health 
	{
		public var entity:Entity;
		public var maxHp:int = 100;
		public var minHp:int = 0;
		public var vulnerable:Boolean = true;
		private var _hp:int;
		
		public function Health(entity:Entity) {
			this.entity = entity;
		}
		
		public function damage(value:int):void {
			if (!vulnerable || value > maxHp) {
				return;
			}
			var baseHp:int = _hp;
			hp -= value;
			if (_hp > minHp && baseHp > _hp) {
				entity.onHurt();
			} else if (_hp <= minHp) {
				entity.onDie();
			}
		}
		
		public function get hp():int {
			return _hp;
		}
		
		public function set hp(value:int):void {
			_hp = value;
		}
	}

}