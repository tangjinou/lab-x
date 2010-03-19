package cn.edu.zju.labx.objects
{   
    import cn.edu.zju.labx.core.LabXConstant;
    import cn.edu.zju.labx.core.StageObjectsManager;
    import cn.edu.zju.labx.events.IRayHandle;
    import cn.edu.zju.labx.events.IUserInputListener;
    import cn.edu.zju.labx.logicObject.InterferenceLogic;
    import cn.edu.zju.labx.utils.MathUtils;
    
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.geom.Rectangle;
    
    import org.papervision3d.core.proto.MaterialObject3D;
    import org.papervision3d.events.InteractiveScene3DEvent;
    import org.papervision3d.materials.BitmapMaterial;
    import org.papervision3d.materials.utils.MaterialsList;
    import org.papervision3d.objects.primitives.Cube;
    import org.papervision3d.view.layer.ViewportLayer;
    
    /**
     * Board is an LabX Object used to display the light result
     * 
     */
	public class Board extends LabXObject implements IUserInputListener ,IRayHandle
	{   
		protected var cube:Cube;
		
	    public var height:int;
	    public var width:int;
	    public var depth:int;

		
		/**
		 * Create a board
		 * 
		 * @param material the material to create object in it
		 * 
		 */
		public function Board(name:String,material:MaterialObject3D=null)
		{
			super(material,name);
			createDisplayObject();
		    addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
		}
		
		public function createDisplayObject():void{
			var materialsList:MaterialsList = new MaterialsList();
			var leftMaterial:MaterialObject3D = material.clone();
			materialsList.addMaterial(material,"front");
			materialsList.addMaterial(material,"back");
			materialsList.addMaterial(leftMaterial,"left");
			materialsList.addMaterial(material,"right");
			materialsList.addMaterial(material,"top");
			materialsList.addMaterial(material,"bottom");
            height=LabXConstant.LABX_OBJECT_HEIGHT;
	        width=LabXConstant.LABX_OBJECT_WIDTH/10;
	        depth=LabXConstant.LABX_OBJECT_DEPTH;
		   	cube = new Cube(materialsList,width,depth,height);
		   	this.addChild(cube);
		   	
		   	var effectLayer:ViewportLayer = new ViewportLayer(StageObjectsManager.getDefault.mainView.viewport, null);
			effectLayer.addDisplayObject3D(cube, true);
			StageObjectsManager.getDefault.layerManager.equipmentLayer.addLayer(effectLayer);
		}

		
		
		public function hanleUserInputEvent(event:Event):void
		{
			//TODO:
		}
		
        override public function addEventListener(type:String, listener:Function,useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{   
			cube.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function displayInterferenceImage():void
		{
			var theta:Number = Math.PI/10;
			var interf:InterferenceLogic = new InterferenceLogic(theta, LabXConstant.WAVE_LENGTH);
			var distance:Number = interf.getDistance();
			trace(distance);
			
			var bmp:BitmapData = new BitmapData(depth, height, false, 0x0);
			distance /= 300;
			var numOfColumns:Number = depth/distance/2;
			for (var i:Number = 0; i < numOfColumns; i++)
			{
				bmp.fillRect(new Rectangle(i*distance*2, 0, distance, height), 0x0000FF);
			}
			var material:BitmapMaterial = new BitmapMaterial(bmp);
			material.smooth = true;
			material.interactive = true;
			cube.replaceMaterialByName(material, "left");
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
   			 
   			 for each (var oldLineRay:LineRay in oldRay.getLineRays())
		     {
			 }
			 oldRay.displayRays();
             displayInterferenceImage();
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