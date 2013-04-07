package com.entity.engine
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class View
	{
		private var _blinkTimer:Timer = new Timer(1, 1);
		
		public var entity:Entity;
		public var sprite:Sprite;
		public var scale:Number = 1;
		public var alpha:Number = 1;
		
		public function View(entity:Entity) {
			this.entity = entity;
			sprite = new Sprite();
		}
		
		public function draw():void {
			sprite.x = entity.body.x;
			sprite.y = entity.body.y;
			sprite.alpha = alpha;
			sprite.scaleX = sprite.scaleY = scale;
			
			if (entity.physics.vX < 0) {
				sprite.scaleX *= -1;
			} else if (entity.physics.vX > 0) {
				sprite.scaleX *= 1;
			} else {
				sprite.scaleX *= entity.body.left ? -1 : 1;
			}
		}
		
		public function blink(delay:int, repeatCount:int = 0):void {
			if (_blinkTimer.running) {
				return;
			}
			_blinkTimer = new Timer(delay, repeatCount);
			_blinkTimer.addEventListener(TimerEvent.TIMER, _onBlinkTimer);
			_blinkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, _onBlinkComplete);
			_blinkTimer.start();
		}
		
		public function stopBlink():void {
			entity.view.sprite.visible = true;
			if (!_blinkTimer.running) {
				return;
			}
			_blinkTimer.stop();
			_blinkTimer.removeEventListener(TimerEvent.TIMER, _onBlinkTimer);
			_blinkTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, _onBlinkComplete);
		}
		
		private function _onBlinkTimer(e:TimerEvent):void {
			entity.view.sprite.visible = !entity.view.sprite.visible;
		}
		
		private function _onBlinkComplete(e:TimerEvent):void {
			entity.view.sprite.visible = true;
			_blinkTimer.removeEventListener(TimerEvent.TIMER, _onBlinkTimer);
			_blinkTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, _onBlinkComplete);
			
		}
	}
}