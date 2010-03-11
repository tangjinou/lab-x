package cn.edu.zju.labx.core{
	
	import cn.edu.zju.labx.events.IUserInputListener;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import org.papervision3d.core.utils.virtualmouse.VirtualMouseMouseEvent;

	public class UserInputHandler 
	{	
		public static var keyRight:Boolean;
		public static var keyLeft:Boolean;
		public static var keyForward:Boolean;
		public static var keyBackward:Boolean;
//		public static var camMode:String;
//		public static var randomCamActive:Boolean;
		
		/**
		 * ***********************************************************************
		 * Sigleton Method to make sure there are only one UserInputHandler 
		 * in an application
		 * ***********************************************************************
		 */
		protected static var instance:UserInputHandler = null;
		public static function get getDefault():UserInputHandler
		{
			if (instance == null)
				instance = new UserInputHandler();
			return instance;
		}
		
		
		
		/**
		 * **********************************************************************
		 * *************Mouse Handle Part    ************************************
		 * **********************************************************************
		 */
		private var _currentSelectedObject:IUserInputListener = null;
		
		public function set currentSelectedObject(currentObject:IUserInputListener):void {
			this._currentSelectedObject = currentObject;
		}
		
		public function mouseDownHandler (e:MouseEvent):void
		{
			if (e is VirtualMouseMouseEvent)
			{
				return;
			}
			if (this._currentSelectedObject != null)
			{
				this._currentSelectedObject.hanleUserInputEvent(e);
			}
		}
		
		public function mouseUpHandler (e:MouseEvent):void
		{
			if (e is VirtualMouseMouseEvent)
			{
				return;
			}
			if (this._currentSelectedObject != null)
			{
				this._currentSelectedObject.hanleUserInputEvent(e);
				this._currentSelectedObject = null;
			}else{
				FirstExperimentApplication.isOrbiting=false;
			}
		}
		
		public function mouseMoveHandler (e:MouseEvent):void
		{
			if ((this._currentSelectedObject != null) && (!(e is VirtualMouseMouseEvent)) && e.buttonDown) {
				this._currentSelectedObject.hanleUserInputEvent(e);
			}
		}
		
		/**
		 * **********************************************************************
		 * *************KeyBoard Handle Part    ************************************
		 * **********************************************************************
		 */
		public function keyDownHandler(e:KeyboardEvent):void
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
 
		public function keyUpHandler(e:KeyboardEvent):void
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
		
		
	}
}