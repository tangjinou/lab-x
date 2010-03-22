package cn.edu.zju.labx.core{
	
	import cn.edu.zju.labx.events.IUserInputListener;
	import cn.edu.zju.labx.objects.LabXObject;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.controls.Button;
	
	import org.papervision3d.core.utils.virtualmouse.VirtualMouseMouseEvent;
	import org.papervision3d.events.InteractiveScene3DEvent;

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
		 *  This is hook for objectPress
		 */ 
	    public function objectPressHandlerHook(event:InteractiveScene3DEvent,labXObject:LabXObject):void{
	    	StageObjectsManager.getDefault.objectPressHandlerHook(event,labXObject);
	    }
	    
	    /**
	    *   This is hook for not press no the labx objects
	    */ 
	    public function objectUnPressHandlerHook():void{
	    	StageObjectsManager.getDefault.objectUnPressHandler();
	    }
	    
		
		/**
		 * **********************************************************************
		 * *************Mouse Handle Part    ************************************
		 * **********************************************************************
		 */
		private var _currentSelectedObject:IUserInputListener = null;
		private var selectedLabxObject:IUserInputListener = null;
		
		public function set currentSelectedObject(currentObject:IUserInputListener):void {
			this._currentSelectedObject = currentObject;
			if(selectedLabxObject != currentObject)
			{
				if(currentObject is LabXObject)
				{
					var selected:LabXObject = currentObject as LabXObject;
					StageObjectsManager.getDefault.addMessage("已经选中" + selected.name);
				}
			}
			selectedLabxObject = currentObject;
		}
		
		public function mouseDownHandler (e:MouseEvent):void
		{
			if (e is VirtualMouseMouseEvent)
			{   
				return;
			}
			if (this._currentSelectedObject != null && StageObjectsManager.getDefault.rotate_stage==false)
			{
				this._currentSelectedObject.hanleUserInputEvent(e);
				return;
			}
			if ((this._currentSelectedObject == null) && !(e.target is Button) )
			{
				if(selectedLabxObject is LabXObject)
				{
					var selected:LabXObject = selectedLabxObject as LabXObject;
					StageObjectsManager.getDefault.addMessage("取消选中" + selected.name);
				}
				selectedLabxObject = null;
				objectUnPressHandlerHook();
			}
		}
		
		public function mouseUpHandler (e:MouseEvent):void
		{
			if (e is VirtualMouseMouseEvent)
			{
				return;
			}
			if (this._currentSelectedObject != null  && !(e.target is Button))
			{
				this._currentSelectedObject.hanleUserInputEvent(e);
				this._currentSelectedObject = null;
			}else{
				StageObjectsManager.getDefault.isOrbiting=false;
			}
		}
		
		public function mouseMoveHandler (e:MouseEvent):void
		{
			if ((this._currentSelectedObject != null) && (!(e is VirtualMouseMouseEvent)) && e.buttonDown) {
				this._currentSelectedObject.hanleUserInputEvent(e);
			}
		}
		
		public function get currentSelectedObject():IUserInputListener{
		   return this._currentSelectedObject;
		}
		
		/**
		 * **********************************************************************
		 * *************KeyBoard Handle Part    ************************************
		 * **********************************************************************
		 */
		public function keyDownHandler(e:KeyboardEvent):void
		{	
			if (selectedLabxObject != null)
			{
				selectedLabxObject.hanleUserInputEvent(e);
			}
		}
 
		public function keyUpHandler(e:KeyboardEvent):void
		{
			if (selectedLabxObject != null)
			{
				selectedLabxObject.hanleUserInputEvent(e);
			}
		}
		
		
	}
}