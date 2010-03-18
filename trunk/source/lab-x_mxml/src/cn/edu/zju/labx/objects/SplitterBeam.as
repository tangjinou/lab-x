package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.core.UserInputHandler;
	import cn.edu.zju.labx.events.IRayHandle;
	import cn.edu.zju.labx.events.IUserInputListener;
	import cn.edu.zju.labx.logicObject.LineRayLogic;
	import cn.edu.zju.labx.logicObject.SplitterBeamLogic;
	import cn.edu.zju.labx.utils.MathUtils;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.display.BlendMode;
	
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.view.layer.ViewportLayer;
	
	public class SplitterBeam extends LabXObject implements IUserInputListener,IRayHandle
	{   
		
	    public var height:int;
	    public var width:int;
	    public var depth:int;
		
		private var splitterBeam:Cube;
		
		/**
		 * To store the old Mouse X position;
		 */
	    public var oldMouseX:Number = -1;
	    /**
		 * To store the old Mouse y position;
		 */
	    public var oldMouseY:Number = -1;
		
		public function SplitterBeam(material:MaterialObject3D, vertices:Array=null, faces:Array=null, name:String=null)
		{
			super(material, vertices, faces, name);
			createDisplayObject();
			addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
		}
		
		private function makeNewRay1(oldRay:Ray):Ray
		{
			if(oldRay != null)
			{
				oldRay.EndX = this.x;
//				var lensLogic:LensLogic = new LensLogic(new Number3D(this.x, this.y, this.z), this._focus);
				var newLineRays:ArrayCollection = new ArrayCollection();
				for each (var oldLineRay:LineRay in oldRay.getLineRays())
				{   
					var beamLogic:SplitterBeamLogic =new SplitterBeamLogic(new Number3D(this.x,this.y,this.z),new Number3D(this.transform.n11,this.transform.n12,this.transform.n13));
                    newLineRays.addItem(beamLogic.calculateRayAfterSplit(oldLineRay));
				}
				return  new Ray(null, newLineRays, 0, 0);
			}
			return null;
		}
		
		protected function makeNewRay2(oldRay:Ray):Ray{
		   	if(oldRay != null)
			{
		     	var newLineRays:ArrayCollection = new ArrayCollection();
				for each (var oldLineRay:LineRay in oldRay.getLineRays())
				{   
					var lineRayLogic:LineRayLogic = new LineRayLogic(oldLineRay.end_point.clone(),oldLineRay.normal);
                    newLineRays.addItem(new LineRay(lineRayLogic));
				}
				return  new Ray(null,newLineRays,0,0);
		    }
		    return  null
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
					oldMouseY = mouseEvent.stageY;
				} else if (mouseEvent.type == MouseEvent.MOUSE_UP) {
					oldMouseX = -1;
					oldMouseY = -1;
					StageObjectsManager.getDefault.rayManager.reProduceRays();
				} else if ((mouseEvent.type == MouseEvent.MOUSE_MOVE) &&(oldMouseY != -1) && (oldMouseY != -1) && mouseEvent.buttonDown) {
					var xMove:Number = mouseEvent.stageX - oldMouseX;
					var yMove:Number = mouseEvent.stageY - oldMouseY;
					if ((Math.abs(xMove) < 10) && (Math.abs(yMove) < 10))return;
					internalMove(xMove, yMove);
					oldMouseX = mouseEvent.stageX;
					oldMouseY = mouseEvent.stageY;
				}
			} else if (event is KeyboardEvent)
			{
				var keyBoradEvent:KeyboardEvent = event as KeyboardEvent;
				if(UserInputHandler.keyLeft || UserInputHandler.keyRight)
				{
					var xMoveKey:Number = LabXConstant.X_MOVE_MIN;
					if(UserInputHandler.keyLeft)xMoveKey = -xMoveKey;
					internalMove(xMoveKey, 0);
				} 
			}
		
		}
	    
		private function internalMove(xMove:Number, yMove:Number):void
		{
			if (StageObjectsManager.getDefault.mainView.camera.z > 0)
			{
				xMove = -xMove; //when camera is on the other side, x should reverse
				yMove = -yMove;
			}
			if(Math.abs(xMove) > Math.abs(yMove))
			{
				this.x += xMove;
			} else {
				this.z -= yMove;
			}
			StageObjectsManager.getDefault.addMessage("lens move:"+xMove);
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
		   	
		   	var effectLayer:ViewportLayer = new ViewportLayer(StageObjectsManager.getDefault.mainView.viewport, null);
			effectLayer.addDisplayObject3D(splitterBeam, true);
			effectLayer.blendMode = BlendMode.HARDLIGHT;
			StageObjectsManager.getDefault.layerManager.equipmentLayer.addLayer(effectLayer);

		   	
		   	this.addChild(splitterBeam);
		}
	    
	    // should destribute the listener 
        override public function addEventListener(type:String, listener:Function,useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{   
			splitterBeam.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
	     /************************************************************
		 * 
		 *  This is implement of IRayHandle
		 * 
		 ************************************************************/ 
		 
		 /**
		 *  deal with when the ray on the object
		 **/ 
   		public function onRayHanle(oldRay:Ray):void{
   		    this._ray = makeNewRay1(oldRay);
   		    var ray2:Ray = makeNewRay2(oldRay);
			if(this._ray != null)
			{
				StageObjectsManager.getDefault.originPivot.addChild(this._ray);
				this._ray.displayRays();
				StageObjectsManager.getDefault.rayManager.notify(_ray);
			}
			if(ray2!=null){
			    StageObjectsManager.getDefault.originPivot.addChild(ray2);
				ray2.displayRays();
				StageObjectsManager.getDefault.rayManager.notify(ray2);
			}
   		}
   		
    	/**
    	 *   get the distance between  the object's centrol point and the ray's start point 
    	 * 
    	 *   if return -1 means that the distance is infinite
    	 * 
   		 **/
    	public function getDistance(ray:Ray):Number{
    		if(ray.getLineRays().length>0){
			   var lineRay:LineRay = ray.getLineRays().getItemAt(0) as LineRay;
    	       return MathUtils.distanceToNumber3D(new Number3D(this.x,this.y,this.z),lineRay.start_point);;
    	    }
    	    return -1;
    	}
    	
   		 /**
   		 *   judge the ray if is on the object
   		 */ 
    	public function isOnTheRay(ray:Ray):Boolean{
    		
    	    if(ray!=null && ray.getLineRays()!=null && ray.getLineRays().length>0){
			   var lineRay:LineRay = ray.getLineRays().getItemAt(0) as LineRay;
	           return isLineRayOnObject(lineRay.logic);
			}
    	   return false;
    	}

	}
}