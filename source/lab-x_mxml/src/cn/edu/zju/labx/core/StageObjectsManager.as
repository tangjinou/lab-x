package cn.edu.zju.labx.core
{
	import cn.edu.zju.labx.objects.Board;
	import cn.edu.zju.labx.objects.LabXObject;
	import cn.edu.zju.labx.objects.Lens;
	
	import flash.filters.DropShadowFilter;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Button;
	import mx.controls.TextArea;
	
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.view.layer.ViewportLayer;
	
	public  class StageObjectsManager
	{   
       /**
        * Man view of the application
        */
        public  var mainView:BasicView;
        
        /**
         * Current stage width
         */ 
        public  var stage_width:Number;
         /**
         * Current stage height
         */ 
        public  var stage_height:Number;
        
        /**
        *  This var is for test, it has recorded the number of labXObject notify
        * */
        public  var notify_count:int=0;
        
        /**
        *  This is for stage rotate, if true can rotate
        */
        public var rotate_stage:Boolean=true;
        
        /***
        * 
        *  This is origin Pivot ,should be seted in view;
        */  
        public  var originPivot:DisplayObject3D;
        
        
        /**
        *  This is for basicview rotate
        **/
        public  var isOrbiting:Boolean;
		
		/**
		 * Get the current mouse X axis position, coordinate is start from left-bottom of the main view
		 */
		public function getMouse_x():int{
	       return  mainView.mouseX;
	    }
	    
	     /**
		 * Get the current mouse X axis position, coordinate is start from originPivot.x
		 */
	    public function getMouse_originPivot_relative_x():int{
	       return getMouse_x()-(LabXConstant.STAGE_WIDTH/2)-originPivot.x;
	    }
	    
	    /**
		 * Get the current mouse Y axis position, coordinate is start from left-bottom of the main view
		 */
	    public function getMouse_y():int{
	       return  mainView.mouseY;
	    }
	    
	     /**
		 * Get the current mouse Y axis position, coordinate is start start from originPivot.y
		 */
	    public function getMouse_originPivot_relative_y():int{
	       return getMouse_y()-(LabXConstant.STAGE_HEIGHT/2)-originPivot.y;
	    }
	    
	    
	    /**
	     * Get the X axis in Pivot corrdinate from stage corridinate
	     */
		public function getPivotX(stageX:Number):Number
		{
			return stageX - originPivot.x - (LabXConstant.STAGE_WIDTH/2);
		}
		
		/**
	     * Get the Y axis in Pivot corrdinate from stage corridinate
	     */
		public function getPivotY(stageY:Number):Number
		{
			return stageY - originPivot.y - (LabXConstant.STAGE_HEIGHT/2);
		}
		
		
		        
		/*************************************************************************
		 * Sigleton Method to make sure there are only one StageObjectManager 
		 * in an application
		 * ***********************************************************************
		 */
		protected static var instance:StageObjectsManager = null;
		public static function get getDefault():StageObjectsManager
		{
			if (instance == null)
				instance = new StageObjectsManager();
			return instance;
		}
		
		
		 /*************************************************************************
		 *  This is the RayManager 
		 * ***********************************************************************
		 */
	    private var raymanager:RayManager;
	    public function get rayManager():RayManager{
	    	if(this.raymanager ==null){
	    	   raymanager =new RayManager(); 
	    	}
	    	return this.raymanager;
	    }
		
		

		 /*************************************************************************
		 *  This is the MessageBox 
		 * ***********************************************************************
		 */
		 public var messageBox:TextArea;
		 public function addMessage(msg:String):void{
		    messageBox.text+="\n"+msg;
		    messageBox.verticalScrollPosition=messageBox.maxVerticalScrollPosition;
		 }
		 public function clearMessage(msg:String):void{
		    messageBox.text="公告栏";
		 }
		 
		 /******************************************************
		 *  This is hook for objectPressHandler
		 * *****************************************************/
		
		 /**
		 *  This is rotate_right button in the view
		 **/
		 public var rotate_right_button:Button;
		 
		 /**
		 *  This is rotate_left button in the view
		 **/
		 public var rotate_left_button:Button;
		 
		 private var labXObjectSelected:LabXObject;
		 
		 private var dropShadowFilter:DropShadowFilter = new DropShadowFilter(0, 360, 0x00FF00, 1, 16, 16, 3, 2, false, false, false);

		 public function objectPressHandlerHook(event:InteractiveScene3DEvent,labXObject:LabXObject):void{
		 	if ((labXObjectSelected != null) && (labXObjectSelected != labXObject))
		 	{
		 		mainView.viewport.getChildLayer(labXObjectSelected.getObjectWithMaterial(), true, true).filters = null;
		 	}
		 	rotate_right_button.enabled=true;
		 	rotate_left_button.enabled=true;
		 	labXObjectSelected = labXObject;
		 	var viewportLayer:ViewportLayer = mainView.viewport.getChildLayer(labXObject.getObjectWithMaterial(), true, true);
			viewportLayer.filters =[dropShadowFilter]; 
		 } 
		 
		 public function objectUnPressHandler():void{

	 	   if(labXObjectSelected != null)
	 	   {
	 	   		var viewportLayer:ViewportLayer = mainView.viewport.getChildLayer(labXObjectSelected, true, true);
				viewportLayer.filters =null;
	 	   		labXObjectSelected = null;
		        rotate_right_button.enabled=false;
		        rotate_left_button.enabled=false;
		       
		        labXObjectSelected =null
		   }
		 }
		 
		 
		 /******************************************************
		 *   object list 
		 * ******************************************************/
		 //this list only for ray notify, if object is removed ,then i will be not notified
         private var objectList:ArrayCollection = new ArrayCollection();
         //this list for objects in the stage , it is globe list
         private var objectAllSavedList:ArrayCollection = new ArrayCollection();		 
		 
		 public function addObject(obj:LabXObject):void{
		 	 originPivot.addChild(obj);
		     objectList.addItem(obj);
		     objectAllSavedList.addItem(obj);
		     if(obj is Board){
		       rayManager.setBorad(obj as Board);
		     }
		 }
		 
		 public function addObjectByName(name:String):void{
		 	 for(var i:int=0;i<objectAllSavedList.length;i++){
		        var obj:LabXObject = objectAllSavedList.getItemAt(i) as LabXObject;
		        if(obj !=null && obj.name == name){
		            originPivot.addChild(obj);
		            objectList.addItem(obj);
		            raymanager.reProduceRays();
		        }
		     }
		 }
		 public function removeObject(obj:LabXObject):void{
		 	 originPivot.removeChild(obj);
		     objectList.removeItemAt(objectList.getItemIndex(obj));
		 }
		 public function removeObjectByName(name:String):void{
		     for(var i:int=0;i<objectList.length;i++){
		        var obj:LabXObject = objectList.getItemAt(i) as LabXObject;
		        if(obj !=null && obj.name == name){
		           removeObject(obj);
		           raymanager.reProduceRays();
		        }
		     }
		 }
		 public function getObjectList():ArrayCollection{
		     return objectList
		 }
		
		 /////////////////////////////////////////////////////////////////////////
		 
		 
	    //////////////////////////////////////////////////////////////////////////////
		
		/****
		 *   we could get layerManager, layerManager is also a singleton
		 */ 
		public function get layerManager():LayerManager{
		
		   return LayerManager.getDefault;
		}
		
		
		public function rotate_left():void{
		   if(labXObjectSelected!=null&&Math.abs(labXObjectSelected.localRotationY) <70){
		     labXObjectSelected.localRotationY++;
		     
		     rayManager.reProduceRays();
		   }
		}
		
		public function rotate_right():void{
           if(labXObjectSelected!=null&& Math.abs(labXObjectSelected.localRotationY) <70){
		     labXObjectSelected.localRotationY--;
		     rayManager.reProduceRays();

		   }
		}
		
        
	}   
}