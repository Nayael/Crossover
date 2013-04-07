package com.nayael.crossover.events 
{
	import flash.events.Event;
	/**
	 * Level related events
	 * @author Nayael
	 */
	public class LevelEvent extends Event
	{
	////////////////////////
	// PROPERTIES
	//
		static public const FINISHED:String = 'level_finished';
		
		public var win:Boolean;
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function LevelEvent ( type:String, win:Boolean = false, bubbles:Boolean = false, cancelable:Boolean = false ) {
			super( type, bubbles, cancelable );
			this.win = win;
		}
		
	////////////////////////
	// METHODS
	//
		public override function clone ():Event {
			return new LevelEvent ( type, bubbles, cancelable );
		}
		
		public override function toString ():String {
			return '[LevelEvent type="'+ type +'" bubbles=' + bubbles + ' cancelable=' + cancelable + ']';
		}
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}