package engine
{
	
	public class Body
	{
		public var entity:Entity;
		public var x:Number = .0;
		public var y:Number = .0;
		public var scaleX:Number = .0;
		public var scaleY:Number = .0;
		public var angle:Number = .0;
		public var radius:Number = 10.0;
		
		public function Body(entity:Entity)
		{
			this.entity = entity;
		}
		
		public function collide(otherEntity:Entity):Boolean
		{
			var dx:Number;
			var dy:Number;
			
			dx = x - otherEntity.body.x;
			dy = y - otherEntity.body.y;
			
			return Math.sqrt((dx * dx) + (dy * dy)) <= (radius + otherEntity.body.radius);
		}
		
	}

}