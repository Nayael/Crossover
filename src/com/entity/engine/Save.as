package com.entity.engine 
{
	import com.entity.engine.Entity;
	/**
	 * ...
	 * @author Nayael
	 */
	public dynamic class Save
	{
	////////////////////////
	// PROPERTIES
	//
		
	
	////////////////////////
	// CONSTRUCTOR
	//
		/**
		 * Creates a save
		 * @param	data	[Optional] Data to initialise the save with
		 */
		public function Save(data:Object = null) {
			if (data == null) {
				return;
			}
			for (var key:String in data) {
				this.saveData(key, data[key]);
			}
		}
	
	////////////////////////
	// METHODS
	//
		/**
		 * Loads the saved properties into an entity
		 * @param	target
		 */
		public function load(entity:Entity):void {
			for (var name:String in this) {
				if (entity[name] == undefined) {
					continue;
				}
				entity[name] = this[name];
			}
		}
		
		/**
		 * Saves a value
		 * @param	key
		 * @param	value
		 */
		public function saveData(key:String, value:*):void {
			this[key] = value;
		}
		
		/**
		 * Erases all the data in the save
		 */
		static public function erase(save:Save):void {
			save = new Save();
		}
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}