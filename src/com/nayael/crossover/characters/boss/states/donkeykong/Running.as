package com.nayael.crossover.characters.boss.states.donkeykong
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
			animation = new DonkeyKongRun();
		}
		
		public function enter():void {
			entity.view.sprite.addChild( animation );
		}
		
		public function exit():void {
			entity.view.sprite.removeChild( animation );
		}
	}
}