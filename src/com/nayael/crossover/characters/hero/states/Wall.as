package com.nayael.crossover.characters.hero.states
{
	import com.entity.engine.Entity;
	import com.entity.engine.fsm.IState;
	import flash.display.MovieClip;
	
	public class Wall implements IState
	{
		private var entity:Entity;
		private var animation:MovieClip;
		
		public function Wall(entity:Entity) {
			this.entity = entity;
			animation = new MegaboyWall();
		}
		
		public function enter():void {
			entity.view.sprite.addChild( animation );
		}
		
		public function exit():void {
			entity.view.sprite.removeChild( animation );
		}
	}
}