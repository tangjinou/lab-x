package cn.edu.zju.labx.objects
{   
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.core.UserInputHandler;
	import cn.edu.zju.labx.events.IRayHandle;
	import cn.edu.zju.labx.events.IUserInputListener;
	import cn.edu.zju.labx.logicObject.LensLogic;
	import cn.edu.zju.labx.logicObject.LineRayLogic;
	import cn.edu.zju.labx.utils.MathUtils;
	
	import com.greensock.*;
	
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.core.geom.TriangleMesh3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Plane3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.core.utils.MeshUtil;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.view.layer.ViewportLayer;
	
	public class Lens extends LabXObject implements IUserInputListener, IRayHandle
	{   
		private var _focus:Number = LabXConstant.LENS_DEFAULT_FOCAL_LENGTH;
		
		
		protected var lensPart1:TriangleMesh3D;
	    protected var lensPart2:TriangleMesh3D;
	    protected var lens:TriangleMesh3D;
	    
	    public var width:Number =120;
	    public var height:Number=120;
	    
	    private var LENS_DAE_URL:String;
   
		/**
		 * To store the old Mouse X position;
		 */
	    public var oldMouseX:Number = -1;
	    /**
		 * To store the old Mouse y position;
		 */
	    public var oldMouseY:Number = -1;
	    
		public function Lens(material:MaterialObject3D=null, focus:Number=LabXConstant.LENS_DEFAULT_FOCAL_LENGTH)
		{
			super(material);
			createChildren();
			addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
			this._focus = focus;
		}
		public function createChildren():void{
			var radius:Number = 100;
			var shift:Number = Math.sqrt(radius*radius - height*height/4);
		   	var sp:Sphere = new Sphere(this.material, radius, 24, 12);
		   	var normal:Number3D = new Number3D(radius,0,0); 
			var point:Number3D = new Number3D(shift,0,0); 
		   	var cutPlane:Plane3D = Plane3D.fromNormalAndPoint(normal, point);
		   	var meshes:Array = MeshUtil.cutTriangleMesh(sp, cutPlane);
		   	lensPart1 = meshes[0];
		 	lensPart1.moveLeft(shift);
		   	normal.x = -radius;
		   	point.x = -shift;
		   	var meshes2:Array = MeshUtil.cutTriangleMesh(meshes[1], cutPlane);
		   	lensPart2 = meshes2[0];
		   	lensPart2.moveRight(shift);
		   	lens = new TriangleMesh3D(null, null, null);
		   	lens.addChild(lensPart1);
		   	lens.addChild(lensPart2);
		   	this.addChild(lens);
		   	var effectLayer:ViewportLayer = new ViewportLayer(StageObjectsManager.getDefault.mainView.viewport, null);
			effectLayer.addDisplayObject3D(sp, true);
//			effectLayer.alpha = 0.7;
			effectLayer.blendMode = BlendMode.HARDLIGHT;
			StageObjectsManager.getDefault.layerManager.equipmentLayer.addLayer(effectLayer);
            sp.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
		}
		
		public function set lens_dae_url(url:String):void{
		     this.LENS_DAE_URL =url;
		}

		
		private function makeAnNewRay(oldRay:Ray):Ray
		{
			if(oldRay != null)
			{
				oldRay.EndX = this.x;
				var lensLogic:LensLogic = new LensLogic(getPosition(), getNormal(), this._focus);
				var newLineRays:ArrayCollection = new ArrayCollection();
				for each (var oldLineRay:LineRay in oldRay.getLineRays())
				{
					var resultLogic:LineRayLogic = lensLogic.processRay(oldLineRay.logic);
					if (isRayOnLens(resultLogic))newLineRays.addItem(new LineRay(resultLogic));
				}
				oldRay = null;
				return  new Ray(null, newLineRays, 0, 0);
			}
			return null;
		}
		
		private function isRayOnLens(ray:LineRayLogic):Boolean
		{
			if (ray == null) return false;
			if (Math.abs(ray.dx) < LabXConstant.NUMBER_PRECISION) return false;
       	 	var x:Number = this.x;
        	var y:Number = (this.x-ray.x)*ray.dy/ray.dx + ray.y;
        	if (Math.abs(this.y - y) < this.height/2) return true;
        	return false;
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
	    
	    // should destribute the listener 
        override public function addEventListener(type:String, listener:Function,useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{   
			lens.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		
		   		
    	
	    protected function daeFileOnloaded(evt:FileLoadEvent):void{  
	    	this.addChild(lens);  
//	        trace("beigin~~~~~~~~~~~~~");
//			trace(lens.childrenList());
//			trace("end~~~~~~~~~~~~~");
//			this.useOwnContainer = true;
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
   		    this._ray = makeAnNewRay(oldRay);
			if(this._ray != null)
			{
				StageObjectsManager.getDefault.originPivot.addChild(this._ray);
				this._ray.displayRays();
				StageObjectsManager.getDefault.rayManager.notify(_ray);
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
    	       return MathUtils.distanceToNumber3D(getPosition(),lineRay.start_point);;
    	    }
    	    return -1;
    	}
    	
   		 /**
   		 *   judge the ray if is on the object
   		 */ 
    	public function isOnTheRay(ray:Ray):Boolean{
    		
    	    if(ray!=null && ray.getLineRays()!=null && ray.getLineRays().length>0){
			   var lineRay:LineRay = ray.getLineRays().getItemAt(0) as LineRay;
	           if(lineRay != null)return isLineRayOnObject(lineRay.logic);
	           return false;
			}
    	   return false;
    	}

		
	}
}