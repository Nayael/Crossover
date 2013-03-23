package com.entity.engine.utils 
{
	import com.entity.engine.utils.errors.AbstractClassError;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * A class with useful functions
	 * @author Nayael
	 */
	public final class Utils
	{
	////////////////////////
	// PROPERTIES
	//
		
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function Utils() {
			if (Object(this).constructor === Utils) {
				throw new AbstractClassError(this);
			}
		}
	
	////////////////////////
	// METHODS
	//
		/**
		 * Creates a identical clone of a given object
		 * @param	source	The object to be cloned
		 * @return	The clone
		 */
		public static function clone(source:Object):Object {
			var clone:Object;
			if (source) {
				clone = newSibling(source);
				if (clone) {
					copyData(source, clone);
				}
			}
			return clone;
		}
		
		/**
		 * Creates a new object with the class of the object to be cloned
		 * @param	sourceObj	The object to be cloned
		 * @return	The new object
		 */
		private static function newSibling(sourceObj:Object):* {
			if (sourceObj) {
				var objSibling:*;
				try {
					var classOfSourceObj:Class = getDefinitionByName(getQualifiedClassName(sourceObj)) as Class;
					objSibling = new classOfSourceObj();
				} catch (e:Object) { }
				return objSibling;
			}
			return null;
		}
		
		/**
		 * Copies data from commonly named properties and getter/setter pairs
		 * @param	source	The copied object
		 * @param	destination	The clone
		 */
		private static function copyData(source:Object, destination:Object):void {
			if ((source) && (destination)) {
				try	{
					var sourceInfo:XML = describeType(source);
					var prop:XML;
					
					for each (prop in sourceInfo.variable) {
						if (destination.hasOwnProperty(prop.@name)) {
							destination[prop.@name] = source[prop.@name];
						}
					}
					for each (prop in sourceInfo.accessor) {
						if (prop.@access == "readwrite") {
							if (destination.hasOwnProperty(prop.@name)) {
								destination[prop.@name] = source[prop.@name];
							}
						}
					}
				}catch (err:Object) { }
			}
		}
	}
}