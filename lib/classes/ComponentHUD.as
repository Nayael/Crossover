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
		}
	
	////////////////////////
	// METHODS
	//
		
	
	////////////////////////
	// GETTERS & SETTERS
	//
		public function set heroHP(value:Number):void {
			var stepsNb:int = int(value * heroHP_MC.steps / 100),
				scale:Number = (value * heroHP_MC.steps / 100) - stepsNb,
				x:Number = 50,
				y:Number = 236;
			
			while (numChildren > 1) {
				removeChildAt(1);
			}
			
			for (var i:int = 0, step:HUDStep; i < stepsNb + 1; i++) {
				step = new HUDStep();
				step.x = x;
				step.y = y - (step.height * i);
				if (i == stepsNb) {
					step.y += step.height * (1 - scale);
					step.scaleY = scale;
				}
				addChild(step);
			}
		}
	}
}