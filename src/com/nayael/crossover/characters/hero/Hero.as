package com.nayael.crossover.characters.hero
{
	import com.entity.engine.*;
	import com.entity.engine.events.*;
	import com.entity.engine.fsm.*;
	import com.nayael.crossover.characters.Character;
	import com.nayael.crossover.characters.hero.states.*;
	import flash.display.*;
	import flash.events.Event;
	import flash.ui.*;
	
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
			body.x = E.WIDTH >> 1;
			body.y = E.HEIGHT >> 1;
			
			physics = new Physics(this);
			physics.vX = 0;
			physics.vY = 0;
			
			view = new View(this);
			view.scale = 2;
			view.draw();
			
			health = new Health(this);
			health.hp = 100;
			
			_fsm = new StateMachine();			
			_fsm.addState( STAND, new Stand(this)  , [RUN]);
			_fsm.addState( RUN  , new Running(this), [STAND]);			
			
			state = STAND;
			
			_keypad = new Keypad(E.stage);
		}
		
		override public function update():void {
			physics.vX = 0;
			
			if (_keypad.isDown(Keyboard.LEFT)) {
				turnLeft();
				state = RUN;
			}
			if (_keypad.isDown(Keyboard.RIGHT)) {
				turnRight();
				state = RUN;
			}
			
			// If he is not moving, set state as STAND
			if (physics.vX == 0) {
				state = STAND;
			}
			
			super.update();
		}
		
		//override public function onHit():void {
			//this.state = BLINKING;
		//}
		
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