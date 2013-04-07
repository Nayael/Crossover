package com.entity.engine 
{
	import com.entity.engine.utils.Vector2;
	import com.nayael.crossover.characters.hero.Hero;
	public class Physics 
	{
		public static var G:Number = 9.81;
		
        public var entity:Entity;
        public var drag:Number = 1.;	// Friction
		public var mass:Number = .0;
        public var vX:Number = .0;		// X-axis speed
        public var vY:Number = .0;		// Y-axis speed
		public var a:Vector2 = new Vector2();	// Acceleration
		
		private var delta:Vector2 = new Vector2();
		
		public function Physics(entity:Entity) {
			this.entity = entity;
		}
		
		public function update(map:Map):void {
			this.applyForces();
			this.a.x /= this.mass;
			this.a.y /= this.mass;
			
			// We restrain the entity inside the scene
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
			
			var vY0:Number = this.vY;
			var vX0:Number = this.vX;
			this.vX += this.a.x * Game.dt;
			this.vY += this.a.y * Game.dt;
			
			this.vX *= drag;
			this.vY *= drag;
			
			delta.x = ( ( (this.vX + vX0) / 2 ) * Game.dt ) | 0;
			delta.y = ( ( (this.vY + vY0) / 2 ) * Game.dt ) | 0;
			
			// Collision tests
			//entity.body.onFloor = false;
			if (entity.body.hitbox && _xCollision(map)) {
				delta.x = 0;
				vX = 0;
			}
			if (entity.body.hitbox && _yCollision(map)) {
				//trace('collision');
				delta.y = 0;
				vY = 0;
				//entity.body.onFloor = true;
			}
			//else trace('nope');
			
			trace(delta.y);
			entity.body.x += delta.x;
			entity.body.y += delta.y;
		}
		
		/**
		 * Looks for a collision for the hitbox on the X-Axis
		 * @param	map
		 */
		private function _xCollision(map:Map):Boolean {
			var hitboxX:Number = entity.body.hitbox.x * entity.view.scale,
				hitboxY:Number = entity.body.hitbox.y * entity.view.scale,
				hitboxWidth:Number = entity.body.hitbox.width * entity.view.scale,
				hitboxHeight:Number = entity.body.hitbox.height * entity.view.scale,
				hitboxEdge:Number = (hitboxX + hitboxWidth) * (entity.body.left ? -1 : 1 ),
				x:int = ( entity.body.x + delta.x + hitboxEdge ) / map.TS,
				yMin:int = ( (entity.body.y + hitboxY) / map.TS),
				yMax:int = ( (entity.body.y + hitboxY + hitboxHeight) / map.TS),
				newX:int;
			
			// Parsing the rows containing the entity
			for (var i:int = yMin; i <= yMax; i++) {
				// If one of the tiles is an obstacle
				if (map.obstacles.indexOf(map.tilemap[i][x]) != -1) {
					newX = x * map.TS + (entity.body.left ? map.TS : 0);
					entity.body.x = newX - hitboxEdge - 1;
					return true;
				}
			}
			return false;
		}
		
		private function _yCollision(map:Map):Boolean {
			var hitboxX:Number = entity.body.hitbox.x * entity.view.scale,
				hitboxY:Number = entity.body.hitbox.y * entity.view.scale,
				hitboxWidth:Number = entity.body.hitbox.width * entity.view.scale,
				hitboxHeight:Number = entity.body.hitbox.height * entity.view.scale,
				y:int = ( entity.body.y + delta.y + (vY < 0 ? hitboxY : (hitboxY + hitboxHeight) ) ) / map.TS,
				xMin:int = ( (entity.body.x + hitboxX) / map.TS),
				xMax:int = ( (entity.body.x + hitboxX + hitboxWidth) / map.TS);
			// Parsing the columns containing the entity
			for (var j:int = xMin; j <= xMax; j++) {
				// If one of the tiles is an obstacle
				if (map.obstacles.indexOf(map.tilemap[y][j]) != -1) {
					entity.body.y = y * map.TS + ((map.TS - hitboxY) * (vY < 0 ? 1 : 0) );
					//if (vY > 0) {
						//entity.body.onFloor = true;
					//}
					return true;
				}
			}
			return false;
		}
		
		public function applyForces():void {
			this.a.y = 0;
			// Gravity first
			this.a.y += G * this.mass * Game.dt;
			
			//for (var i = 0, F, distance, dot; i < dots.length; i++) {
				//dot = dots[i];
				//if (dot == this) {
					//continue;
				//}
				//distance = this.distance(dot);
				//F = this.mass * dot.mass * G / Math.pow( distance, 2 );
				//this.a.x += F * (dot.x - this.x) / (this.mass * distance);
				//this.a.y += F * (dot.y - this.y) / (this.mass * distance);
			//}
		}
		
		public function addForce(force:Vector2):void {
			this.a.x += force.x;
			this.a.y += force.y;
		}
		
		public function impulse(force:Vector2):void {
            vX += Math.sin(-entity.body.angle) * pow;
            vY += Math.cos(-entity.body.angle) * pow;
		}
	}
}