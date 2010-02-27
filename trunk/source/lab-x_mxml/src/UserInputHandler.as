package {
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	public class UserInputHandler 
	{	
		public static var keyRight:Boolean;
		public static var keyLeft:Boolean;
		public static var keyForward:Boolean;
		public static var keyBackward:Boolean;
		public static var mouseDown:Boolean;
		public static var camMode:String;
		public static var randomCamActive:Boolean;
		
		public function UserInputHandler(stage:Stage)
		{
//			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
//			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
//			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
//			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		private function keyDownHandler(e:KeyboardEvent):void
		{	
			switch(e.keyCode)
			{
				case "W".charCodeAt():
				case Keyboard.UP:
					UserInputHandler.keyForward = true;
					UserInputHandler.keyBackward = false;
					break;
 
				case "S".charCodeAt():
				case Keyboard.DOWN:
					UserInputHandler.keyBackward = true;
					UserInputHandler.keyForward = false;
					break;
 
				case "A".charCodeAt():
				case Keyboard.LEFT:
					UserInputHandler.keyLeft = true;
					UserInputHandler.keyRight = false;
					break;
 
				case "D".charCodeAt():
				case Keyboard.RIGHT:
					UserInputHandler.keyRight = true;
					UserInputHandler.keyLeft = false;
					break;
					
			}
		}
 
		private function keyUpHandler(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case "W".charCodeAt():
				case Keyboard.UP:
					keyForward = false;
					break;
 
				case "S".charCodeAt():
				case Keyboard.DOWN:
					keyBackward = false;
					break;
 
				case "A".charCodeAt():
				case Keyboard.LEFT:
					keyLeft = false;
					break;
 
				case "D".charCodeAt():
				case Keyboard.RIGHT:
 
					keyRight = false;
					break;
					
			}
		}
		
		private function mouseDownHandler (e:MouseEvent):void
		{
			mouseDown = true;
		}
		
		private function mouseUpHandler (e:MouseEvent):void
		{
			mouseDown = false;
		}
		
	}
}