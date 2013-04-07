package com.nayael.crossover.arenas 
{
	import com.entity.engine.Game;
	import com.entity.engine.Map;
	import com.nayael.crossover.characters.boss.Boss;
	import flash.display.Bitmap;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Abstract class for representing arenas
	 * @author Nayael
	 */
	public class Arena extends Map
	{
	////////////////////////
	// PROPERTIES
	//
		private static const TILE_SIZE:int = 40;
		protected var _boss:Boss;

	////////////////////////
	// CONSTRUCTOR
	//
		public function Arena(tilemap:Array) {
			obstacles = Vector.<int>([1, 2, 3, 4, 5, 6, 7, 8]);
			super(TILE_SIZE, tilemap);
		}
	
	////////////////////////
	// METHODS
	//
		override public function draw(game:Game):void {
			var maps:Array = [SonicMap],
				className:String = boss.name + 'Map',
				bmpDataClass:Class = getDefinitionByName(className) as Class,
				bmp:Bitmap = new Bitmap(new bmpDataClass());
			
			game.addChild(bmp);
			bmp.name = 'background';
			super.draw(game);
		}
		
		override public function destroy(game:Game):void {
			super.destroy(game);
			if (game.getChildByName('background')) {
				game.removeChild(game.getChildByName('background'));
			}
		}
	
	////////////////////////
	// GETTERS & SETTERS
	//
		public function get boss():Boss {
			return _boss;
		}
	}
}