package cn.edu.zju.labx.events
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.core.UserInputHandler;
	import cn.edu.zju.labx.objects.LabXObject;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	public class LabXObjectUserInputHandleTool
	{
		
		private var labXObject:LabXObject;
		
		/**
		 * To store the old Mouse X position;
		 */
	    public var oldMouseX:Number = -1;
	    /**
		 * To store the old Mouse y position;
		 */
	    public var oldMouseY:Number = -1;
	    
	    private var needReproduceRay:Boolean = false;
	    
		public function LabXObjectUserInputHandleTool(object:LabXObject)
		{
			this.labXObject = object;
		}
		
		public function handleUserInputEvent(event:Event):void
		{
			if(event is MouseEvent)
			{
				var mouseEvent:MouseEvent = event as MouseEvent;
				if (mouseEvent.type == MouseEvent.MOUSE_DOWN) {
					oldMouseX = mouseEvent.stageX;
					oldMouseY = mouseEvent.stageY;
				} else if (mouseEvent.type == MouseEvent.MOUSE_UP) {
					if(needReproduceRay && (oldMouseX != -1))
					{
						StageObjectsManager.getDefault.objectStateChanged(labXObject);
					}
					needReproduceRay = false;
					oldMouseX = -1;
					oldMouseY = -1;
				} else if ((mouseEvent.type == MouseEvent.MOUSE_MOVE) &&(oldMouseY != -1) && (oldMouseY != -1) && mouseEvent.buttonDown) {
					var xMove:Number = mouseEvent.stageX - oldMouseX;
					var yMove:Number = mouseEvent.stageY - oldMouseY;
					if ((Math.abs(xMove) < LabXConstant.X_MOVE_MIN) && (Math.abs(yMove) < LabXConstant.Z_MOVE_MIN))return;
					internalMove(xMove, yMove);
					oldMouseX = mouseEvent.stageX;
					oldMouseY = mouseEvent.stageY;
				}
			} else if (event is KeyboardEvent)
			{
				var keyBoradEvent:KeyboardEvent = event as KeyboardEvent;
				if(UserInputHandler.keyLeft || UserInputHandler.keyRight)
				{
					var xMoveKey:Number = LabXConstant.X_KEY_MOVE_MIN;
					if(UserInputHandler.keyLeft)xMoveKey = -xMoveKey;
					internalMove(xMoveKey, 0);
				} else if(UserInputHandler.keyForward || UserInputHandler.keyBackward)
				{
					var zMoveKey:Number = LabXConstant.Z_KEY_MOVE_MIN;
					if(UserInputHandler.keyForward)zMoveKey = -zMoveKey;
					internalMove(0, zMoveKey);
				} 
				if(event.type == KeyboardEvent.KEY_UP)StageObjectsManager.getDefault.objectStateChanged(this.labXObject);
			}
		}
		
		private function internalMove(xMove:Number, yMove:Number):void
		{
			if (StageObjectsManager.getDefault.mainView.camera.z > 0)
			{
				xMove = -xMove; //when camera is on the other side, x should reverse
				yMove = -yMove;
			}
//			if(Math.abs(xMove) > Math.abs(yMove))
//			{
//				labXObject.x += xMove;
//				StageObjectsManager.getDefault.addMessage("lens X move:"+xMove);
//			} else {
//				labXObject.z -= yMove;
//				StageObjectsManager.getDefault.addMessage("lens Z move:"+yMove);
//			}
			
			labXObject.x += xMove;
			StageObjectsManager.getDefault.addMessage("lens X move:"+xMove);
			labXObject.z -= yMove;
			StageObjectsManager.getDefault.addMessage("lens Z move:"+yMove);
			needReproduceRay = true;
		}
	    

	}
}