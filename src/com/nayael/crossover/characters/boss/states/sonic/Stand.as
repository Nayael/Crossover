package com.nayael.crossover.characters.boss.states.sonic 
{
	import com.entity.engine.Entity;
	import com.entity.engine.fsm.IState;
	
	/**
	 * ...
	 * @author Nayael
	 */
	public class Stand implements IState
	{
	////////////////////////
	// PROPERTIES
	//
		private var entity:Entity;
		private var animation:MovieClip;
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function Stand(entity:Entity) {
			this.entity = entity;
			animation = new SonicStand();
		}
	
	////////////////////////
	// METHODS
	//
		public function enter():void {
			animation.gotoAndPlay(1);
			entity.view.sprite.addChild( animation );
		}
		
		public function exit():void {
			entity.view.sprite.removeChild( animation );
		}
	}
}