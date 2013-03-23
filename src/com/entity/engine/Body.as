package com.entity.engine
{
	import flash.display.MovieClip;
	
	public class Body
	{
		public var entity:Entity;
		public var x:Number = .0;
		public var y:Number = .0;
		public var angle:Number = .0;
		public var hitbox:MovieClip;
		
		private var _left:Boolean;
		private var _right:Boolean;
		
		public function Body(entity:Entity) {
			this.entity = entity;
		}
		
		public function collide(target:Entity):Boolean {
			if (!hitbox) {
				return false;
			}
			var leftThis:Number     = hitbox.x,
				rightThis:Number    = hitbox.x + hitbox.width,
				topThis:Number      = hitbox.y,
				bottomThis:Number   = hitbox.y + hitbox.height,
				leftTarget:Number   = target.body.hitbox.x,
				rightTarget:Number  = target.body.hitbox.x + target.body.hitbox.width,
				topTarget:Number    = target.body.hitbox.y,
				bottomTarget:Number = target.body.hitbox.y + target.body.hitbox.height;
				
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