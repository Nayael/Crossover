package com.nayael.crossover.weapons
{
	import com.entity.engine.Body;
	import com.entity.engine.Bullet;
	import com.entity.engine.Entity;
	import com.entity.engine.Physics;
	import com.entity.engine.pooling.Pool;
	import com.entity.engine.View;
	import flash.display.MovieClip;
	
	public class Barrel extends Bullet
	{
		
		public function Barrel() {
			super();
			pool = Pool.instance.pool("barrels");
			strength = 10;
			view.sprite.addChild(new BarrelMC());
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