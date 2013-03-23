package com.nayael.crossover.ui 
{
	import classes.BossSlot;
	import com.entity.engine.E;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * The boss grid
	 * @author Nayael
	 */
	public class BossGrid extends Sprite
	{
	////////////////////////
	// PROPERTIES
	//
		private var _slots:Vector.<BossSlot>;
		private var _selected:int = 0;
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function BossGrid() {
			_slots = Vector.<BossSlot>([
				new BossSlot('Sonic'),
				new BossSlot('Link'),
				new BossSlot('DonkeyKong'),
				new BossSlot(),
				new BossSlot(),
				new BossSlot(),
				new BossSlot(),
				new BossSlot(),
				new BossSlot()
			]);
			var i:int = 0,
				j:int = 0;
			for each (var item:BossSlot in _slots) {
				if (i !=0 && i % 3 == 0) {
					j++;
					i = 0;
				}
				
				item.x = i * item.width;
				item.y = j * item.height;
				addChild(item);
				
				if (i == 1 && j == 1) {	// There are only 8 bosses on the grid, so we skip the one on the middle
					removeChild(item);
				}
				
				i++;
			}
			_slots[0].onEnter();
			
			this.x = (E.WIDTH >> 1) - (this.width >> 1);
			this.y = (E.HEIGHT >> 1) - (this.height >> 1);
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
	
	////////////////////////
	// METHODS
	//
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			E.stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
		}
		
		private function _onKeyDown(e:KeyboardEvent):void {
			if (e.keyCode != Keyboard.UP
			 && e.keyCode != Keyboard.DOWN
			 && e.keyCode != Keyboard.LEFT
			 && e.keyCode != Keyboard.RIGHT) {
				return;
			}
			
			var nextSlot:int;
			
			switch (e.keyCode) {
				case Keyboard.UP:
					nextSlot = _selected - 3 >= 0 ? _selected - 3 : _selected + 6;
					break;
				case Keyboard.DOWN:
					nextSlot = _selected + 3 <= 9 ? _selected + 3 : _selected - 6;
					break;
				case Keyboard.LEFT:
					nextSlot = _selected - 1 >= 0 ? _selected - 1 : _selected + 2;
					break;
				case Keyboard.RIGHT:
					nextSlot = _selected + 1 <= 2 ? _selected + 1 : _selected - 2;
					break;
			}
			
			_enterSlot(nextSlot);
		}
		
		/**
		 * Makes the "cursor" enter a slot in the grid
		 * @param	index	The slot to select
		 */
		private function _enterSlot(index:int):void {
			if (_slots[index].bossName.length == 0) {	// If there is no boss inside the slot
				return;
			}
			_slots[_selected].onLeave();
			_selected = index;
			_slots[_selected].onEnter();
		}
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}