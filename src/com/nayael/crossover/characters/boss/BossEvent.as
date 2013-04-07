package com.nayael.crossover.characters.boss 
{
	import flash.events.Event;
	/**
	 * Level related events
	 * @author Nayael
	 */
	public class BossEvent extends Event
	{
	////////////////////////
	// PROPERTIES
	//
		static public const BOSS_DEAD:String = 'boss_dead';
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function BossEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
			super( type, bubbles, cancelable );
		}
		
	////////////////////////
	// METHODS
	//
		public override function clone ():Event {
			return new BossEvent ( type, bubbles, cancelable );
		}
		
		public override function toString ():String {
			return '[BossEvent type="'+ type +'" bubbles=' + bubbles + ' cancelable=' + cancelable + ']';
		}
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}