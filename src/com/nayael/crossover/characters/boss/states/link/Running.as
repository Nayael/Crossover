package com.nayael.crossover.characters.boss.states.link
{
	import com.entity.engine.Entity;
	import com.entity.engine.fsm.IState;
	import flash.display.MovieClip;
	
	public class Running implements IState
	{
		private var entity:Entity;
		private var animation:MovieClip;
		
		public function Running(entity:Entity) {
			this.entity = entity;
			animation = new LinkRun();
		}
		
		public function enter():void {
			animation.gotoAndPlay(1);
			entity.view.sprite.addChild( animation );
		}
		
		public function exit():void {
			entity.view.sprite.removeChild( animation );
		}
	}
}