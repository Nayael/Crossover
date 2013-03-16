package engine  
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;	
	import engine.*;
	import engine.events.*;
	
	public class Game extends Sprite
	{
		public var entities:Vector.<Entity> = new Vector.<Entity>();
		public var isPaused:Boolean;
		
		// constructeur et init
		public function Game():void
		{
			ET.console.addMessage( "engine/game/construct" );
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			ET.console.addMessage( "engine/game/init" );
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			ET.stage = this.stage;
			ET.WIDTH = this.stage.stageWidth;
			ET.HEIGHT = this.stage.stageHeight;
			ET.original_framerate = this.stage.frameRate;
			
			isPaused  = false;
			
			EventBroker.subscribe( EntityEventType.DESTROYED, onEntityDestroyed );
			EventBroker.subscribe( EntityEventType.CREATED, onEntityCreated );
		}	
		
		// -- debut/fin
		protected function begin():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			ET.console.addMessage( "engine/game/begin" );
			// [override me] :D
		}
		
		protected function end():void
		{
			ET.console.addMessage( "engine/game/end" );
			for each (var entity:Entity in entities)
			{
				if (entity.view)
					removeChild(entity.view.sprite);
			}
			entities.length = 0;
		}
		
		// -- boucle d'affichage		
		protected function onEnterFrame(event:Event):void
		{
			if (isPaused)
				return;
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
			ET.console.addMessage( "engine/game/addEntity", entity );
			entities.push(entity);
			if (entity.view)
				addChild(entity.view.sprite);
				
			return entity;
		}
		
		protected function onEntityCreated(e:EntityEvent):void
		{
			ET.console.addMessage( "engine/game/onEntityCreated", e.entity );
			addEntity( e.entity );			
		}
		
		protected function onEntityDestroyed(e:EntityEvent):void
		{
			trace("engine/game/onEntityDestroyed", e.entity);
			var idx:int = entities.indexOf(e.entity);
			if ( idx > -1 ) {
				entities.splice( idx , 1);
			}			
			if (e.entity.view)
				removeChild(e.entity.view.sprite);
		}		
	
	}

}