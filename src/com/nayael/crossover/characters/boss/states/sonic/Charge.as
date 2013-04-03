package com.nayael.crossover.characters.boss.states.sonic
{
	import com.entity.engine.Entity;
	import com.entity.engine.fsm.IState;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class Charge implements IState
	{
		private var entity:Entity;
		private var animation:MovieClip;
		
		public function Charge(entity:Entity) {
			this.entity = entity;
			animation = new SonicCharge();
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