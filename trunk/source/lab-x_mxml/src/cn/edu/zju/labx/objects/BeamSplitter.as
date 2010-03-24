package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.events.IRayHandle;
	import cn.edu.zju.labx.events.IUserInputListener;
	import cn.edu.zju.labx.events.LabXObjectUserInputHandleTool;
	import cn.edu.zju.labx.logicObject.LineRayLogic;
	import cn.edu.zju.labx.logicObject.SplitterBeamLogic;
	import cn.edu.zju.labx.utils.MathUtils;
	
	import flash.display.BlendMode;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.core.geom.TriangleMesh3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.view.layer.ViewportLayer;
	
	public class BeamSplitter extends LabXObject implements IUserInputListener,IRayHandle
	{   
		private var splitterBeam:Cube;
		
		private var userInputhandleTool:LabXObjectUserInputHandleTool;
		
		public function BeamSplitter(name:String,material:MaterialObject3D,vertices:Array=null, faces:Array=null)
		{
			super(material,name, vertices, faces);
			createDisplayObject();
			addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
			userInputhandleTool = new LabXObjectUserInputHandleTool(this);
		}
		
		protected function makeNewRay1(oldRay:Ray):Ray
		{
			if(oldRay != null)
			{
				var resultRay:Ray =  new Ray(this,null, null)
//				oldRay.EndX = this.x;
//				var lensLogic:LensLogic = new LensLogic(new Number3D(this.x, this.y, this.z), this._focus);
				var newLineRays:ArrayCollection = new ArrayCollection();
				for each (var oldLineRay:LineRay in oldRay.getLineRays())
				{   
					var beamLogic:SplitterBeamLogic =new SplitterBeamLogic(getPosition(),getNormal());
                    var lineRayLogic:LineRayLogic = beamLogic.calculateRayAfterSplit(oldLineRay.logic);
                    if(lineRayLogic!=null){
                    	
                    	newLineRays.addItem(new LineRay(lineRayLogic));
                    	oldLineRay.end_point = new Number3D(lineRayLogic.x, lineRayLogic.y, lineRayLogic.z);
                    }
                	if(isReverseNormal(lineRayLogic, oldLineRay.logic)) resultRay = null;
				}
				oldRay.displayRays();
				if (resultRay != null)resultRay.setLineRays(newLineRays);
				return resultRay;
			}
			return null;
		}
		
		private function isReverseNormal(a:LineRayLogic, b:LineRayLogic):Boolean
		{
			var n1:Number3D = new Number3D(a.dx, a.dy, a.dz);
			var n2:Number3D = new Number3D(b.dx, b.dy, b.dz);
			return Number3D.add(n1, n2).modulo < LabXConstant.NUMBER_PRECISION;
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
				return  new Ray(this,null,newLineRays);
		    }
		    return  null
		}
		
		public function hanleUserInputEvent(event:Event):void{
			if(userInputHandle!=null){
				userInputHandle.call(this,event);
				return;
			}
			userInputhandleTool.handleUserInputEvent(event);
		}
	    
		public function createDisplayObject():void{
			
	        width=3;
	        depth=100;
	        
		    var materialsList:MaterialsList = new MaterialsList();
			materialsList.addMaterial(material,"front");
			materialsList.addMaterial(material,"back");
			materialsList.addMaterial(material,"left");
			materialsList.addMaterial(material,"right");
			materialsList.addMaterial(material,"top");
			materialsList.addMaterial(material,"bottom");
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
   		public function onRayHandle(oldRay:Ray):void{
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
    	
    	 /**
		 *   This is for get object with the material on it, it should be overrite 
		 * 
		 *   when the this materials not on the basic object,
		 * 
		 *   for example: lens may not have the materials on 
		 * 
		 *   root,but on the sphere
		 * 
		 */ 
		override public function getObjectWithMaterial():TriangleMesh3D{
		    return splitterBeam;
		}
	}
}