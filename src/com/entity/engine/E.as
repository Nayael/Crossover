package com.entity.engine
{
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class E
	{
		public static var point0:Point = new Point;
		public static var rect0:Rectangle = new Rectangle;
		public static var mtx0:Matrix = new Matrix;
		public static var original_framerate:int = 48;
		public static var stage:Stage = null;
		public static var WIDTH:int;
		public static var HEIGHT:int;
		
		
		public function E(){}
		
		// -- MATH HELPER
		// utiliser une approx de PI ?
		public static function degreesToRadians(degrees:Number):Number {
			return (degrees * Math.PI / 180);
		}
		
		public static function radiansToDegrees(radians:Number):Number {
			return radians * 180 / Math.PI;
		}
		
		//angle en rad
		public static function getAngleBetweenPoints(p1:Point, p2:Point):Number {
			var dx:Number = p1.x - p2.x;
			var dy:Number = p1.y - p2.y;
			var radians:Number = Math.atan2(dy, dx);
			
			return radians;
		}
		
		public static function distanceBetweenPoints(p1:Point, p2:Point):Number {
			return Point.distance(p1, p2);
		}
		
		// -- Divers
		public static function clone(source:*):Object {
			var copier:ByteArray = new ByteArray();
			copier.writeObject(source as Object);
			copier.position = 0;
			
			return copier.readObject();
		}
		
		public static function flashvar(nom:String, valeurParDefautSiInconnu:*):* {
			var result:* = valeurParDefautSiInconnu;
			
			if (E.stage.loaderInfo.parameters[nom] != undefined) {
				if (valeurParDefautSiInconnu is Number) {
					result = Number(E.stage.loaderInfo.parameters[nom]);
				} else {
					result = E.stage.loaderInfo.parameters[nom];
				}
			}
			
			return result;
		}
		
		// addChild( E.setProps( new Sprite(), {x:200, y:200, alpha:0.5, name:"bob"}) );
		public static function setProps(o:Object, props:Object):* {
			for (var n:String in props) {
				o[n] = props[n];
			}
			
			return o;
		}
		
		public static function shuffle(a:Array):void {
			for (var i:int = a.length - 1; i > 0; --i) {
				var p:int = int(Math.random() * (i + 1));
				if (p == i)
					continue;
				var tmp:Object = a[i];
				a[i] = a[p];
				a[p] = tmp;
			}
		}
	}
}