package cn.edu.zju.labx.core
{
	import cn.edu.zju.labx.events.ILabXListener;
	import cn.edu.zju.labx.events.LabXEvent;
	
	import mx.collections.ArrayCollection;
	
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

	}
}