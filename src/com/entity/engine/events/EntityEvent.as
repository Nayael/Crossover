package com.entity.engine.events
{
	import com.entity.engine.Entity;
	import flash.events.Event;
	
	public class EntityEvent extends Event 
	{
		public var entity:Entity;
		
		public function EntityEvent(name:String, entity:Entity) 
		{
			super( name );
			this.entity = entity;
		}
		
	}

}