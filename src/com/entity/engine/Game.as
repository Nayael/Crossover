package com.entity.engine  
{
	import com.entity.engine.*;
	import com.entity.engine.events.*;
	import com.entity.engine.fsm.StateMachine;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class Game extends Sprite
	{
		static private var _dt:Number;
		static private var _t:int;
		protected var _map:Map;
		
		public var entities:Vector.<Entity> = new Vector.<Entity>();
		
		// constructeur et init
		public function Game():void {
			//trace( "engine/game/construct" );
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			//trace( "engine/game/init" );
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			E.stage = this.stage;
			E.WIDTH = this.stage.stageWidth;
			E.HEIGHT = this.stage.stageHeight;
			E.original_framerate = this.stage.frameRate;
			
			EventBroker.subscribe( EntityEventType.DESTROYED, onEntityDestroyed );
			EventBroker.subscribe( EntityEventType.CREATED, onEntityCreated );
		}	
		
		// -- debut/fin
		protected function begin():void {
			_t = getTimer();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			// [override me] :D
		}
		
		protected function end():void {
			var entitiesCollection:Vector.<Entity> = entities.concat();	// Making a copy of the entities vector, so that we can delete them in the loop without trouble
			for each (var entity:Entity in entitiesCollection) {
				if (entity.view)
					removeChild(entity.view.sprite);
				entity.destroy();
			}
			entities.length = 0;
		}
		
		// -- boucle d'affichage		
		protected function onEnterFrame(event:Event):void {
			var t:int = getTimer();
			_dt = (t - _t);
			_t = t;
			update();
		}				
		
		protected function update():void {
			for each (var entity:Entity in entities) {
				entity.update();
				entity.draw();
			}
		}
		
		// -- gestion de toutes les entites
		protected function addEntity(entity:Entity):Entity {
			//trace( "engine/game/addEntity", entity );
			entities.push(entity);
			if (entity.view) {
				addChild(entity.view.sprite);
			}
			entity.game = this;
			return entity;
		}
		
		protected function onEntityCreated(e:EntityEvent): void {
			//trace( "engine/game/onEntityCreated", e.entity );
			addEntity( e.entity );
		}
		
		protected function onEntityDestroyed(e:EntityEvent):void {
			//trace( "engine/game/onEntityDestroyed", e.entity );
			
			if (e.entity && e.entity.view) {
				if (e.entity.view.sprite.stage) {
					removeChild(e.entity.view.sprite);
				}
			}
			var idx:int = entities.indexOf(e.entity);
			if ( idx > -1 ) {
				entities.splice( idx , 1);
			}			 
		}
		
		public function get map():Map {
			return _map;
		}
		
		static public function get dt():Number {
			return _dt;
		}
		
		static public function get t():int {
			return _t;
		}
	}
}