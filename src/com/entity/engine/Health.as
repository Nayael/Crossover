package com.entity.engine 
{
	import com.entity.engine.events.EntityEvent;
	import com.entity.engine.events.EntityEventType;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Health 
	{
		public var entity:Entity;
		public var maxHp:int = 100;
		public var minHp:int = 0;
		public var vulnerable:Boolean = true;
		private var _hp:int;
		private var _vulnerabilityTimer:Timer;
		
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
		
		public function setInvulnerable(delay:int, callback:Function = null):void {
			vulnerable = false;
			_vulnerabilityTimer = new Timer(delay, 1);
			_vulnerabilityTimer.addEventListener(TimerEvent.TIMER_COMPLETE, _setVulnerable);
			_vulnerabilityTimer.start();
			function _setVulnerable(e:TimerEvent):void {
				_vulnerabilityTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, _setVulnerable);
				vulnerable = true;
				if (callback != null) {
					callback.call();
				}
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