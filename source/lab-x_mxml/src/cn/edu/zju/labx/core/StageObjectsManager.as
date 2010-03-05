package cn.edu.zju.labx.core
{
	import cn.edu.zju.labx.events.ILabXListener;
	import cn.edu.zju.labx.events.LabXEvent;
	import cn.edu.zju.labx.objects.LabXObject;
	
	import mx.collections.ArrayCollection;
	
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
		 * Get the current mouse X axis position, coordinate is start from left-bottom of the main view
		 */
		public function getMouse_x():int{
	       return mainView.mouseX;
	    }
	    
	    /**
		 * Get the current mouse Y axis position, coordinate is start from left-bottom of the main view
		 */
	    public function getMouse_y():int{
	       return mainView.mouseY;
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
		 */
		public function addLabXEventListener(listener:ILabXListener):void
		{
			listenerList.addItem(listener);
		}
		
		/**
		 * remove an LabX Event listener
		 * 
		 * @param obj listener to listen LabX Event
		 * 
		 */
		public function removeLabXEventListener(listener:ILabXListener):void
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