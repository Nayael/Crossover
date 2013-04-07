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
		static public const WALL:String      = "hero_wall";
		static public const WALL_FIRE:String = "hero_wall_fire";
		static public const JUMP_FIRE:String = "hero_jump_fire";
		static public const RUN_FIRE:String  = "hero_run_fire";
		static public const SHIELD:String    = "hero_shield";
		static public const WIN:String       = "hero_win";
		
		private var _keypad:Keypad;
		private var _weapons:Vector.<Weapon>;
		
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
			
			_weapons = Vector.<Weapon>([new BusterGun(this)]);
			weapon = _weapons[0];
			
			_fsm = new StateMachine();			
			_fsm.addState( STAND     , new Stand(this)   , [HURT, RUN, JUMP, FIRE, RUN_FIRE, WALL, WALL_FIRE, WIN] );
			_fsm.addState( HURT      , new Hurt(this)    , [STAND, RUN, RUN_FIRE, JUMP, JUMP_FIRE, WIN] );
			_fsm.addState( RUN       , new Running(this) , [STAND, HURT, JUMP, FIRE, RUN_FIRE, WIN] );
			_fsm.addState( JUMP      , new Jumping(this) , [STAND, HURT, RUN, RUN_FIRE, JUMP_FIRE, WALL, WALL_FIRE, WIN] );
			_fsm.addState( FIRE      , new Fire(this)    , [STAND, HURT, RUN, RUN_FIRE, JUMP, JUMP_FIRE, WIN] );
			_fsm.addState( JUMP_FIRE , new JumpFire(this), [STAND, HURT, RUN, RUN_FIRE, JUMP, WALL, WALL_FIRE, WIN] );
			_fsm.addState( RUN_FIRE  , new RunFire(this) , [STAND, HURT, RUN, FIRE, JUMP, JUMP_FIRE, WIN] );
			_fsm.addState( WALL      , new Wall(this)    , [STAND, JUMP, RUN, JUMP_FIRE, WALL_FIRE, WIN] );
			_fsm.addState( WALL_FIRE , new WallFire(this), [STAND, JUMP, RUN, JUMP_FIRE, WALL, WIN] );
			_fsm.addState( WIN       , new Win(this)     , [STAND, HURT, RUN, JUMP, FIRE, JUMP_FIRE, RUN_FIRE, WALL, WALL_FIRE] );
			
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
			if (_keypad && (_keypad.isDown(Keyboard.LEFT) || _keypad.isDown(Keyboard.Q))) {
				moveLeft();
				if (body.onFloor && !body.onWall ) {
					state = RUN;
				}
			}
			if (_keypad && (_keypad.isDown(Keyboard.RIGHT) || _keypad.isDown(Keyboard.D))) {
				moveRight();
				if (body.onFloor && !body.onWall ) {
					state = RUN;
				}
			}
			
			// STAND state
			if (body.onFloor && physics.vX == 0) {
				state = STAND;
			}
			
			// JUMP state
			if (!body.onFloor && !body.onWall && physics.vY <= 0) {
				state = JUMP;
			}
			if (_keypad && _keypad.isDown(Keyboard.SPACE) && (body.onFloor || state == WALL || state == WALL_FIRE)) {
				if (state == WALL || state == WALL_FIRE) {
					(physics as HeroPhysics).wallJumping = true;
				}
				startJump();
			}
			if (state == JUMP || state == JUMP_FIRE || state == WALL || state == WALL_FIRE) {
				jump();
			}
			
			super.update();
			
			// FIRE state
			if (_keypad && _keypad.isDown(Keyboard.ENTER)) {
				if (state == JUMP) {
					state = JUMP_FIRE;
				} else if (state == RUN) {
					state = RUN_FIRE;
				} else if (state == WALL) {
					state = WALL_FIRE;
				} else {
					state = FIRE;
				}
				weapon.fire();
			} else if (_keypad && _keypad.isUp(Keyboard.ENTER) && weapon.cooldown != 0) {
				clearTimeout(weapon.cooldown);
				weapon.cooldown = 0;
			}
		}
		
		override public function onHurt():void {
			if (this.state != HURT) {
				this.state = HURT;
			}
		}
		
		override public function onDie():void {
			destroy();
			EventBroker.broadcast( new Event(HeroEvent.HERO_DEAD) );
		}	
		
		override public function destroy():void {
			disableControls();
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
		}
		
		/**
		 * The hero gains a new weapon
		 * @param	weapon The class of the weapon to add
		 */
		public function takeWeapon(weapon:Class):void {
			_weapons.push(new weapon(this));
		}
		
		/**
		 * Destroys the Keypad object
		 */
		public function disableControls():void {
			if (_keypad) {
				_keypad.destroy();
				_keypad = null;
			}
		}
	}
}