package com.entity.engine 
{
	import com.nayael.crossover.characters.hero.Hero;
	public class Physics 
	{
        public var entity:Entity;
        public var drag:Number = 1.;	// Friction
        public var mass:Number = 1.;
        public var vX:Number = .0;		// X-axis speed
        public var vY:Number = .0;		// Y-axis speed
		public var useGravity:Boolean = true;
		public var useMapCollisions:Boolean = true;	// Shall the entity collide with the map elements ?
		
		public function Physics(entity:Entity) {
			this.entity = entity;
		}
		
		public function update(map:Map):void {
			// First, we restrain the entity inside the scene
			if (entity.body.x > E.WIDTH - (entity.view.sprite.width >> 1)) {
				entity.body.x = E.WIDTH - (entity.view.sprite.width >> 1);
			}
			if (entity.body.x < (entity.view.sprite.width >> 1)) {
				entity.body.x = (entity.view.sprite.width >> 1);
			}
			if (entity.body.y > E.HEIGHT) {
				entity.body.y = E.HEIGHT;
			}
			if (entity.body.y < entity.view.sprite.height) {
				entity.body.y = entity.view.sprite.height;
			}
			
			if (!useMapCollisions || entity.body.hitbox && !_xCollision(map)) {	// If the body doesn't collide with an obstacle, move it
				entity.body.x += vX;
			}
			if (entity.body.hitbox && useGravity && !_yCollision(map)) {
				entity.body.y += vY;
				entity.body.onFloor = false;
			}
			
			vX *= drag;
			vY *= drag;
		}
		
		/**
		 * Looks for a collision for the hitbox on the X-Axis
		 * @param	map
		 */
		protected function _xCollision(map:Map):Boolean {
			var hitboxX:Number = entity.body.hitbox.x * entity.view.scale,
				hitboxY:Number = entity.body.hitbox.y * entity.view.scale,
				hitboxWidth:Number = entity.body.hitbox.width * entity.view.scale,
				hitboxHeight:Number = entity.body.hitbox.height * entity.view.scale,
				hitboxEdge:Number = (hitboxX + hitboxWidth) * (vX < 0 ? -1 : 1 ),
				x:int = ( entity.body.x + vX + hitboxEdge ) / map.TS,
				yMin:int = ( (entity.body.y + hitboxY) / map.TS),
				yMax:int = ( (entity.body.y + hitboxY + hitboxHeight) / map.TS),
				newX:int;
			
			// Parsing the rows containing the entity
			for (var i:int = yMin; i <= yMax; i++) {
				// If one of the tiles is an obstacle
				if (map.obstacles.indexOf(map.tilemap[i][x]) != -1) {
					newX = x * map.TS + (vX < 0 ? map.TS : 0);
					entity.body.x = newX - hitboxEdge - 1;
					return true;
				}
			}
			return false;
		}
		
		protected function _yCollision(map:Map):Boolean {
			var hitboxX:Number = entity.body.hitbox.x * entity.view.scale,
				hitboxY:Number = entity.body.hitbox.y * entity.view.scale,
				hitboxWidth:Number = entity.body.hitbox.width * entity.view.scale,
				hitboxHeight:Number = entity.body.hitbox.height * entity.view.scale,
				y:int = ( entity.body.y + vY + hitboxY + (vY < 0 ? 0 : hitboxHeight ) ) / map.TS,
				xMin:int = ( (entity.body.x + hitboxX) / map.TS),
				xMax:int = ( (entity.body.x + hitboxX + hitboxWidth) / map.TS);
			// Parsing the columns containing the entity
			for (var j:int = xMin; j <= xMax; j++) {
				// If one of the tiles is an obstacle
				if (map.obstacles.indexOf(map.tilemap[y][j]) != -1) {
					entity.body.y = y * map.TS + ((map.TS - hitboxY) * (vY < 0 ? 1 : 0) );
					if (vY > 0) {
						entity.body.onFloor = true;
					} else {
						vY = 0;
					}
					return true;
				}
			}
			return false;
		}
		
		public function impulse(pow:Number):void {
            vX += Math.sin(-entity.body.angle) * pow;
            vY += Math.cos(-entity.body.angle) * pow;
		}
	}
}