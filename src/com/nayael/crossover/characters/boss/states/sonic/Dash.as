package com.nayael.crossover.characters.boss.states.sonic
{
	import com.entity.engine.Entity;
	import com.entity.engine.fsm.IState;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class Dash implements IState
	{
		private var entity:Entity;
		private var animation:MovieClip;
		
		public function Dash(entity:Entity) {
			this.entity = entity;
			animation = new SonicDash();
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