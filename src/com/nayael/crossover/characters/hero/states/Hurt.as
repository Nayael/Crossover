package com.nayael.crossover.characters.hero.states
{
	import com.entity.engine.Entity;
	import com.entity.engine.fsm.IState;
	import flash.display.MovieClip;
	
	public class Hurt implements IState
	{
		private var entity:Entity;
		private var animation:MovieClip;
		
		public function Hurt(entity:Entity) {
			this.entity = entity;
			animation = new MegaboyHurt();
		}
		
		public function enter():void {
			entity.view.sprite.addChild( animation );
			animation.gotoAndPlay(1);
		}
		
		public function exit():void {
			entity.view.sprite.removeChild( animation );
		}
	}
}