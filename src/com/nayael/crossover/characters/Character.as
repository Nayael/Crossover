package com.nayael.crossover.characters 
{
	import com.entity.engine.Entity;
	import com.entity.engine.fsm.StateMachine;
	import com.entity.engine.utils.errors.AbstractClassError;
	import flash.display.MovieClip;
	
	/**
	 * Abstract character class
	 * @author Nayael
	 */
	public class Character extends Entity
	{
	////////////////////////
	// PROPERTIES
	//
		protected var _hSpeed:int = 8;
		protected var _vHeight:int = 25;
		protected var _vSpeed:int = 2;
		protected var _fsm:StateMachine;
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function Character() {
			if (Object(this).constructor === Character) {
				throw new AbstractClassError(this);
			}
		}
	
	////////////////////////
	// METHODS
	//
		/**
		 * Makes the character turn left
		 */
		public function moveLeft():void {
			physics.vX = -_hSpeed;
			body.left = true;
		}
		
		/**
		 * Makes the character turn right
		 */
		public function moveRight():void {
			physics.vX = _hSpeed;
			body.right = true;
		}
		
		public function startJump():void {
			physics.vY = -_vHeight;
		}
		
		/**
		 * Makes the character jump
		 */
		public function jump():void {
			if (physics.vY < _vHeight) {
				physics.vY += _vSpeed;
			}
		}
	
	////////////////////////
	// GETTERS & SETTERS
	//
		public function get state():String {
			return _fsm.state;
		}
		
		public function set state(value:String):void {
			if (_fsm.state == value) {
				return;
			}
			_fsm.state = value;
			
			// If the entity has a hitbox, we make it invisible
			if ((view.sprite.getChildAt(0) as MovieClip).hitbox != undefined) {
				(view.sprite.getChildAt(0) as MovieClip).hitbox.visible = false;
				body.hitbox = (view.sprite.getChildAt(0) as MovieClip).hitbox;
			} else {
				body.hitbox = null;
			}
		}
	}
}