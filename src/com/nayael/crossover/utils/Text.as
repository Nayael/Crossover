package com.nayael.crossover.utils
{
	import flash.display.Stage;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * A label text field
	 * @author Nayael
	 */
	public class Text extends TextField{
		
	////////////////////////
	// PROPERTIES
	//
		[Embed(source="../../../../../lib/fonts/PressStart2P.ttf", fontName="PressStart2P", fontFamily="Press Start 2P", mimeType='application/x-font-truetype', advancedAntiAliasing="true", embedAsCFF="false")]
		private var pressStartFont:Class;
		
	////////////////////////
	// CONSTRUCTOR
	//
		/** [Constructor]
		 * A label text field
		 * @param	initText The text to display
		 * @param	font 	 The text font
		 * @param	size 	 The text size
		 * @param	color 	 The text color
		 * @param	bold 	 Will the font be bold ?
		 * @param	italic 	 Will the font be italic ?
		 */
		public function Text(initText:String, font:String = 'Arial', size:int = 24, color:Object = 0xFFFFFF, bold:Boolean = false, italic:Boolean = false) {
			super();
			
			this.text = initText;
			var textFormat:TextFormat = new TextFormat(font, size, color, bold, italic);
			
			textFormat.align = TextFormatAlign.LEFT;
			this.embedFonts = true;
			this.autoSize = TextFieldAutoSize.LEFT;
			this.antiAliasType = AntiAliasType.ADVANCED;
			this.setTextFormat(textFormat);
			this.selectable = false;
		}
		
	////////////////////////
	// METHODS
	//
		/**
		 * Positions the object on the stage
		 * @param	xPos	The position on the X axis 
		 * @param	yPos	The position on the Y axis
		 */ 
		public function pos(xPos:Number, yPos:Number):void {
			this.x = xPos;
			this.y = yPos;
		}
		
		/**
		 * Centers the object on the X axis
		 * @param	pParent	The object to center to
		 */
		public function hCenter(pParent:*):void {
			if (pParent is Stage) {
				this.x = pParent.stageWidth / 2 - this.width / 2;
			} else {
				this.x = pParent.width / 2 - this.width / 2;
			}
		}
		
		/**
		 * Centers the object on the Y axis
		 * @param	pParent	The object to center to
		 */
		public function vCenter(pParent:*):void {
			if (pParent is Stage) {
				this.y = pParent.stageHeight / 2 - this.height / 2;
			} else {
				this.y = pParent.height / 2 - this.height / 2;
			}
		}
		
		/**
		 * Removes the object from the stage
		 */
		public function remove():void {
			this.parent.removeChild(this);
		}
	}
}