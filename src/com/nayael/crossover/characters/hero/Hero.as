package com.nayael.crossover.characters.hero
{
	import com.entity.engine.*;
	import com.entity.engine.events.*;
	import com.entity.engine.fsm.*;
	import com.entity.engine.pooling.Pool;
	import com.nayael.crossover.characters.Character;
	import com.nayael.crossover.characters.hero.states.*;
	import com.nayael.crossover.Main;
	import com.nayael.crossover.weapons.*;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.ui.*;
	import flash.utils.Timer;
	
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
		static public const DASH:String      = "hero_dash";
		static public const WALL:String      = "hero_wall";
		static public const WALL_FIRE:String = "hero_wall_fire";
		static public const JUMP_FIRE:String = "hero_jump_fire";
		static public const RUN_FIRE:String  = "hero_run_fire";
		static public const SHIELD:String    = "hero_shield";
		static public const WIN:String       = "hero_win";
		
		static public var save:Save = new Save({
			weapons: [BusterGun]
		});
		
		private var _keypad:Keypad;
		private var _controllable:Boolean = true;
		private var _weapons:Vector.<Weapon>;
		private var _changingWeapon:Boolean;
		
	////////////////////////
	// CONSTRUCTOR
	//
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
			
			_loadSave();
			
			_fsm = new StateMachine();			
			_fsm.addState( STAND     , new Stand(this)      , [HURT, RUN, JUMP, FIRE, RUN_FIRE, WALL, WALL_FIRE, WIN, DASH, SHIELD] );
			_fsm.addState( HURT      , new Hurt(this)       , [STAND, RUN, RUN_FIRE, JUMP, JUMP_FIRE, WALL, WALL_FIRE, WIN, DASH] );
			_fsm.addState( RUN       , new Running(this)    , [STAND, HURT, JUMP, FIRE, RUN_FIRE, WIN, DASH, SHIELD] );
			_fsm.addState( JUMP      , new Jumping(this)    , [STAND, HURT, RUN, RUN_FIRE, JUMP_FIRE, WALL, WALL_FIRE, WIN, DASH] );
			_fsm.addState( FIRE      , new Fire(this)       , [STAND, HURT, RUN, RUN_FIRE, JUMP, JUMP_FIRE, WALL, WALL_FIRE, WIN, DASH, SHIELD] );
			_fsm.addState( JUMP_FIRE , new JumpFire(this)   , [STAND, HURT, RUN, RUN_FIRE, JUMP, FIRE, WALL, WALL_FIRE, WIN, DASH] );
			_fsm.addState( RUN_FIRE  , new RunFire(this)    , [STAND, HURT, RUN, FIRE, JUMP, JUMP_FIRE, WIN, DASH, SHIELD] );
			_fsm.addState( WALL      , new Wall(this)       , [STAND, HURT, JUMP, RUN, JUMP_FIRE, WALL_FIRE, WIN, DASH] );
			_fsm.addState( WALL_FIRE , new WallFire(this)   , [STAND, HURT, JUMP, RUN, FIRE, JUMP_FIRE, WALL, WIN, DASH] );
			_fsm.addState( WIN       , new Win(this)        , [STAND, HURT, RUN, JUMP, FIRE, JUMP_FIRE, RUN_FIRE, WALL, WALL_FIRE, DASH] );
			_fsm.addState( DASH      , new Dash(this)       , [STAND, HURT, RUN, JUMP, FIRE, JUMP_FIRE, RUN_FIRE, WALL, WALL_FIRE, WIN, SHIELD] );
			_fsm.addState( SHIELD    , new ShieldState(this), [STAND, HURT, RUN, JUMP, FIRE, JUMP_FIRE, RUN_FIRE, WALL, WALL_FIRE, WIN] );
			
			state = STAND;
			
			_keypad = new Keypad(E.stage);
			EventBroker.subscribe(HeroEvent.HERO_HIT, onHit);
			EventBroker.subscribe(EntityEventType.CREATED, onEntityCreated);
			EventBroker.subscribe(EntityEventType.DESTROYED, onEntityDestroyed);
		}
		
		private function _loadSave():void {
			_weapons = new Vector.<Weapon>();	// We load all the weapons he gained
			for each (var item:* in save.weapons) {
				item = item as Class;
				_weapons.push(new item(this));
			}
			weapon = _weapons.shift();
		}
		
		override public function update():void {
			if (!_changingWeapon && _controllable && _keypad && _keypad.isDown(Keyboard.L)) {
				changeWeapon();
			} else if (_keypad && _keypad.isUp(Keyboard.L)) {
				_changingWeapon = false
			}
			
			// HURT state
			if (state == HURT) {
				var sprite:MovieClip = (view.sprite.getChildAt(0) as MovieClip);
				if (sprite.currentFrame == sprite.totalFrames) {
					state = STAND;
					_controllable = true;
				} else {
					super.update();
					return;
				}
			}
			
			if (state != DASH) {
				physics.vX = 0;
			}
			
			// RUNNING state
			if (_controllable && _keypad && (_keypad.isDown(Keyboard.LEFT) || _keypad.isDown(Keyboard.Q))) {
				moveLeft();
				if (body.onFloor && !body.onWall) {
					state = RUN;
				}
			}
			if (_controllable && _keypad && (_keypad.isDown(Keyboard.RIGHT) || _keypad.isDown(Keyboard.D))) {
				moveRight();
				if (body.onFloor && !body.onWall) {
					state = RUN;
				}
			}
			
			// STAND state
			if (body.onFloor && physics.vX == 0) {
				state = STAND;
			}
			
			// JUMP state
			if (!body.onFloor && !body.onWall && physics.vY != 0) {
				state = JUMP;
			}
			if (_controllable && _keypad && _keypad.isDown(Keyboard.SPACE) && (body.onFloor || state == WALL || state == WALL_FIRE)) {
				if (state == WALL || state == WALL_FIRE) {
					(physics as HeroPhysics).wallJumping = true;
				}
				startJump();
			}
			if (state == JUMP || state == JUMP_FIRE || state == WALL || state == WALL_FIRE) {
				jump();
			}
			
			// DASH state
			if (state != HURT && weapon is Dasher && weapon.cooldown != 0 && (weapon as Dasher).dashTimer.running) {
				state = DASH;
				physics.vX = (weapon as Dasher).speed * (body.left ? -1 : 1);
				_handleDash();
			}
			
			super.update();
			
			// FIRE state
			if ((_controllable || weapon is Shield) && _keypad && _keypad.isDown(Keyboard.K)) {
				if (weapon is Shield && weapon.ammo > 0 && weapon.cooldown == 0) {
					state = SHIELD;
					_controllable = false;
				} else {
					if (!(weapon is Dasher)) {
						switch (state) {
							case JUMP: case JUMP_FIRE:
								state = JUMP_FIRE;
								break;
							case RUN: case RUN_FIRE:
								state = RUN_FIRE;
								break;
							case WALL: case WALL_FIRE:
								state = WALL_FIRE;
								break;
							default:
								state = FIRE;
								break;
						}
					}
					weapon.fire();
				}
			} else if ((_controllable || weapon is Shield) && _keypad && _keypad.isUp(Keyboard.K)) {
				_controllable = true;
				if (weapon && weapon.cooldown != 0) {
					weapon.endCooldown();
				}
				if (weapon is Dasher && state == DASH) {
					(weapon as Dasher).stopDash();
				}
			}
		}
		
		private function _handleDash():void {
			for each (var target:Entity in targets) {
				if (body.collide(target)) {
					target.onHit((weapon as Dasher).strength, Object(weapon).constructor, physics.vX, physics.vY);
					return;
				}
			}
		}
		
		override public function onHit(damage:int, weapon:Class = null, vX:Number = 0, vY:Number = 0):void {
			// If the hero is protecting with the shield, he can be hit only with the Dasher
			if (state == SHIELD) {
				if (weapon === Dasher) {	// The dasher breaks the shield guard
					this.weapon.ammo -= 2;
					(this.weapon as Shield).onHit();
				} else {	// Otherwise, the hero takes no damage
					if (weapon === BarrelThrower) {	// If the shield is hit by a barrel, the barrel rebounds
						(new BarrelThrower(this)).fire();
					}
					this.weapon.ammo -= 0.5;
					return;
				}
			}
			super.onHit(damage, weapon, vX, vY);
		}
		
		override public function onHurt():void {
			if (this.state != HURT) {
				this.state = HURT;
				_controllable = false;
			}
		}
		
		override public function onDie():void {
			destroy();
			save = new Save({
				weapons: [BusterGun]
			});
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
				var wallJumpTimer:Timer = new Timer(300, 1);
				wallJumpTimer.addEventListener(TimerEvent.TIMER_COMPLETE, endWallJump);
				wallJumpTimer.start();
			}
			
			function endWallJump(e:TimerEvent):void {
				wallJumpTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, endWallJump);
				if (physics) {
					(physics as HeroPhysics).wallJumping = false;
				}
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
		 * Changes the equiped weapon
		 */
		private function changeWeapon():void {
			_weapons.push(weapon);
			weapon = _weapons.shift();
			_changingWeapon = true;
			(_game as Main).hud.hideHeroAmmo();
			if (weapon.usesAmmo) {
				(_game as Main).hud.showHeroAmmo(weapon.maxAmmo, weapon.color);
			}
		}
		
		/**
		 * The hero gains a new weapon
		 * @param	weapon The class of the weapon to add
		 */
		public function takeWeapon(weapon:Class):void {
			_weapons.push(new weapon(this));
			// We save the new weapon
			if (save.weapons.indexOf(weapon) == -1) {
				save.weapons.push(weapon);
			}
		}
		
		/**
		 * Destroys the Keypad object
		 */
		public function disableControls():void {
			if (_keypad) {
				_keypad.destroy();
				_controllable = false;
				_keypad = null;
			}
		}
		
		public function onEntityCreated(e:EntityEvent):void {
			
		}
		
		public function onEntityDestroyed(e:EntityEvent):void {
			
		}
	}
}