package engine
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Weapon
	{
        public var entity:Entity;
        public var ammo:int = 99;
        
		private var _maxAmmo:int = 99;
		private var _canShoot:Boolean = true;
		
		public function Weapon(entity:Entity) {
			entity = entity;
			ammo = _maxAmmo;
		}
		
		public function Weapon(entity:Entity, cooldown:Number) {
			entity = entity;
			ammo = _maxAmmo;
		}
		
		public function fire():void {
			if (ammo >= 0 && _canShoot) {
				ammo--;
				_canShoot = false;
				var cooldownTimer:Timer = new Timer(500, 1);
				cooldownTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onCooldownTimer);
				cooldownTimer.start();
				
				function onCooldownTimer(e:TimerEvent):void {
					cooldownTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onCooldownTimer);
					_canShoot = true;
				}
			}
		}
		
		/*public function onHoldfireTimer(e:TimerEvent):void {
			// Incrementing the ammo on each loop
			if (ammo < _maxAmmo) {
				ammo++;
				return;
			}
			// Stop the timer when the max is reached
			holdfireTimer.removeEventListener(TimerEvent.TIMER, onHoldfireTimer);
			holdfireTimer.stop();
		}*/
		
		public function get canShoot():Boolean {
			return _canShoot;
		}
	}
}