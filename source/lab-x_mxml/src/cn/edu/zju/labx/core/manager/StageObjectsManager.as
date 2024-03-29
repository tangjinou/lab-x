package cn.edu.zju.labx.core.manager
{
	import cn.edu.zju.labx.core.HintDisplayer;
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.events.ILabXListener;
	import cn.edu.zju.labx.events.ResultObjectListener;
	import cn.edu.zju.labx.objects.LabXObject;
	import cn.edu.zju.labx.objects.lightSource.LightSource;
	
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.containers.VBox;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.controls.TextArea;
	import mx.core.Application;
	
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
        * Current Application
        **/ 
        public var application:Application;
        
        /**
        *  Current stage
        */ 
        public  var stage:Stage;   
        
        /**
        *  special_bar_box
        */ 
        public var special_bar_box:VBox;
           
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
		 * currently  not used
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
		 * currently  not used
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
	    public function get rayManager():RayManager{
	    	return RayManager.getDefault;
	    }
	    
		/*************************************************************************
		 *  we could get layerManager, layerManager is also a singleton
		 * ***********************************************************************
		 */
		public function get layerManager():LayerManager{
		   return LayerManager.getDefault;
		}
		
		/*************************************************************************
		 *  we could get layerManager, layerManager is also a singleton
		 * ***********************************************************************
		 */
		public function get experimentManager():ExperimentManager{
		   return ExperimentManager.getDefault;
		}
		
	    
	    
	    /***************************************************************************
	     ***************************************************************************
		 *   Object list, we handle the objects here
		 * **************************************************************************
		 */
         //this list for objects in the stage , it is globe list
         public var objectAllSavedList:ArrayCollection = new ArrayCollection();		 
		 //this list only for ray notify, if object is removed ,then i will be not notified
         private var objectList:ArrayCollection = new ArrayCollection();
         
         private var stageObjectList:ArrayCollection = new ArrayCollection();
         
         /**
         *  could get the LabXObject by the classname;
         */ 
         public function getLabXObject(classname:Class):LabXObject{
              for(var i:int=0;i<objectAllSavedList.length;i++){
                  var obj:LabXObject = objectAllSavedList.getItemAt(i) as LabXObject;              
                  if (obj is classname){
                       return obj;
                  }
              }
              return null;
         }
         
         public  function clear():void{
            objectAllSavedList.removeAll();
            objectList.removeAll();
            stageObjectList.removeAll();
         }
		 
		/**
		 * add an object to the stage
		 */
		public function addObject(obj:LabXObject):void
		{
		    if (!objectAllSavedList.contains(obj))objectAllSavedList.addItem(obj);
			if (!objectList.contains(obj))
			{
				objectList.addItem(obj);
				originPivot.addChild(obj);
			}
			
			objectStateChanged(obj);
		 }
		 
		/**
		 * add an object to the stage by name
		 */
		public function addObjectByName(name:String):void{
		 	 for(var i:int=0;i<objectAllSavedList.length;i++){
		        var obj:LabXObject = objectAllSavedList.getItemAt(i) as LabXObject;
		        if(obj !=null && obj.name == name){
		            addObject(obj);
		        }
		     }
		}
		
		/**
		 * remove an object from the stage
		 */ 
		public function removeObject(obj:LabXObject):void{
			originPivot.removeChild(obj);
			objectList.removeItemAt(objectList.getItemIndex(obj));
			
			if(stageObjectList.contains(obj))
			{
				stageObjectList.removeItemAt(stageObjectList.getItemIndex(obj));
				rayManager.reProduceRays();
			}
		}
		 
		/**
		 * remove an object from the stage by name
		 */ 
		public function removeObjectByName(name:String):void{
			for(var i:int=0;i<objectList.length;i++)
			{
				var obj:LabXObject = objectList.getItemAt(i) as LabXObject;
				if(obj !=null && obj.name == name){
					removeObject(obj);
				}
			}
		}
		/****
		 *  check the labxobject if it is in the stage, if true it will be add the list where the ray notify
		 */ 
		public function objectStateChanged(object:LabXObject):void
		{
			if (stageObjectList.contains(object))
			{
				if(!isObjectInStage(object))
				{
					stageObjectList.removeItemAt(stageObjectList.getItemIndex(object));
					if (object is LightSource)
					{
						rayManager.lightSources.removeItemAt(rayManager.lightSources.getItemIndex(object));
					} 
				}
				rayManager.reProduceRays();
			} else 
			{
				if(isObjectInStage(object))
				{
					stageObjectList.addItem(object);
					if (object is LightSource)
					{
						rayManager.lightSources.addItem(object as LightSource);
					}
					rayManager.reProduceRays();
				}
			}
			object.update();
		}
		
		public function isObjectInStage(object:LabXObject):Boolean
		{
			return (object.x > 30) && (object.x < LabXConstant.DESK_WIDTH) && (object.z > -LabXConstant.DESK_DEPTH/2) && (object.z < LabXConstant.DESK_DEPTH/2);
		}
		 
		/**
		 * get the objects in the stage
		 */
		public function getObjectList():ArrayCollection
		{
			return objectList;
		}
		
		/**
		 * get the objects in the stage
		 */
		public function getStageObjectList():ArrayCollection
		{
			return stageObjectList;
		}
		
		
		

		 /*************************************************************************
		 *  This is the MessageBox 
		 * ***********************************************************************
		 */
		 public var messageBox:TextArea;
		 public function addMessage(msg:String):void{
		    messageBox.text+="\n"+msg;
		    messageBox.verticalScrollPosition++;
		 }
		 public function clearMessage(msg:String):void{
		    messageBox.text="公告栏";
		 }
		 /*************************************************************************
		 *  This is the coordatnate
		 * ***********************************************************************
		 */
		 public var coordainate_x:Text;
		 public var coordainate_y:Text;
		 public var coordainate_z:Text;
		 public var object_selected:Text;
		 public var rotate_x:Text;
		 public var rotate_y:Text;
		 public var rotate_z:Text;
		 
		 
		  /*************************************************************************
		 *  This is status of scene_rotation
		 * ***********************************************************************
		 */
		 public var scene_rotation:Text;
		 
		 
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
		 /***
		 *  This is object_uping button in the view
		 */ 
		 public var object_uping_button:Button;
		 /***
		 *  This is object_downing button in the view
		 */ 
		 public var object_downing_button:Button;
		 /***
		 *  This is object_forwarding button in the view
		 */ 
		 public var object_forwarding_button:Button; 
		 /***
		 *  This is object_backwarding button in the view
		 */ 
		 public var object_backwarding_button:Button; 
		 /***
		 *  This is object_lefting button in the view
		 */ 
		 public var object_lefting_button:Button;
		 /***
		 *  This is object_righting button in the view
		 */ 
		 public var object_righting_button:Button;  
		 
		 
		 private var labXObjectSelected:LabXObject;
		 
		 private var dropShadowFilter:DropShadowFilter = new DropShadowFilter(0, 360, 0x00FF00, 1, 16, 16, 3, 2, false, false, false);
         
         private var hint:HintDisplayer = new HintDisplayer();
         //This is stack for stage rotate
         private var rotate_stage_tmp:Boolean;
		 public function objectPressHandlerHook(event:InteractiveScene3DEvent,labXObject:LabXObject):void{
		 	if ((labXObjectSelected != null) && (labXObjectSelected != labXObject))
		 	{
		 		mainView.viewport.getChildLayer(labXObjectSelected.getObjectWithMaterial(), true, true).filters = null;
		 	}
		 	// enable the button list
		 	rotate_right_button.enabled=true;
		 	rotate_left_button.enabled=true;
		 	object_uping_button.enabled=true;
		 	object_downing_button.enabled=true;
		 	object_forwarding_button.enabled=true;
		 	object_backwarding_button.enabled=true;
		 	object_lefting_button.enabled=true;
		 	object_righting_button.enabled=true;
		 	
		 	//save the status of the rotate stage
		 	rotate_stage_tmp = rotate_stage;
		    
		 	rotate_stage = false;
		 	
		 	labXObjectSelected = labXObject;
		 	var viewportLayer:ViewportLayer = mainView.viewport.getChildLayer(labXObject.getObjectWithMaterial(), true, true);
			viewportLayer.filters =[dropShadowFilter];
			
			if(stageObjectList.length < 2){
				hint.displayMoveHint();
			}
			
			changeStatus();
			
		 } 
		 
		 public function objectUnPressHandler():void{

	 	   if(labXObjectSelected != null)
	 	   {
	 	   		var viewportLayer:ViewportLayer = mainView.viewport.getChildLayer(labXObjectSelected.getObjectWithMaterial(), true, true);
				viewportLayer.filters =null;
	 	   		labXObjectSelected = null;
	 	   		//disable the button list
		        rotate_right_button.enabled=false;
		        rotate_left_button.enabled=false;
		        object_uping_button.enabled=false;
		 	    object_downing_button.enabled=false;
		 	    object_forwarding_button.enabled=false;
		 	    object_backwarding_button.enabled=false;
		 	    object_lefting_button.enabled=false;
		 	    object_righting_button.enabled=false;
		        labXObjectSelected=null;
		        
		        rotate_stage = rotate_stage_tmp;
		   }
		 }
		
	
		
		///////////////////////////////////////////////////////////////////////////////////////////////////
		/***
		 *  This for button listener 
		 */
		 
	    public function open_stage_rotate():void{
	 		StageObjectsManager.getDefault.rotate_stage=true;
	 	    StageObjectsManager.getDefault.addMessage("视角旋转打开.");
	    } 
	    
	    public function close_stage_rotate():void{
	 		StageObjectsManager.getDefault.rotate_stage=false;
	 		StageObjectsManager.getDefault.addMessage("视角旋转关闭.");
	    }
	    
	    
	    public function movingObjects():void{
	 		   ExperimentManager.getDefault.movingObjects();
	 	}
		
		
		
        public function changeCoordainate(x:int,y:int,z:int,_x:int,_y:int,_z:int):void{
            this.coordainate_x.text = x+"";
		    this.coordainate_y.text = y+"";
		    this.coordainate_z.text = z+"";
		    this.rotate_x.text = _x + "";
		    this.rotate_y.text = _y + "";
		    this.rotate_z.text = _z + "";
        }
        
        public function changeStatus():void{
           
//           if(StageObjectsManager.getDefault.rotate_stage == true){
//             this.scene_rotation.text = "开";
//           }
//           else{
//           	 this.scene_rotation.text = "关";
//           }          
        }
		
		public function rotate_left(step_length:int):void{
		   if(labXObjectSelected!=null){
		     labXObjectSelected.localRotationY-=step_length;
		     refresh();
//		     this.addMessage(labXObjectSelected.name+this.scene_rotation.text = "是";"绕Y转动"+labXObjectSelected.localRotationY.toFixed(2));
		     changeCoordainate(labXObjectSelected.x,labXObjectSelected.y,labXObjectSelected.z,labXObjectSelected.rotationX,labXObjectSelected.rotationY,labXObjectSelected.rotationZ);
		     changeStatus();
		   }
		}
		
		public function rotate_right(step_length:int):void{
           if(labXObjectSelected!=null){
		     labXObjectSelected.localRotationY+=step_length;
		     refresh();
//             this.addMessage(labXObjectSelected.name+"绕Y转动"+labXObjectSelected.localRotationY.toFixed(2));
             changeCoordainate(labXObjectSelected.x,labXObjectSelected.y,labXObjectSelected.z,labXObjectSelected.rotationX,labXObjectSelected.rotationY,labXObjectSelected.rotationZ);
		     changeStatus();
		   }
		}
		
		public function object_uping(step_length:int):void{
		    if(labXObjectSelected!=null){
		    	if (labXObjectSelected is LightSource)
		    	{
		    		labXObjectSelected.rotationZ++;
//		    		addMessage(labXObjectSelected.name+"往上转动"+labXObjectSelected.localRotationZ.toFixed(2));
		    		changeCoordainate(labXObjectSelected.x,labXObjectSelected.y,labXObjectSelected.z,labXObjectSelected.rotationX,labXObjectSelected.rotationY,labXObjectSelected.rotationZ);
		    	
		    	} else 
		    	{
				    labXObjectSelected.y+=step_length;
//		            this.addMessage(labXObjectSelected.name+"往上移动"+labXObjectSelected.y.toFixed(2));
		             changeCoordainate(labXObjectSelected.x,labXObjectSelected.y,labXObjectSelected.z,labXObjectSelected.rotationX,labXObjectSelected.rotationY,labXObjectSelected.rotationZ);
		    	}
		    	changeStatus();
//		    	trace("x: " + labXObjectSelected.x + "  y: " + labXObjectSelected.y + "  z: " + labXObjectSelected.z);
//		    	trace("rotateX: " + labXObjectSelected.rotationX + "  rotateY: " + labXObjectSelected.rotationY + "  rotateZ: " + labXObjectSelected.rotationZ);
			    refresh();
		   }
		}
		
		public function object_downing(step_length:int):void{
			
		    if(labXObjectSelected!=null){
		    	if (labXObjectSelected is LightSource)
		    	{
		    		labXObjectSelected.rotationZ--;
//		    		addMessage(labXObjectSelected.name+"往下转动"+labXObjectSelected.localRotationZ.toFixed(2));
		    		 changeCoordainate(labXObjectSelected.x,labXObjectSelected.y,labXObjectSelected.z,labXObjectSelected.rotationX,labXObjectSelected.rotationY,labXObjectSelected.rotationZ);
		    	} else {
					labXObjectSelected.y-=step_length;
//					this.addMessage(labXObjectSelected.name+"往下移动"+labXObjectSelected.y.toFixed(2));
					 changeCoordainate(labXObjectSelected.x,labXObjectSelected.y,labXObjectSelected.z,labXObjectSelected.rotationX,labXObjectSelected.rotationY,labXObjectSelected.rotationZ);
		    	}
		    	changeStatus();
		    	refresh();
		   }
		}
		public function object_lefting(step_length:int):void{
		   if(labXObjectSelected!=null){
				labXObjectSelected.x-=step_length;
//				this.addMessage(labXObjectSelected.name+"往左移动"+labXObjectSelected.x.toFixed(2));
				changeCoordainate(labXObjectSelected.x,labXObjectSelected.y,labXObjectSelected.z,labXObjectSelected.rotationX,labXObjectSelected.rotationY,labXObjectSelected.rotationZ);
		    	changeStatus();
		    	refresh();
		   }
		}
		
	   public function object_righting(step_length:int):void{
		   if(labXObjectSelected!=null){
				labXObjectSelected.x+=step_length;
//				this.addMessage(labXObjectSelected.name+"往右移动"+labXObjectSelected.x.toFixed(2));
				changeCoordainate(labXObjectSelected.x,labXObjectSelected.y,labXObjectSelected.z,labXObjectSelected.rotationX,labXObjectSelected.rotationY,labXObjectSelected.rotationZ);
		    	changeStatus();
		    	refresh();
		   }
		}
		
	    public function object_forwarding(step_length:int):void{
		   if(labXObjectSelected!=null){
		    	labXObjectSelected.z+=step_length;
//				this.addMessage(labXObjectSelected.name+"往前移动"+labXObjectSelected.z.toFixed(2));
				changeCoordainate(labXObjectSelected.x,labXObjectSelected.y,labXObjectSelected.z,labXObjectSelected.rotationX,labXObjectSelected.rotationY,labXObjectSelected.rotationZ);
		    	changeStatus();
		    	refresh();
		   }
		}
		
	    public function object_backingwarding(step_length:int):void{
		   if(labXObjectSelected!=null){
		    	labXObjectSelected.z-=step_length;
//				this.addMessage(labXObjectSelected.name+"往后移动"+labXObjectSelected.z.toFixed(2));
				changeCoordainate(labXObjectSelected.x,labXObjectSelected.y,labXObjectSelected.z,labXObjectSelected.rotationX,labXObjectSelected.rotationY,labXObjectSelected.rotationZ);
		    	changeStatus();
		    	refresh();
		   }
		}
		
		
		private function refresh():void{
			var timer:Timer= new Timer(600);
		      timer.addEventListener(TimerEvent.TIMER, onTimer);
    				function onTimer(event:TimerEvent):void{
                       objectStateChanged(labXObjectSelected);
         			   timer.stop();
                    }
              timer.start();
		}
		
		/**
		 * The experiment is on result Object
		 */
		private var _experimentResultObject:LabXObject;
		private var _resultLabel:Label;
		
		public function setResultObject(resultObject:LabXObject):void
		{
			_experimentResultObject = resultObject;
			if (_resultLabel != null) {
				var listener:ILabXListener = new ResultObjectListener(_resultLabel);
				_experimentResultObject.addLabxListener(listener);
			}
		}
		
		public function setResultLabel(resultLabel:Label):void
		{
			_resultLabel = resultLabel;
		}
		
		public function getResultObject():LabXObject
		{
			return _experimentResultObject;
		}
        
	}   
}