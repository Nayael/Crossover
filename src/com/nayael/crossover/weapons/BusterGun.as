package com.nayael.crossover.weapons 
{
	import com.entity.engine.E;
	import com.entity.engine.Entity;
	import com.entity.engine.EventBroker;
	import com.entity.engine.events.EntityEvent;
	import com.entity.engine.events.EntityEventType;
	import com.entity.engine.pooling.Pool;
	import com.entity.engine.SoundManager;
	import com.entity.engine.Weapon;
	import flash.events.Event;
	
	public class BusterGun extends Weapon
	{
		private var bulletPool:Array;

		public function BusterGun(entity:Entity) {
			bulletPool = Pool.instance.pool("busterBullets");
			super( entity );
		}
		
		override public function fire():Boolean {
			if (cooldown != 0) {
				return false;
			}
			var bullet:BusterBullet = bulletPool.length ? bulletPool.pop() : new BusterBullet();
			bullet.init(entity);
			bullet.targets    = entity.targets;
			bullet.group      = entity.group;
			bullet.body.x     = entity.body.x + entity.view.sprite.width * 0.3;
			bullet.body.y     = entity.body.y - entity.view.sprite.height * 0.5;
			bullet.physics.vX = entity.body.left ? -25 : 25;
			EventBroker.broadcast( new EntityEvent(EntityEventType.CREATED, bullet) );
			
			//SoundManager.instance.playSfx( SoundManager.ACTION2 );
			
			super.fire();
			ammo++;	// Ammo is unlimited
			return true;
		}
	}
}