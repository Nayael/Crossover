package com.entity.engine.utils.errors 
{
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Error thrown when an abstract method is called
	 * @author Nayael
	 */
	public class AbstractMethodError extends Error
	{
	////////////////////////
	// PROPERTIES
	//
		
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function AbstractMethodError(abstractClass:*, methodName:String) {
			super('Abstract method ' + getQualifiedClassName(abstractClass) + '.' + methodName + '() called. No override found.');
		}
	
	////////////////////////
	// METHODS
	//
		
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}