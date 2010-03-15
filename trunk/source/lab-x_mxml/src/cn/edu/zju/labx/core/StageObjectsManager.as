package cn.edu.zju.labx.core
{
	import cn.edu.zju.labx.events.ILabXListener;
	import cn.edu.zju.labx.events.LabXEvent;
	import cn.edu.zju.labx.objects.IRayMaker;
	import cn.edu.zju.labx.objects.LabXObject;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.controls.Button;
	import mx.controls.TextArea;
	
	import org.papervision3d.events.InteractiveScene3DEvent;
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
			if (objectList.sort == null) {
				var sorter:Sort = new Sort();
				sorter.compareFunction = compareValues;
				objectList.sort = sorter;
				objectList.refresh();
			}
			
			if(obj is ILabXListener) {
				addLabXEventListener(obj as ILabXListener);
			}
			
			this.notify(new LabXEvent(null, LabXEvent.XOBJECT_ADD));
//			if(originPivot != null)originPivot.addChild(obj);
		}
		
		/**
		 * remove an LabX Event listener
		 * 
		 * @param obj listener to listen LabX Event
		 * 
		 */
		public function removeLabXObject(obj:LabXObject):void
		{
			if (obj is IRayMaker)
			{
				var rayMaker:IRayMaker = obj as IRayMaker;
				if(rayMaker.getRay() != null)this.originPivot.removeChild(rayMaker.getRay());
			}
			objectList.removeItemAt(objectList.getItemIndex(obj));
			if(obj is ILabXListener) {
				removeLabXEventListener(obj as ILabXListener);
			}
			this.notify(new LabXEvent(null, LabXEvent.XOBJECT_REMOVE));
//			if(originPivot != null)originPivot.removeChild(obj);
		}
		
		public function getPreviousXObject(obj:LabXObject):LabXObject
		{
			var index:int = objectList.getItemIndex(obj);
			if ((index > 0) && (index < objectList.length))
			{
				return objectList.getItemAt(index-1) as LabXObject;
			}
			return null;
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
			if (listenerList.sort == null) {
				var sorter:Sort = new Sort();
				sorter.compareFunction = compareValues;
				listenerList.sort = sorter;
				listenerList.refresh();
			}
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
			notify_count = 0;
			if (event.type == LabXEvent.XOBJECT_MOVE)
			{
				listenerList.refresh();
				objectList.refresh();
			}
			for(var index:int;index<listenerList.length;index++){
				var obj:ILabXListener =listenerList.getItemAt(index) as ILabXListener;
			    if(obj.handleLabXEvent(event)==false){
			       break;
			    }
			    notify_count++;
			}
		}
		
		private function compareValues(a:Object, b:Object, fields:Array = null):int
		{
			if (a == null && b == null) return 0;
			if (a == null) return 1;
			if (b == null) return -1;
			var objA:LabXObject = a as LabXObject;
			var objB:LabXObject = b as LabXObject;
			
			if (objA.x > objB.x)return 1;
			if (objA.x < objB.x)return -1;
			
			return 0;
		};
		
		
		/**
		 *  This is the MessageBox
		 **/
		 public var messageBox:TextArea;
		 public function addMessage(msg:String):void{
		    messageBox.text+="\n"+msg;
		    messageBox.verticalScrollPosition=messageBox.maxVerticalScrollPosition;
		 }
		 public function clearMessage(msg:String):void{
		    messageBox.text="公告栏";
		 }
		 
		 
		 
		 /**
		 *  This is rotate_right button in the view
		 **/
		 public var rotate_right_button:Button;
		 
		 /**
		 *  This is rotate_left button in the view
		 **/
		 public var rotate_left_button:Button;
		 
		 
		 private var labXObjectSelected:LabXObject;
		 
		 public function objectPressHandlerHook(event:InteractiveScene3DEvent,labXObject:LabXObject):void{
		       rotate_right_button.enabled=true;
		       rotate_left_button.enabled=true;
		       labXObjectSelected = labXObject;
		 } 
		 
		 
		 public function objectUnPressHandler():void{
		 	
	 	   if(labXObjectSelected == null)
	 	   {
		       rotate_right_button.enabled=false;
		       rotate_left_button.enabled=false;
		   }
		 }
		 
		
		/****
		 *   we could get layerManager, layerManager is also a singleton
		 */ 
		public function get layerManager():LayerManager{
		
		   return LayerManager.getDefault;
		}
		
		
		public function rotate_left():void{
//		   if(labXObjectSelected!=null&&UserInputHandler.getDefault.currentSelectedObject!=null){
		   if(labXObjectSelected!=null){
		     labXObjectSelected.rotationY++;
		     if(labXObjectSelected is ILabXListener)
		     {
		     	var obj:ILabXListener = labXObjectSelected as ILabXListener;
		     	obj.handleLabXEvent(new LabXEvent(null, LabXEvent.XOBJECT_MOVE));
		     }
		   }
		   else{
//		     this.originPivot.rotationY++;
		   }
		}
		
		public function rotate_right():void{
//		   if(labXObjectSelected!=null&&UserInputHandler.getDefault.currentSelectedObject!=null){
           if(labXObjectSelected!=null){
		     labXObjectSelected.rotationY--;
		     if(labXObjectSelected is ILabXListener)
		     {
		     	var obj:ILabXListener = labXObjectSelected as ILabXListener;
		     	obj.handleLabXEvent(new LabXEvent(null, LabXEvent.XOBJECT_MOVE));
		     }
		   }else{
//		     this.originPivot.rotationY--;
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