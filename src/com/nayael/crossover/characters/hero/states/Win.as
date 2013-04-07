package com.nayael.crossover.characters.hero.states
{
	import com.entity.engine.Entity;
	import com.entity.engine.EventBroker;
	import com.entity.engine.fsm.IState;
	import com.nayael.crossover.events.LevelEvent;
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	
	public class Win implements IState
	{
		private var entity:Entity;
		private var animation:MovieClip;
		
		public function Win(entity:Entity) {
			this.entity = entity;
			animation = new MegaboyStand();
		}
		
		public function enter():void {
			entity.view.sprite.addChild( animation );
			setTimeout(function():void {
				EventBroker.broadcast(new LevelEvent(LevelEvent.FINISHED, true));
			}, 5000);
		}
		
		public function exit():void {
			entity.view.sprite.removeChild( animation );
		}
	}
}