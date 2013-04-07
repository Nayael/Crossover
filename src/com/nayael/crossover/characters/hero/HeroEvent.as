package com.nayael.crossover.characters.hero 
{
	import com.entity.engine.Entity;
	import com.entity.engine.events.EntityEvent;
	import flash.events.Event;
	/**
	 * Hero related events
	 * @author Nayael
	 */
	public class HeroEvent extends EntityEvent
	{
	////////////////////////
	// PROPERTIES
	//
		static public const HERO_DEAD:String = 'hero_dead';
		static public const HERO_HIT:String = 'hero_hit';
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function HeroEvent(type:String, entity:Entity, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, entity, bubbles, cancelable);
			
		}
	
	////////////////////////
	// METHODS
	//
		public override function clone ():Event {
			return new HeroEvent ( type, entity, bubbles, cancelable );
		}
		
		public override function toString ():String {
			return '[HeroEvent type="'+ type +'" bubbles=' + bubbles + ' cancelable=' + cancelable + ']';
		}
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}