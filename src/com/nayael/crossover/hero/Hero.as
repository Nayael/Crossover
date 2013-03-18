package com.nayael.crossover.hero
{
	import com.entity.engine.*;
	import com.entity.engine.events.*;
	import com.entity.engine.fsm.*;
	import com.nayael.crossover.hero.states.*;
	import flash.display.*;
	import flash.events.Event;
	import flash.ui.*;
	
	/**
	 * The hero class
	 * @author Nayael
	 */
	public class Hero extends Entity
	{
		static public const STAND:String = "hero_stand";
		static public const RUN:String   = "hero_run";
		static public const JUMP:String  = "hero_jump";
		static public const FIRE:String  = "hero_fire";
		private var _fsm:StateMachine;
		
		private var keypad:Keypad;
		
		public function Hero() {
			body = new Body(this);
			body.x = E.WIDTH >> 1;
			body.y = E.HEIGHT >> 1;
			body.radius = 20;
			
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
			
			_fsm.state = STAND;
			
			keypad = new Keypad(E.stage);
		}
		
		override public function update():void {
			//physics.vX = 0;
			//if ( !keypad.isDown(Keyboard.LEFT) || !keypad.isDown(Keyboard.RIGHT))
			//{
				//if (keypad.isDown(Keyboard.LEFT))
				//{
					//physics.vX = -8;
					//_fsm.state = RUN;
				//}
				//if (keypad.isDown(Keyboard.RIGHT))
				//{
					//physics.vX = 8;
					//_fsm.state = RUN;					
				//}
				//
			//}
			//if (physics.vX == 0)
			//{
				//_fsm.state = STAND;
			//}
			//
			//super.update();
		}
		
		public function get state():String {
			return _fsm.state;
		}
		
		public function set state(value:String):void {
			_fsm.state = value;
		}
		
		//override public function onHit():void {
			//this.state = BLINKING;
		//}
		
		override public function onDie():void {
			destroy();
			EventBroker.broadcast( new Event(HeroEventType.HERO_DEAD) );
		}	
		
		override public function destroy():void {
			keypad.destroy();
			keypad = null;
			
			super.destroy();
			
			this.body = null;
			this.physics = null;
			this.weapon = null;
			this.health = null;
			this.view = null;
		}		
	
	}

}