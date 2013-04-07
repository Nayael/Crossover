package classes
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * HUD class
	 * @author Nayael
	 */
	public class ComponentHUD extends Sprite
	{
	////////////////////////
	// PROPERTIES
	//
		
	
	////////////////////////
	// CONSTRUCTOR
	//
		public function ComponentHUD() {
			heroHP_MC.steps = 17;
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