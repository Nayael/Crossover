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
	public class Text extends TextField {
		
	////////////////////////
	// PROPERTIES
	//
		[Embed(source="../../../../../lib/fonts/PressStart2P.ttf", fontName="PressStart2P", fontFamily="Press Start 2P", mimeType='application/x-font-truetype', advancedAntiAliasing="true", embedAsCFF="false")]
		private var pressStartFont:Class;
		
		public var textFormat:TextFormat;
		
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
			textFormat = new TextFormat(font, size, color, bold, italic);
			
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
				this.x = (pParent.stageWidth >> 1) - (this.width >> 1);
			} else {
				this.x = (pParent.width >> 1) - (this.width >> 1);
			}
		}
		
		/**
		 * Centers the object on the Y axis
		 * @param	pParent	The object to center to
		 */
		public function vCenter(pParent:*):void {
			if (pParent is Stage) {
				this.y = (pParent.stageHeight >> 1) - (this.height >> 1);
			} else {
				this.y = (pParent.height >> 1) - (this.height >> 1);
			}
		}
		
		/**
		 * Refreshes the text format
		 */
		public function refresh():void {
			this.setTextFormat(this.textFormat);
		}
		
		/**
		 * Removes the object from the stage
		 */
		public function remove():void {
			this.parent.removeChild(this);
		}
		
		public function set color(value:Object):void {
			textFormat.color = value;
			refresh();
		}
		
		public function set size(value:int):void {
			textFormat.size = value;
			refresh();
		}
		
		public function set bold(value:Boolean):void {
			textFormat.bold = value;
			refresh();
		}
		
		public function set italic(value:Boolean):void {
			textFormat.italic = value;
			refresh();
		}
		
		public function set font(value:String):void {
			textFormat.font = value;
			refresh();
		}
	}
}