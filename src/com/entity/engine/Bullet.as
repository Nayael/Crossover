package com.entity.engine 
{
	import com.entity.engine.utils.errors.AbstractClassError;
	/**
	 * Abstract class for bullets
	 * @author Nayael
	 */
	public class Bullet extends Entity
	{
		public var myParent:Entity;
		public var ttl:int = 25;
		public var strength:Number = 1.;
		
		protected var pool:Array;
		
		public function Bullet() {
			if (Object(this).constructor === Bullet) {
				throw new AbstractClassError(this);
			}
			body = new Body(this);
			physics = new Physics(this);
			physics.useGravity = false;
			physics.useMapCollisions = false;
			view = new View(this);
		}
		
		public function init(parent:Entity):void {
			myParent = parent;
			ttl = 25;
			physics.vX = 0;
			physics.vY = 0;
		}
		
		override public function update():void {
			super.update();
			ttl--;
			for each (var target:Entity in targets) {
				if (body.collide(target) && (target != this.myParent)) {
					target.onHit(strength, Object(myParent.weapon).constructor);
					destroy();
					return;
				}
			}
			
			// We manually destroy the bullet if the ttl is over
			if (ttl <= 0) {
				destroy();
			}
		}
		
		override public function destroy():void {
			body.x = 0;
			body.y = 0;
			pool.push(this);
			super.destroy();
		}
	}
}