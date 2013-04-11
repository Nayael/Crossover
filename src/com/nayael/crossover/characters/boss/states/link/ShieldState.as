package com.nayael.crossover.characters.boss.states.link
{
	import com.entity.engine.Entity;
	import com.entity.engine.fsm.IState;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class ShieldState implements IState
	{
		private var entity:Entity;
		private var animation:MovieClip;
		
		public function ShieldState(entity:Entity) {
			this.entity = entity;
			animation = new LinkShield();
		}
		
		public function enter():void {
			entity.view.sprite.addChild( animation );
		}
		
		public function exit():void {
			entity.view.sprite.removeChild( animation );
		}
	
	}

}