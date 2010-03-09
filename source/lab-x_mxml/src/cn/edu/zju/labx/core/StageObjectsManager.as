package cn.edu.zju.labx.core
{
	import cn.edu.zju.labx.events.ILabXListener;
	import cn.edu.zju.labx.events.LabXEvent;
	import cn.edu.zju.labx.objects.LabXObject;
	
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.view.BasicView;
	
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
		
		/**
		 * *************************************************************************
		 * LabX Object Management
		 * ***********************************************************************
		 */
		 
		private var objectList:ArrayCollection =new ArrayCollection();
		 
		/**
		 * add an LabX Event listener
		 */
		public function addLabXObject(obj:LabXObject):void
		{
			objectList.addItem(obj);
			if(obj is ILabXListener) {
				addLabXEventListener(obj as ILabXListener);
			}
			originPivot.addChild(obj);
		}
		
		/**
		 * remove an LabX Event listener
		 * 
		 * @param obj listener to listen LabX Event
		 * 
		 */
		public function removeLabXObject(obj:LabXObject):void
		{
			objectList.removeItemAt(objectList.getItemIndex(obj));
			if(obj is ILabXListener) {
				removeLabXEventListener(obj as ILabXListener);
			}
			originPivot.removeChild(obj);
		}

		public function getLabXObjects():ArrayCollection
		{
			return objectList;
		}
		
		/**
		 * *************************************************************************
		 * LabX Event Manager
		 * ***********************************************************************
		 */
		/**
		 * LabX Event listener list
		 */
		private var listenerList:ArrayCollection = new ArrayCollection();
		
		
		/**
		 * add an LabX Event listener
		 * 
		 * 
		 * This should be private,Because it only add when object added,what is your oppinion?
		 */
		private function addLabXEventListener(listener:ILabXListener):void
		{
			listenerList.addItem(listener);
		}
		
		/**
		 * remove an LabX Event listener
		 * 
		 * @param obj listener to listen LabX Event
		 * 
		 */
		private function removeLabXEventListener(listener:ILabXListener):void
		{   
			listenerList.removeItemAt(listenerList.getItemIndex(listener));
		}
		
		public function getLabXListeners():ArrayCollection
		{
			return listenerList;
		}
		
		/**
		 * Dispatch LabX Event 
		 */
		public  function notify(event:LabXEvent):void {
			for(var index:int;index<listenerList.length;index++){
			   var obj:ILabXListener =listenerList.getItemAt(index) as ILabXListener;
			     if(obj.handleLabXEvent(event)==false){
			        break;
			     }
			     notify_count++;
			}
		}
		
		
//	    private var labXObjectListener:LabXObject =null;
//        public function setNextObjectListener(labXObjectListener:LabXObject):void{
//            this.labXObjectListener= labXObjectListener; 
//        }
//        private function labXObjectListenerTriger(event:String):void{
//           if(this.labXObjectListener!=null){
//              this.labXObjectListener.eventTriger(event);
//              this.labXObjectListener = null;
//           }
//        }
//		public function dispatchEvent(event:Event):void{
//		   this.labXObjectListenerTriger(event.type);
//		}
		
		//////////////////////////////////////////////////////////////////////
//		public var x_min_offset:int = 5;
//		public var y_min_offset:int = 5;
//        public var z_min_offset:int = 5;
//        public function setX_min_offset(offset:int):void{
//             this.x_min_offset = offset;
//        }
//        public function setY_min_offset(offset:int):void{
//            this.y_min_offset = offset;
//        }
//        public function setZ_min_offset(offset:int):void{
//            this.z_min_offset = offset;
//        }
        
	}   
}