package com.nayael.crossover.characters.boss 
{
	import com.entity.engine.Body;
	import com.entity.engine.E;
	import com.entity.engine.fsm.StateMachine;
	import com.entity.engine.Health;
	import com.entity.engine.Physics;
	import com.entity.engine.View;
	import com.nayael.crossover.characters.boss.states.sonic.*;
	
	/**
	 * ...
	 * @author Nayael
	 */
	public class Sonic extends Boss
	{
	////////////////////////
	// PROPERTIES
	//
		static public const STAND:String  = "sonic_stand";
		static public const HURT:String   = "sonic_hurt";
		static public const RUN:String    = "sonic_run";
		static public const JUMP:String   = "sonic_jump";
		static public const CHARGE:String = "sonic_dash";
		static public const DASH:String   = "sonic_charge";
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function Sonic() {
			_hSpeed = 8;
			
			body = new Body(this);
			body.x = E.WIDTH - (E.WIDTH >> 2);
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
			
			_fsm = new StateMachine();
			_fsm.addState( STAND , new Stand(this)  , [RUN, JUMP]);
			_fsm.addState( RUN   , new Running(this), [STAND, JUMP]);
			_fsm.addState( JUMP  , new Jumping(this), [STAND, RUN]);
			_fsm.addState( CHARGE, new Charge(this) , [STAND, RUN]);
			_fsm.addState( DASH  , new Dash(this)   , [STAND, RUN]);
			
			state = STAND;
		}
	
	////////////////////////
	// METHODS
	//
		
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}