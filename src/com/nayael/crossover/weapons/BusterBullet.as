package com.nayael.crossover.weapons
{
	import com.entity.engine.Body;
	import com.entity.engine.Bullet;
	import com.entity.engine.Entity;
	import com.entity.engine.Physics;
	import com.entity.engine.pooling.Pool;
	import com.entity.engine.View;
	import flash.display.MovieClip;
	
	public class BusterBullet extends Bullet
	{
		
		public function BusterBullet() {
			super();
			pool = Pool.instance.pool("busterBullets");
			strength = 2;
			view.sprite.addChild(new BusterBulletMC());
			// If the entity has a hitbox, we make it invisible
			if ((view.sprite.getChildAt(0) as MovieClip).hitbox != undefined) {
				(view.sprite.getChildAt(0) as MovieClip).hitbox.visible = false;
				body.hitbox = (view.sprite.getChildAt(0) as MovieClip).hitbox;
			} else {
				body.hitbox = null;
			}
		}
		
		override public function init(parent:Entity):void {
			super.init(parent);
			ttl = 25;
		}
	}
}