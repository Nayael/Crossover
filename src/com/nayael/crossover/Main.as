package com.nayael.crossover
{
	import engine.Game;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Main game class for the Crossover game
	 * @author Nayael
	 */
	[SWF(width="800",height="600",frameRate="30",backgroundColor="0x0")]
	public class Main extends Game 
	{
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
		}
	}
}