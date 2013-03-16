package engine 
{
	import engine.events.EntityEvent;
	import engine.events.EntityEventType;
	import flash.events.Event;
	
	public class Health 
	{
		public var entity:Entity;
		public var hp:int;
		
		public function Health(entity:Entity) 
		{
			this.entity = entity;
		}
		
		public function damage(value:int):void
		{
			hp -= value;
            if (hp == 0) {
				entity.destroy();
            }
		}
	}
}