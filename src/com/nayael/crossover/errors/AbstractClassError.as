package com.nayael.crossover.errors 
{
	import flash.utils.getQualifiedClassName;

	/**
	 * Error thrown when an abstract class is instancied
	 * @author Nayael
	 */
	public class AbstractClassError extends Error
	{
	////////////////////////
	// PROPERTIES
	//
		
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function AbstractClassError(abstractClass:*) {
			super(getQualifiedClassName(abstractClass) + ' is an abstract class. It cannot be instancied.');
		}
	
	////////////////////////
	// METHODS
	//
		
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}