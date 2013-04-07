package com.entity.engine
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Body
	{
		public var entity:Entity;
		public var x:Number = .0;
		public var y:Number = .0;
		public var angle:Number = .0;
		public var hitbox:MovieClip;
		public var onFloor:Boolean = false;
		public var onWall:Boolean = false;
		
		private var _left:Boolean;
		private var _right:Boolean;
		
		public function Body(entity:Entity) {
			this.entity = entity;
		}
		
		/**
		 * Tests if the entity collides with another entity
		 * @param	target	The entity to test for collision with
		 * @return True if there is a collision, False otherwise
		 */
		public function collide(target:Entity):Boolean {
			if (!hitbox || !target.body.hitbox) {
				return false;
			}
			var hitboxPos:Point = entity.view.sprite.localToGlobal(new Point(hitbox.x, hitbox.y)),
				targetHitboxPos:Point = target.view.sprite.localToGlobal(new Point(target.body.hitbox.x, target.body.hitbox.y));
			var leftThis:Number     = hitboxPos.x,
				rightThis:Number    = hitboxPos.x + hitbox.width,
				topThis:Number      = hitboxPos.y,
				bottomThis:Number   = hitboxPos.y + hitbox.height,
				leftTarget:Number   = targetHitboxPos.x,
				rightTarget:Number  = targetHitboxPos.x + target.body.hitbox.width,
				topTarget:Number    = targetHitboxPos.y,
				bottomTarget:Number = targetHitboxPos.y + target.body.hitbox.height;
			trace(leftThis, rightThis, topThis, bottomThis);
			trace(leftTarget, rightTarget, topTarget, bottomTarget);
			return !(leftThis > rightTarget || leftTarget > rightThis || topThis > bottomTarget || topTarget > bottomThis);
		}
		
		public function get left():Boolean {
			return _left;
		}
		
		public function set left(value:Boolean):void {
			_left = value;
			_right = !_left;
		}
		
		public function get right():Boolean {
			return _right;
		}
		
		public function set right(value:Boolean):void {
			_right = value;
			_left = !_right;
		}
	}
}