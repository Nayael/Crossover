package com.entity.engine
{
	
	public class Body
	{
		public var entity:Entity;
		public var x:Number = .0;
		public var y:Number = .0;
		public var angle:Number = .0;
		public var radius:Number = 10.0;
		
		private var _left:Boolean;
		private var _right:Boolean;
		
		public function Body(entity:Entity) {
			this.entity = entity;
		}
		
		public function collide(otherEntity:Entity):Boolean {
			var dx:Number;
			var dy:Number;
			
			dx = x - otherEntity.body.x;
			dy = y - otherEntity.body.y;
			
			return Math.sqrt((dx * dx) + (dy * dy)) <= (radius + otherEntity.body.radius);
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