package com.nayael.crossover.weapons 
{
	import com.entity.engine.Entity;
	import com.entity.engine.EventBroker;
	import com.entity.engine.events.EntityEvent;
	import com.entity.engine.events.EntityEventType;
	import com.entity.engine.pooling.Pool;
	import com.entity.engine.Weapon;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Nayael
	 */
	public class BarrelThrower extends Weapon
	{
	////////////////////////
	// PROPERTIES
	//
		private var bulletPool:Array;
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function BarrelThrower(entity:Entity) {
			maxAmmo = 15;
			super( entity );
			bulletPool = Pool.instance.pool("barrels");
			cooldownTime = 500;
			color = 'Red';
		}
	
	////////////////////////
	// METHODS
	//
		override public function fire():Boolean {
			if (cooldown != 0) {
				return false;
			}
			var entityMC:MovieClip = (entity.view.sprite.getChildAt(0) as MovieClip);
			this.x = entityMC.gun ? entityMC.gun.x : null;
			this.y = entityMC.gun ? entityMC.gun.y * entity.view.scale : null;
			
			var bullet:Barrel = bulletPool.length ? bulletPool.pop() : new Barrel();
			bullet.targets = entity.targets;
			bullet.group   = entity.group;
			bullet.body.x  = entity.body.x + ( this.x || ( entity.view.sprite.width * 0.5 ) ) * (entity.body.left ? -1 : 1);
			bullet.body.y  = entity.body.y + ( this.y || ( entity.view.sprite.height * 0.5 ) ) * (entity.view.sprite.scaleY < 0 ? -1 : 1);
			bullet.init(entity);
			bullet.physics.vX = entity.body.left ? -25 : 25;
			EventBroker.broadcast( new EntityEvent(EntityEventType.CREATED, bullet) );
			
			//SoundManager.instance.playSfx( SoundManager.ACTION2 );
			
			return super.fire();
		}
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}