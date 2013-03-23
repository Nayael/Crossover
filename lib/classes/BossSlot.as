package classes
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Nayael
	 */
	public class BossSlot extends MovieClip
	{
	////////////////////////
	// PROPERTIES
	//
		public var bossName:String;
		private var _sprite:Bitmap;
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function BossSlot(name:String = '') {
			stop();
			var enemies:Array = [SonicBig, LinkBig, DonkeyKongBig];
			bossName = name;
			
			if (name.length == 0) {
				return;
			}
			
			var className:String = name + 'Big',
				bmpDataClass:Class = getDefinitionByName(className) as Class;
			
			_sprite = new Bitmap(new bmpDataClass());
			_sprite.x = 5;
			_sprite.y = 5;
			addChild(_sprite);
		}
	
	////////////////////////
	// METHODS
	//
		public function onEnter():void {
			this.gotoAndStop('hover');
		}
		
		public function onLeave():void {
			this.gotoAndStop('idle');
		}
	
	////////////////////////
	// GETTERS & SETTERS
	//
		
	}
}