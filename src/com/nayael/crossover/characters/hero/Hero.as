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
	
	/**
	 * The hero class
	 * @author Nayael
	 */
	public final class Hero extends Character
	{
		static public const STAND:String  = "hero_stand";
		static public const RUN:String    = "hero_run";
		static public const JUMP:String   = "hero_jump";
		static public const FIRE:String   = "hero_fire";
		static public const SHIELD:String = "hero_shield";
		
		private var _keypad:Keypad;
		
		public function Hero() {
			_hSpeed = 8;
			
			body = new Body(this);
			body.x = (E.WIDTH >> 1) >> 1;
			body.y = E.HEIGHT - 40;
			body.angle = 90;
			
			physics = new Physics(this);
			physics.vX = 0;
			physics.vY = 8;
			
			view = new View(this);
			view.scale = 2;
			view.draw();
			
			health = new Health(this);
			health.hp = 100;
			
			weapon = new BusterGun(this);
			
			_fsm = new StateMachine();			
			_fsm.addState( STAND, new Stand(this)  , [RUN, JUMP, FIRE] );
			_fsm.addState( RUN  , new Running(this), [STAND, JUMP, FIRE] );
			_fsm.addState( JUMP , new Jumping(this), [STAND, RUN] );
			_fsm.addState( FIRE , new Fire(this)   , [STAND, RUN, JUMP] );
			
			state = STAND;
			
			_keypad = new Keypad(E.stage);
		}
		
		override public function update():void {
			physics.vX = 0;
			
			// RUNNING state
			if (_keypad.isDown(Keyboard.LEFT)) {
				turnLeft();
				if (state != JUMP || body.onFloor) {
					state = RUN;
				}
			}
			if (_keypad.isDown(Keyboard.RIGHT)) {
				turnRight();
				if (state != JUMP || body.onFloor) {
					state = RUN;
				}
			}
			if (_keypad.isDown(Keyboard.E)) {
				physics.vX -= 8;
			}
			
			// JUMP state
			if (!body.onFloor && state != JUMP) {
				state = JUMP;
			}
			if (_keypad.isDown(Keyboard.SPACE) && state != JUMP) {
				startJump();
			}
			if (state == JUMP) {
				jump();
			}
			
			// STAND state
			if (body.onFloor && physics.vX == 0) {
				state = STAND;
			}
			
			// FIRE state
			if (_keypad.isDown(Keyboard.ENTER)) {
				state = FIRE;
				weapon.fire();
			} else if (_keypad.isUp(Keyboard.ENTER) && weapon.cooldown != 0) {
				clearTimeout(weapon.cooldown);
				weapon.cooldown = 0;
			}
			
			super.update();
		}
		
		override public function onHit():void {
			//this.state = BLINKING;
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
	}
}