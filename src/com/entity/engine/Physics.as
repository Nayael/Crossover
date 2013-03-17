package com.entity.engine 
{
	public class Physics 
	{
        public var entity:Entity;
        public var drag:Number = 1.; // frottement null
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
			
			// monde torique, toutes les entités y sont soumises
			if (entity.body.x > 850) entity.body.x -= 900;
			if (entity.body.x < -50) entity.body.x += 900;
			if (entity.body.y > 650) entity.body.y -= 700;
			if (entity.body.y < -50) entity.body.y += 700;			
		}
		
		public function impulse( pow:Number ):void
		{
            vX += Math.sin(-entity.body.angle) * pow;
            vY += Math.cos(-entity.body.angle) * pow;			
		}
		
	}

}