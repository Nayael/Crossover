package com.nayael.crossover.characters.hero.states
{
	import com.entity.engine.Entity;
	import com.entity.engine.fsm.IState;
	import flash.display.MovieClip;
	
	public class ShieldState implements IState
	{
		private var entity:Entity;
		private var animation:MovieClip;
		
		public function ShieldState(entity:Entity) {
			this.entity = entity;
			animation = new MegaboyShield();
		}
		
		public function enter():void {
			if (entity.body.onFloor) {
				entity.physics.vX = 0;
			}
			entity.view.sprite.addChild( animation );
		}
		
		public function exit():void {
			entity.view.sprite.removeChild( animation );
		}
	}
}