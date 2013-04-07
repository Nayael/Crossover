package com.nayael.crossover.weapons 
{
	import com.entity.engine.SoundManager;
	import com.entity.engine.Weapon;
	import com.nayael.crossover.characters.hero.Hero;
	
	/**
	 * Makes the character dash
	 */
	public class Dasher extends Weapon
	{
		public function Dasher(entity:Hero) {
			super( entity );
		}
		
		override public function fire():Boolean {
			if (cooldown != 0) {
				return false;
			}
			//SoundManager.instance.playSfx( SoundManager.ACTION2 );
			
			super.fire();
			return true;
		}
	}
}