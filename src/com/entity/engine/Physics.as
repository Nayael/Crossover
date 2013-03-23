package com.entity.engine 
{
	public class Physics 
	{
        public var entity:Entity;
        public var drag:Number = 1.;	// Friction	
        public var vX:Number = .0;
        public var vY:Number = .0;
		
		public function Physics(entity:Entity) 
		{
			this.entity = entity;
		}
		
		public function update():void
		{
			entity.body.x += vX;
			entity.body.y += vY;
			
			vX *= drag;
			vY *= drag;
			
			// First, we restrain the entity inside the scene
			if (entity.body.x > E.WIDTH - (entity.view.sprite.width >> 1)) {
				entity.body.x = E.WIDTH - (entity.view.sprite.width >> 1);
			}
			if (entity.body.x < (entity.view.sprite.width >> 1)) {
				entity.body.x = (entity.view.sprite.width >> 1);
			}
			if (entity.body.y > E.HEIGHT + (entity.view.sprite.height >> 1)) {
				entity.body.y = E.HEIGHT + (entity.view.sprite.height >> 1);
			}
			if (entity.body.y < (entity.view.sprite.height >> 1)) {
				entity.body.y = (entity.view.sprite.height >> 1);
			}
			
			
		}
		
		public function impulse(pow:Number):void {
            vX += Math.sin(-entity.body.angle) * pow;
            vY += Math.cos(-entity.body.angle) * pow;
		}
	}
}