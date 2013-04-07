package com.entity.engine.events
{
	import com.entity.engine.Entity;
	import flash.events.Event;
	
	public class EntityEvent extends Event 
	{
		public var entity:Entity;
		
		public function EntityEvent(type:String, entity:Entity, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.entity = entity;
		}
		
		public override function clone ():Event {
			return new EntityEvent ( type, entity, bubbles, cancelable );
		}
		
		public override function toString ():String {
			return '[EntityEvent type="'+ type +'" bubbles=' + bubbles + ' cancelable=' + cancelable + ']';
		}
	}

}