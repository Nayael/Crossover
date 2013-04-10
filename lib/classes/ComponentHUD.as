package classes
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	
	/**
	 * HUD class
	 * @author Nayael
	 */
	public class ComponentHUD extends Sprite
	{
	////////////////////////
	// PROPERTIES
	//
		private var ammoColor:String;
		private var maxAmmo:int;
		
		private var stepsColors:Array = [HUDStep, BlueHUDStep, YellowHUDStep, RedHUDStep];
		private var heroAmmoColors:Array = [BlueHeroAmmo, YellowHeroAmmo, RedHeroAmmo];
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function ComponentHUD() {
			heroHP_MC.steps = 17;
			heroAmmo_MC.steps = 33;
			bossHP_MC.steps = 33;
		}
	
	////////////////////////
	// METHODS
	//
		public function hideBossHUD():void {
			bossHP_MC.visible = false;
		}
		
		public function showBossHUD():void {
			bossHP_MC.visible = true;
		}
		
		public function showHeroAmmo(maxAmmo:int = 0, color:String = ''):void {
			if (maxAmmo == 0) {
				hideHeroAmmo();
				return;
			}
			this.ammoColor = color;
			this.maxAmmo = maxAmmo;
			heroAmmo_MC.addChildAt(new Bitmap( new (getDefinitionByName(color + 'HeroAmmo') as Class) ), 0);
			heroAmmo_MC.visible = true;
		}
		
		public function hideHeroAmmo():void {
			while (heroAmmo_MC.numChildren) {
				heroAmmo_MC.removeChildAt(0);
			}
			heroAmmo_MC.visible = false;
		}
	
	////////////////////////
	// GETTERS & SETTERS
	//
		/**
		 * Updates the hero's life bar
		 */
		public function set heroHP(value:Number):void {
			if (value < 0) {
				value = 0;
			}
			// First, we calculate the number of steps to display, plus the scale of the one on the top (steps have a fixed size by default)
			var stepsNb:int = int(value * heroHP_MC.steps / 100),
				scale:Number = (value * heroHP_MC.steps / 100) - stepsNb,
				x:Number = 5,
				y:Number = 73;
			
			while (heroHP_MC.numChildren > 1) {
				heroHP_MC.removeChildAt(1);
			}
			
			for (var i:int = 0, step:HUDStep; i < stepsNb + 1; i++) {
				step = new HUDStep();
				step.x = x;
				step.y = y - (step.height * i);
				if (i == stepsNb) { // Displaying the top step
					step.y += step.height * (1 - scale);
					step.scaleY = scale;
				}
				heroHP_MC.addChild(step);
			}
		}
		
		/**
		 * Updates the hero's life bar
		 */
		public function set heroAmmo(value:Number):void {
			if (value < 0) {
				value = 0;
			}
			// First, we calculate the number of steps to display, plus the scale of the one on the top (steps have a fixed size by default)
			var stepsNb:int = int(value * heroAmmo_MC.steps / maxAmmo),
				stepClass:Class = getDefinitionByName(ammoColor + 'HUDStep') as Class,
				scale:Number = (value * heroAmmo_MC.steps / maxAmmo) - stepsNb,
				x:Number = 5,
				y:Number = 135;
			
			while (heroAmmo_MC.numChildren > 1) {
				heroAmmo_MC.removeChildAt(1);
			}
			
			for (var i:int = 0, step:*; i < stepsNb + 1; i++) {
				step = new stepClass();
				step.x = x;
				step.y = y - (step.height * i);
				if (i == stepsNb) { // Displaying the top step
					step.y += step.height * (1 - scale);
					step.scaleY = scale;
				}
				heroAmmo_MC.addChild(step);
			}
		}
		
		/**
		 * Updates the hero's life bar
		 */
		public function set bossHP(value:Number):void {
			if (value < 0) {
				value = 0;
			}
			// First, we calculate the number of steps to display, plus the scale of the one on the top (steps have a fixed size by default)
			var stepsNb:int = int(value * bossHP_MC.steps / 100),
				scale:Number = (value * bossHP_MC.steps / 100) - stepsNb,
				x:Number = 4.6,
				y:Number = 134;
			
			while (bossHP_MC.numChildren > 1) {
				bossHP_MC.removeChildAt(1);
			}
			
			for (var i:int = 0, step:HUDStep; i < stepsNb + 1; i++) {
				step = new HUDStep();
				step.x = x;
				step.y = y - (step.height * i);
				if (i == stepsNb) { // Displaying the top step
					step.y += step.height * (1 - scale);
					step.scaleY = scale;
				}
				bossHP_MC.addChild(step);
			}
		}
	}
}