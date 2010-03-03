package cn.edu.zju.labx.core
{
	import cn.edu.zju.labx.events.ILabXListener;
	import cn.edu.zju.labx.events.LabXEvent;
	import cn.edu.zju.labx.objects.LabXObject;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.view.BasicView;
	
	public  class StageObjectsManager
	{   
		public var notify_count:int = 0;
		public static function get getDefault():StageObjectsManager
		{
			if (instance == null)
				instance = new StageObjectsManager();
			return instance;	
		}

		protected static var instance:StageObjectsManager = null;
		
		
		/*stage listener*/
		///////////////////////////////////////////////////////
		public  var list:ArrayCollection =new ArrayCollection();
		public   function addLabXObject(obj:ILabXListener):void
		{   
			list.addItem(obj);
		}
		public  function removeLabXObject(obj:ILabXListener):void
		{   
			list.removeItemAt(list.getItemIndex(obj));
		}
		public  function notify(event:LabXEvent):void {
			//clear notify
			notify_count= 0;
			for(var index:int;index<list.length;index++){
			   var obj:ILabXListener =list.getItemAt(index) as ILabXListener;
			     notify_count++
			     if(obj.handleLabXEvent(event)==false){
			        break;
			     }
			}
		}
		
		/*object listener*/
		/////////////////////////////////////////////////////////////////////
	    private var labXObjectListener:LabXObject =null;
        public function setNextObjectListener(labXObjectListener:LabXObject):void{
            this.labXObjectListener= labXObjectListener; 
        }
        private function labXObjectListenerTriger(event:String):void{
           if(this.labXObjectListener!=null){
              this.labXObjectListener.eventTriger(event);
              this.labXObjectListener = null;
           }
        }
		public function dispatchEvent(event:Event):void{
		   this.labXObjectListenerTriger(event.type);
		}
		
		//////////////////////////////////////////////////////////////////////
		public var x_min_offset:int = 5;
		public var y_min_offset:int = 5;
        public var z_min_offset:int = 5;
        public function setX_min_offset(offset:int):void{
             this.x_min_offset = offset;
        }
        public function setY_min_offset(offset:int):void{
            this.y_min_offset = offset;
        }
        public function setZ_min_offset(offset:int):void{
            this.z_min_offset = offset;
        }
        
        /*gloab variable**/
        /////////////////////////////////////////////////////////////////
        public  var mainView:BasicView;
        public  var stage_width:int;
        public  var stage_height:int;
	}   
}