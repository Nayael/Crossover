package com.nayael.crossover.characters.boss.states.link
{
	import com.entity.engine.Entity;
	import com.entity.engine.fsm.IState;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class Attack implements IState
	{
		private var entity:Entity;
		private var animation:MovieClip;
		
		public function Attack(entity:Entity) {
			this.entity = entity;
			animation = new LinkStand();
		}
		
		public function enter():void {
			entity.view.sprite.addChild( animation );
		}
		
		public function exit():void {
			entity.view.sprite.removeChild( animation );
		}
	
	}

}