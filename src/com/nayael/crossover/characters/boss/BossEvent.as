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
		
		public var drop:Class;
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function BossEvent( type:String, drop:Class = null, bubbles:Boolean = false, cancelable:Boolean = false ) {
			super( type, bubbles, cancelable );
			this.drop = drop;
		}
		
	////////////////////////
	// METHODS
	//
		public override function clone ():Event {
			return new BossEvent ( type, drop, bubbles, cancelable );
		}
		
		public override function toString ():String {
			return '[BossEvent type="'+ type +'" bubbles=' + bubbles + ' cancelable=' + cancelable + ']';
		}
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}