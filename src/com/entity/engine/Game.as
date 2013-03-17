package com.entity.engine  
{
	import com.entity.engine.*;
	import com.entity.engine.events.*;
	import com.entity.engine.fsm.StateMachine;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	public class Game extends Sprite
	{
		public var entities:Vector.<Entity> = new Vector.<Entity>();
		
		// constructeur et init
		public function Game():void
		{
			E.console.addMessage( "engine/game/construct" );
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			E.console.addMessage( "engine/game/init" );
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			E.stage = this.stage;
			E.WIDTH = this.stage.stageWidth;
			E.HEIGHT = this.stage.stageHeight;
			E.original_framerate = this.stage.frameRate;
			
			EventBroker.subscribe( EntityEventType.DESTROYED, onEntityDestroyed );
			EventBroker.subscribe( EntityEventType.CREATED, onEntityCreated );
		}	
		
		// -- debut/fin
		protected function begin():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			E.console.addMessage( "engine/game/begin" );
			// [override me] :D
		}
		
		protected function end():void
		{
			E.console.addMessage( "engine/game/end" );
			for each (var entity:Entity in entities)
			{
				if (entity.view)
					removeChild(entity.view.sprite);
				entity.destroy();
			}
			entities.length = 0;
		}
		
		// -- boucle d'affichage		
		protected function onEnterFrame(event:Event):void
		{
			update();
		}				
		
		protected function update():void
		{
			for each (var entity:Entity in entities){
				entity.update();
				entity.draw();
			}
		}
		
		// -- gestion de toutes les entites
		protected function addEntity(entity:Entity):Entity
		{
			E.console.addMessage( "engine/game/addEntity", entity );
			entities.push(entity); 
			if (entity.view)
				addChild(entity.view.sprite);
				
			return entity;
		} 
		
		protected function onEntityCreated(e:EntityEvent): void
		{
			E.console.addMessage( "engine/game/onEntityCreated", e.entity );
			addEntity( e.entity );
		}
		
		protected function onEntityDestroyed(e:EntityEvent):void
		{
			E.console.addMessage( "engine/game/onEntityDestroyed", e.entity );
			
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
	
	}

}