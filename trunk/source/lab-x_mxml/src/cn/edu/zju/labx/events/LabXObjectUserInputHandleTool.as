package cn.edu.zju.labx.events
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.objects.LabXObject;

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	public class LabXObjectUserInputHandleTool
	{

		private var labXObject:LabXObject;

		/**
		 * To store the old Mouse X position;
		 */
		public var oldMouseX:Number=-1;
		/**
		 * To store the old Mouse y position;
		 */
		public var oldMouseY:Number=-1;

		private var keyDownAccelerate:Number=0.5;

		private var needReproduceRay:Boolean=false;

		public function LabXObjectUserInputHandleTool(object:LabXObject)
		{
			this.labXObject=object;
		}

		public function handleUserInputEvent(event:Event):void
		{
			if (event is MouseEvent)
			{
				var mouseEvent:MouseEvent=event as MouseEvent;
				if (mouseEvent.type == MouseEvent.MOUSE_DOWN)
				{
					oldMouseX=mouseEvent.stageX;
					oldMouseY=mouseEvent.stageY;
				}
				else if (mouseEvent.type == MouseEvent.MOUSE_UP)
				{
					if (needReproduceRay && (oldMouseX != -1))
					{
						StageObjectsManager.getDefault.objectStateChanged(labXObject);
					}
					needReproduceRay=false;
					oldMouseX=-1;
					oldMouseY=-1;
				}
				else if ((mouseEvent.type == MouseEvent.MOUSE_MOVE) && (oldMouseY != -1) && (oldMouseY != -1) && mouseEvent.buttonDown)
				{
					var xMove:Number=mouseEvent.stageX - oldMouseX;
					var zMove:Number=mouseEvent.stageY - oldMouseY;
					if ((Math.abs(xMove) < LabXConstant.X_MOVE_MIN) && (Math.abs(zMove) < LabXConstant.Z_MOVE_MIN))
						return;
					labXObject.objectMove(xMove, 0, -zMove);
					needReproduceRay=true;
					oldMouseX=mouseEvent.stageX;
					oldMouseY=mouseEvent.stageY;
				}
			}
			else if (event is KeyboardEvent)
			{
				if ((event.type == KeyboardEvent.KEY_UP) && (keyDownAccelerate != 1))
				{
					StageObjectsManager.getDefault.objectStateChanged(this.labXObject);
					keyDownAccelerate=1;
					return;
				}

				var keyBoradEvent:KeyboardEvent=event as KeyboardEvent;
				switch (keyBoradEvent.keyCode)
				{

					case "W".charCodeAt():
					case Keyboard.UP:
						labXObject.objectMove(0, 0, LabXConstant.Z_KEY_MOVE_MIN * keyDownAccelerate);
						accelerateKeyPress();
						break;

					case "S".charCodeAt():
					case Keyboard.DOWN:
						labXObject.objectMove(0, 0, -LabXConstant.Z_KEY_MOVE_MIN * keyDownAccelerate);
						accelerateKeyPress();
						break;

					case "A".charCodeAt():
					case Keyboard.LEFT:
						labXObject.objectMove(-LabXConstant.X_KEY_MOVE_MIN * keyDownAccelerate, 0, 0);
						accelerateKeyPress();
						break;

					case "D".charCodeAt():
					case Keyboard.RIGHT:
						labXObject.objectMove(LabXConstant.X_KEY_MOVE_MIN * keyDownAccelerate, 0, 0);
						accelerateKeyPress();
						break;
					case Keyboard.PAGE_UP:
						labXObject.objectMove(0, LabXConstant.Y_KEY_MOVE_MIN * keyDownAccelerate, 0);
						accelerateKeyPress();
						break;
					case Keyboard.PAGE_DOWN:
						labXObject.objectMove(0, -LabXConstant.Y_KEY_MOVE_MIN * keyDownAccelerate, 0);
						accelerateKeyPress();
						break;
					case "Q".charCodeAt():
						labXObject.objectRotate(0, -LabXConstant.Y_KEY_ROTATE_MIN * keyDownAccelerate);
						accelerateKeyPress();
						break;
					case "E".charCodeAt():
						labXObject.objectRotate(0, LabXConstant.Y_KEY_ROTATE_MIN * keyDownAccelerate);
						accelerateKeyPress();
						break;
				}
			}
		}
		
		private function accelerateKeyPress():void
		{
				if (keyDownAccelerate < 10)
					keyDownAccelerate+=1;
		}
	}
}