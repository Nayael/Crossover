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
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class BusterGun extends Weapon
	{
		private var bulletPool:Array;

		public function BusterGun(entity:Entity) {
			usesAmmo = false;
			bulletPool = Pool.instance.pool("busterBullets");
			super( entity );
		}
		
		override public function fire():Boolean {
			if (cooldown != 0) {
				return false;
			}
			this.x = (entity.view.sprite.getChildAt(0) as MovieClip).gun.x || null;
			this.y = (entity.view.sprite.getChildAt(0) as MovieClip).gun.y * entity.view.scale || null;
			
			var bullet:BusterBullet = bulletPool.length ? bulletPool.pop() : new BusterBullet();
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
	}
}