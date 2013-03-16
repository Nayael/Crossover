package engine
{
	import flash.display.Sprite;
	
	public class View
	{
		public var entity:Entity;
		public var sprite:Sprite;
		public var scale:Number = 1;
		public var alpha:Number = 1;
		
		public function View(entity:Entity)
		{
			this.entity = entity;
		}
		
		public function draw():void
		{
			sprite.x = entity.body.x;
			sprite.y = entity.body.y;
			sprite.rotation = entity.body.angle * (180 / Math.PI);
			sprite.alpha = alpha;
			sprite.scaleX = sprite.scaleY = scale;
		}
	}
}