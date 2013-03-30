package com.nayael.crossover.characters.boss 
{
	/**
	 * ...
	 * @author Nayael
	 */
	public class Sonic extends Boss
	{
	////////////////////////
	// PROPERTIES
	//
		
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function Sonic() {
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
			
			_fsm = new StateMachine();			
			_fsm.addState( STAND, new Stand(this)  , [RUN, JUMP]);
			_fsm.addState( RUN  , new Running(this), [STAND, JUMP]);
			_fsm.addState( JUMP , new Jumping(this), [STAND, RUN]);
			
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