package cn.edu.zju.labx.objects
{   
    import cn.edu.zju.labx.core.LabXConstant;
    import cn.edu.zju.labx.core.StageObjectsManager;
    import cn.edu.zju.labx.events.IRayHandle;
    import cn.edu.zju.labx.events.IUserInputListener;
    import cn.edu.zju.labx.events.LabXObjectUserInputHandleTool;
    import cn.edu.zju.labx.logicObject.InterferenceLogic;
    import cn.edu.zju.labx.utils.MathUtils;
    
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.geom.Rectangle;
    
    import org.papervision3d.core.geom.Lines3D;
    import org.papervision3d.core.geom.TriangleMesh3D;
    import org.papervision3d.core.geom.renderables.Line3D;
    import org.papervision3d.core.geom.renderables.Vertex3D;
    import org.papervision3d.core.math.Number3D;
    import org.papervision3d.core.math.Plane3D;
    import org.papervision3d.core.proto.MaterialObject3D;
    import org.papervision3d.events.InteractiveScene3DEvent;
    import org.papervision3d.materials.BitmapMaterial;
    import org.papervision3d.materials.special.LineMaterial;
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
		
		private var userInputTool:LabXObjectUserInputHandleTool;
		
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
		    userInputTool = new LabXObjectUserInputHandleTool(this);
		}
		
		public function createDisplayObject():void{
	        
	        width=LabXConstant.LABX_OBJECT_WIDTH/10;
			
			var materialsList:MaterialsList = new MaterialsList();
			var leftMaterial:MaterialObject3D = material.clone();
			leftMaterial.interactive = true;
			materialsList.addMaterial(material,"front");
			materialsList.addMaterial(material,"back");
			materialsList.addMaterial(leftMaterial,"left");
			materialsList.addMaterial(material,"right");
			materialsList.addMaterial(material,"top");
			materialsList.addMaterial(material,"bottom");
		   	cube = new Cube(materialsList,width,depth,height);
		   	this.addChild(cube);
		   	
		   	var effectLayer:ViewportLayer = new ViewportLayer(StageObjectsManager.getDefault.mainView.viewport, null);
			effectLayer.addDisplayObject3D(cube, true);
			StageObjectsManager.getDefault.layerManager.equipmentLayer.addLayer(effectLayer);
			
			/* display a cursor */
			var lines:Lines3D = new Lines3D;
			var blueMaterial:LineMaterial = new LineMaterial(0x0000FF);
			var start:Vertex3D;
			var end:Vertex3D;
			var line:Line3D;
			start = new Vertex3D(-5, 0, -10);
			end = new Vertex3D(-5, 0, 10);
			line = new Line3D(lines, blueMaterial, 1, start, end);
			lines.addLine(line);
			start = new Vertex3D(-5, -10, 0);
			end = new Vertex3D(-5, 10, 0);
			line = new Line3D(lines, blueMaterial, 1, start, end);
			lines.addLine(line);	
			effectLayer.addDisplayObject3D(lines);
			this.addChild(lines);
		}

		
		
		public function hanleUserInputEvent(event:Event):void
		{
			userInputTool.handleUserInputEvent(event);
		}
		
        override public function addEventListener(type:String, listener:Function,useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{   
			cube.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		

	    //should keep the reference to free resource
	    private var bmp:BitmapData;
	    private var new_material:BitmapMaterial;
		public function displayDoubleSlitInterferenceImage(theta:Number):void
		{   
			var distance:Number = InterferenceLogic.doubleSlitInterferenceLogic(theta, LabXConstant.WAVE_LENGTH);
//			trace(distance);
			
			distance /= 300;
			var numOfColumns:Number = depth/distance/2;
			bmp = new BitmapData(depth, height, false, 0x0);
			for (var i:Number = 0; i < numOfColumns; i++)
			{
				bmp.fillRect(new Rectangle(i*distance*2, 0, distance, height), 0x0000FF);
			}
			new_material = new BitmapMaterial(bmp);
			new_material.smooth = true;
			new_material.interactive = true;
			cube.replaceMaterialByName(new_material, "left");
			
		}
		
		//This is will be  automaticlly called when Ray chenged 
		public function unDisplayInterferenceImage():void{
			if(new_material!=null && bmp!=null){
				new_material.destroy();
				new_material = null;
				bmp.dispose();
				bmp = null;
		    	cube.replaceMaterialByName(material, "left");
		 	}
		 	oldRay1 =null;
		 	oldRay2 =null;
		}
		

         /************************************************************
		 * 
		 *  This is implement of IRayHandle
		 * 
		 ************************************************************/ 
		
		/**
		 *  deal with when the ray on the object
		 **/ 
		 
		private var oldRay1:Ray =null;
		private var oldRay2:Ray =null;
		
		/**
		 *  save the two rays
		 */ 
		public function saveRays(oldRay:Ray):void{
            if(oldRay1 == null){
               oldRay1 = oldRay;
            } else if(oldRay2 == null){
               oldRay2 = oldRay;
            }
        }
   		public function onRayHanle(oldRay:Ray):void{
   			
            saveRays(oldRay);
            
			for each (var oldLineRay:LineRay in oldRay.getLineRays())
			{
				if (isLineRayOnObject(oldLineRay.logic)){
					var point:Number3D = new Number3D(oldLineRay.logic.x, oldLineRay.logic.y, oldLineRay.logic.z);
					var vector:Number3D = new Number3D(oldLineRay.logic.dx, oldLineRay.logic.dy, oldLineRay.logic.dz);
					var plane:Plane3D = getObjectPlane();
					var anPoint:Number3D = Number3D.sub(point, vector);
					var intersection:Number3D = plane.getIntersectionLineNumbers(point, anPoint);
					oldLineRay.end_point = new Number3D(intersection.x, intersection.y, intersection.z);
				}
			}
			oldRay.displayRays();
			if(oldRay1!=null&&oldRay2!=null){
			   var lineRay1:LineRay = oldRay1.getLineRays().getItemAt(0) as LineRay;
			   var lineRay2:LineRay = oldRay2.getLineRays().getItemAt(0) as LineRay;
			   if(lineRay1!=null&&lineRay2!=null){		
			   	var angle1:Number =  MathUtils.calculateAngleOfTwoVector(Number3D.sub(lineRay1.end_point,lineRay1.start_point),this.getNormal());
			   	var angle2:Number =  MathUtils.calculateAngleOfTwoVector(Number3D.sub(lineRay2.end_point,lineRay2.start_point),this.getNormal());
               	   if(Math.abs(angle1-angle2)<(Math.PI/180)){
               	    displayDoubleSlitInterferenceImage(MathUtils.calculateAngleOfTwoVector(Number3D.sub(lineRay1.end_point,lineRay1.start_point),Number3D.sub(lineRay2.end_point,lineRay2.start_point)));
                   }else{
                      StageObjectsManager.getDefault.addMessage("两条光线夹角之差大于一度");
                   }
               }else{
               		  StageObjectsManager.getDefault.addMessage("光线没有经过挡板");
               }
            
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
				for each (var lineRay:LineRay in ray.getLineRays())
    	    	{
					if(lineRay != null && isLineRayOnObject(lineRay.logic))
					{
						return true;
					}
    	    	}
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
		    return cube;
		}
        

	}
}