package com.entity.engine
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class View
	{
		public var entity:Entity;
		public var sprite:Sprite;
		public var scale:Number = 1;
		public var alpha:Number = 1;
		
		public function View(entity:Entity) {
			this.entity = entity;
			sprite = new Sprite();
		}
		
		public function draw():void {
			sprite.x = entity.body.x;
			sprite.y = entity.body.y;
			sprite.alpha = alpha;
			sprite.scaleX = sprite.scaleY = scale;
			
			if (entity.physics.vX < 0) {
				sprite.scaleX *= -1;
			} else if (entity.physics.vX > 0) {
				sprite.scaleX *= 1;
			} else {
				sprite.scaleX *= entity.body.left ? -1 : 1;
			}
		}
	}
}