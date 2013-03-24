package com.entity.engine
{
	import com.entity.engine.events.*;
	
	public class Entity implements IEntity
	{
		private var _body:Body;
		private var _physics:Physics;
		private var _health:Health;
		private var _weapon:Weapon;
		private var _view:View;
		protected var _game:Game;
		
		private var _targets:Vector.<Entity>;
		private var _group:Vector.<Entity>;
		
		public function Entity() { 
			
		}
		
		public function destroy():void {
			EventBroker.broadcast( new EntityEvent( EntityEventType.DESTROYED, this) );
			if (group) {
				var idx:int = group.indexOf(this);
				if (idx > -1) {
					group.splice(idx, 1);
				}
			}
		}
		
		public function update():void {
			if (physics) {
				physics.update(_game.map);
			}
		}
		
		public function draw():void {
			if (view) {
				view.draw();
			}
		}
		
		public function get body():Body {
			return _body;
		}
		
		public function set body(value:Body):void {
			_body = value;
		}
		
		public function get physics():Physics {
			return _physics;
		}
		
		public function set physics(value:Physics):void {
			_physics = value;
		}
		
		public function get health():Health {
			return _health;
		}
		
		public function set health(value:Health):void {
			_health = value;
		}
		
		// simplification, car pour le coup le composant health n'est plus optionnel.
		public function onHit():void {
			// --
		}
		
		public function onDie():void {
			// --
		}
		
		public function get weapon():Weapon  {
			return _weapon;
		}
		
		public function set weapon(value:Weapon):void  {
			_weapon = value;
		}
		
		public function get view():View  {
			return _view;
		}
		
		public function set view(value:View):void  {
			_view = value;
		}		

		public function get targets():Vector.<Entity>  {
			return _targets;
		}
		
		public function set targets(value:Vector.<Entity>):void  {
			_targets = value;
		}
		
		public function get group():Vector.<Entity>  {
			return _group;
		}
		
		public function set group(value:Vector.<Entity>):void  {
			_group = value;
		}
		
		public function set game(value:Game):void {
			_game = value;
		}

	}
}