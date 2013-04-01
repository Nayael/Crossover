package com.nayael.crossover.characters.hero
{
	import com.entity.engine.*;
	import com.entity.engine.events.*;
	import com.entity.engine.fsm.*;
	import com.nayael.crossover.characters.Character;
	import com.nayael.crossover.characters.hero.states.*;
	import com.nayael.crossover.weapons.BusterGun;
	import flash.display.*;
	import flash.events.Event;
	import flash.ui.*;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * The hero class
	 * @author Nayael
	 */
	public final class Hero extends Character
	{
		static public const STAND:String     = "hero_stand";
		static public const HURT:String      = "hero_hurt";
		static public const RUN:String       = "hero_run";
		static public const JUMP:String      = "hero_jump";
		static public const FIRE:String      = "hero_fire";
		static public const JUMP_FIRE:String = "hero_jump_fire";
		static public const RUN_FIRE:String  = "hero_run_fire";
		static public const SHIELD:String    = "hero_shield";
		
		private var _keypad:Keypad;
		
		public function Hero() {
			_hSpeed = 8;
			
			body = new Body(this);
			body.x = (E.WIDTH >> 1) >> 1;
			body.y = E.HEIGHT - 40;
			body.angle = 90;
			
			physics = new HeroPhysics(this);
			physics.vX = 0;
			physics.vY = 8;
			
			view = new View(this);
			view.scale = 2;
			view.draw();
			
			health = new Health(this);
			health.hp = 100;
			
			weapon = new BusterGun(this);
			
			_fsm = new StateMachine();			
			_fsm.addState( STAND     , new Stand(this)   , [HURT, RUN, JUMP, FIRE, RUN_FIRE] );
			_fsm.addState( HURT      , new Hurt(this)    , [STAND, RUN, RUN_FIRE, JUMP, JUMP_FIRE] );
			_fsm.addState( RUN       , new Running(this) , [STAND, HURT, JUMP, FIRE, RUN_FIRE] );
			_fsm.addState( JUMP      , new Jumping(this) , [STAND, HURT, RUN, RUN_FIRE, JUMP_FIRE] );
			_fsm.addState( FIRE      , new Fire(this)    , [STAND, HURT, RUN, RUN_FIRE, JUMP, JUMP_FIRE] );
			_fsm.addState( JUMP_FIRE , new JumpFire(this), [STAND, HURT, RUN, RUN_FIRE, JUMP] );
			_fsm.addState( RUN_FIRE  , new RunFire(this) , [STAND, HURT, RUN, FIRE, JUMP, JUMP_FIRE] );
			
			state = STAND;
			
			_keypad = new Keypad(E.stage);
		}
		
		override public function update():void {
			if (state == HURT) {
				var sprite:MovieClip = (view.sprite.getChildAt(0) as MovieClip);
				if (sprite.currentFrame == sprite.totalFrames - 1) {
					state = STAND;
				} else {
					super.update();
					return;
				}
			}
			physics.vX = 0;
			
			// RUNNING state
			if (_keypad.isDown(Keyboard.LEFT) && !( (physics as HeroPhysics).wallJumping && !body.left ) ) {
				turnLeft();
				if (state != JUMP || body.onFloor) {
					state = RUN;
				}
			}
			if (_keypad.isDown(Keyboard.RIGHT) && !( (physics as HeroPhysics).wallJumping && !body.right ) ) {
				turnRight();
				if (state != JUMP || body.onFloor) {
					state = RUN;
				}
			}
			if (_keypad.isDown(Keyboard.E)) {
				physics.vX -= 8;
			}
			
			// STAND state
			if (body.onFloor && physics.vX == 0) {
				state = STAND;
			}
			
			// JUMP state
			if (!body.onFloor) {
				state = JUMP;
			}
			if (_keypad.isDown(Keyboard.SPACE) && (body.onFloor || (physics as HeroPhysics).onWall)) {
				if (!body.onFloor && (physics as HeroPhysics).onWall) {
					(physics as HeroPhysics).wallJumping = true;
				}
				startJump();
			}
			if (state == JUMP || state == JUMP_FIRE) {
				jump();
			}
			
			super.update();
			
			// FIRE state
			if (_keypad.isDown(Keyboard.ENTER)) {
				if (state == JUMP) {
					state = JUMP_FIRE;
				} else if (state == RUN) {
					state = RUN_FIRE;
				} else {
					state = FIRE;
				}
				weapon.fire();
			} else if (_keypad.isUp(Keyboard.ENTER) && weapon.cooldown != 0) {
				clearTimeout(weapon.cooldown);
				weapon.cooldown = 0;
			}
		}
		
		override public function onHit():void {
			this.state = HURT;
		}
		
		override public function onDie():void {
			destroy();
			EventBroker.broadcast( new Event(HeroEventType.HERO_DEAD) );
		}	
		
		override public function destroy():void {
			_keypad.destroy();
			_keypad = null;
			
			super.destroy();
			
			this.body = null;
			this.physics = null;
			this.weapon = null;
			this.health = null;
			this.view = null;
		}
		
		override public function startJump():void {
			physics.vY = -_vHeight;
			if ((physics as HeroPhysics).wallJumping) {
				physics.vX *= -3;
				body.left = !body.left;
				setTimeout(function ():void {
					(physics as HeroPhysics).wallJumping = false;
				}, 300);
			}
		}
		
		/**
		 * Makes the character jump
		 */
		override public function jump():void {
			if (physics.vY < _vHeight) {
				physics.vY += _vSpeed;
			}
			physics.vX += (body.left ? -1 : 1);
		}
	}
}