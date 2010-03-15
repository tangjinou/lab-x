package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.core.UserInputHandler;
	import cn.edu.zju.labx.events.IRayMaker;
	import cn.edu.zju.labx.events.IUserInputListener;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;

	public class SplitterBeam extends LabXObject implements IUserInputListener
	{   
		
	    public var height:int;
	    public var width:int;
	    public var depth:int;
		
		private var splitterBeam:Cube;
		
		/**
		 * To store the old Mouse X position;
		 */
	    public var oldMouseX:Number = -1;
		
		public function SplitterBeam(material:MaterialObject3D, vertices:Array=null, faces:Array=null, name:String=null)
		{
			super(material, vertices, faces, name);
			createDisplayObject();
			addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
		}
		

		
		private function makeAnNewRay(rayMaker:IRayMaker):Ray
		{
			var oldRay:Ray = rayMaker.getRay();
			if(oldRay != null)
			{
				oldRay.EndX = this.x;
//				var lensLogic:LensLogic = new LensLogic(new Number3D(this.x, this.y, this.z), this._focus);
				var newLineRays:ArrayCollection = new ArrayCollection();
				for each (var oldLineRay:LineRay in oldRay.getLineRays())
				{
//					var resultLogic:RayLogic = lensLogic.calculateRayAfterLens(oldLineRay.logic);
//					if (isRayOnLens(resultLogic))newLineRays.addItem(new LineRay(resultLogic));
				}
				return  new Ray(null, newLineRays, 0, 0);
			}
			return null;
		}
		
		public function hanleUserInputEvent(event:Event):void{
			if(userInputHandle!=null){
	   	       userInputHandle.call(this,event);
	   	       return;
	   	    }
	   	    if(event is MouseEvent)
	   	    {
	   	   	     var mouseEvent:MouseEvent = event as MouseEvent;
	   	    	 if (mouseEvent.type == MouseEvent.MOUSE_DOWN) {
	   	    	 	oldMouseX = mouseEvent.stageX;
	   	    	 } else if (mouseEvent.type == MouseEvent.MOUSE_UP) {
	   	    	 	oldMouseX = -1;
	   	    	 } else if ((mouseEvent.type == MouseEvent.MOUSE_MOVE) && (oldMouseX != -1) && mouseEvent.buttonDown) {
	   	    	 	var xMove:Number = mouseEvent.stageX - oldMouseX;
	   	    	 	if (Math.abs(xMove) < 10)return;
	   	    	 	internalMove(xMove);
       	 			oldMouseX = mouseEvent.stageX;
	   	    	 }
	    	} else if (event is KeyboardEvent)
	    	{
	    		var keyBoradEvent:KeyboardEvent = event as KeyboardEvent;
	    		if(UserInputHandler.keyLeft || UserInputHandler.keyRight)
	    		{
	    			var xMoveKey:Number = LabXConstant.X_MOVE_MIN;
	    			if(UserInputHandler.keyLeft)xMoveKey = -xMoveKey;
	    			internalMove(xMoveKey);
	    		} 
	    	}
		  
		}
	    private function internalMove(xMove:Number):void
	    {
	    	if (StageObjectsManager.getDefault.mainView.camera.z > 0)xMove = -xMove; //when camera is on the other side, x should reverse
       	 	this.x += xMove;
       	 	StageObjectsManager.getDefault.addMessage("SplitterBeam move:"+xMove);
	    }
		
		
		public function createDisplayObject():void{
		    var materialsList:MaterialsList = new MaterialsList();
			materialsList.addMaterial(material,"front");
			materialsList.addMaterial(material,"back");
			materialsList.addMaterial(material,"left");
			materialsList.addMaterial(material,"right");
			materialsList.addMaterial(material,"top");
			materialsList.addMaterial(material,"bottom");
            height=120;
	        width=3;
	        depth=100;
		   	splitterBeam = new Cube(materialsList,width,depth,height);
		   	this.addChild(splitterBeam);
		}
	    
	    // should destribute the listener 
        override public function addEventListener(type:String, listener:Function,useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{   
			splitterBeam.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
	}
}