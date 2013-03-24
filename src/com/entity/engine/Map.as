package com.entity.engine 
{
	import com.entity.engine.utils.Utils;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	/**
	 * A class to build 2D maps
	 * @author Nayael
	 */
	public class Map
	{
	////////////////////////
	// PROPERTIES
	//
		protected var _tilemap:Vector.<Vector.<int>>;
		protected var _scrolling:Boolean = false;
		
		public var TS:int;	// The tile size
		public var sourceMC:MovieClip;
		public var obstacles:Vector.<int>;
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function Map(ts:int, tilemap:Array) {
			TS = ts;
			
			_tilemap = new Vector.<Vector.<int>>();
			for each (var item:* in tilemap) {
				if (!(item is Array)) {
					throw new Error('A map can only be build with a 2D array');
				}
				_tilemap.push(Vector.<int>(item));
			}
			_tilemap.fixed = true;
		}
	
	////////////////////////
	// METHODS
	//
		/**
		 * Draws the map on the scene
		 * @param	game The game instance to draw the map on
		 */
		public function draw(game:Game):void {
			if (sourceMC == null) {
				throw new Error('No source MovieClip to draw the map');
			}
			var tile:MovieClip,
				i:int = 0,
				j:int = 0;
			for each (var row:Vector.<int> in _tilemap) {
				i = 0;
				for each (var value:int in row) {
					if (value != 0) {
						tile = Utils.clone(sourceMC) as MovieClip;
						tile.gotoAndStop(value);
						tile.x = i * TS;
						tile.y = j * TS;
						tile.name = 'tile' + i + 'y' + j;
						game.addChild(tile);
					}
					i++;
				}
				j++;
			}
		}
		
		public function destroy(game:Game):void {
			var tile:DisplayObject,
				i:int = 0,
				j:int = 0;
			for each (var row:Vector.<int> in _tilemap) {
				i = 0;
				for each (var value:int in row) {
					if (value != 0) {
						tile = game.getChildByName('tile' + i + 'y' + j);
						if (tile && tile.stage) {
							game.removeChild(tile);
						}
					}
					i++;
				}
				j++;
			}
		}
	
	////////////////////////
	// GETTERS & SETTERS
	//
		public function get tilemap():Vector.<Vector.<int>> {
			return _tilemap;
		}
		
		public function get scrolling():Boolean {
			return _scrolling;
		}
	}
}