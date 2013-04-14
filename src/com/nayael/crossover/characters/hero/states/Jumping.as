package com.nayael.crossover.characters.hero.states
{
	import com.entity.engine.Entity;
	import com.entity.engine.fsm.IState;
	import flash.display.MovieClip;
	
	public class Jumping implements IState
	{
		private var entity:Entity;
		private var animation:MovieClip;
		
		public function Jumping(entity:Entity) {
			this.entity = entity;
			animation = new MegaboyJump();
		}
		
		public function enter():void {
			entity.view.sprite.addChild( animation );
		}
		
		public function exit():void {
			entity.view.sprite.removeChild( animation );
		}
	
	}

}