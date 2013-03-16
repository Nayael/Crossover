package engine  
{
	public interface IEntity 
	{
		// ACTIONS
		function destroy():void;
		function update():void;
		function draw():void;
		
		// COMPONENTS
		function get body():Body;
		function set body(value:Body):void;
		function get physics():Physics; 
		function set physics(value:Physics):void 
		function get health():Health 
		function set health(value:Health):void
		function get weapon():Weapon; 
		function set weapon(value:Weapon):void;
		function get view():View; 
		function set view(value:View):void; 
		
		// OTHER
		function get targets():Vector.<Entity>; 
		function set targets(value:Vector.<Entity>):void;
		function get group():Vector.<Entity>; 
		function set group(value:Vector.<Entity>):void; 
	}
	
}