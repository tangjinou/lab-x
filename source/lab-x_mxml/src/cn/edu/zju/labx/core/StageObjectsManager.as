package cn.edu.zju.labx.core
{
	import cn.edu.zju.labx.events.LabXEvent;
	import cn.edu.zju.labx.objects.LabXObject;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	public  class StageObjectsManager
	{   
		
		public static function get getDefault():StageObjectsManager
		{
			if (instance == null)
				instance = new StageObjectsManager();
			return instance;	
		}

		protected  var instance:StageObjectsManager = null;
		
		public  var list:ArrayCollection =new ArrayCollection();
				
		public   function addLabXObject(obj:LabXObject):void
		{
			list.addItem(obj);
		}
		
		public  function removeLabXObject(obj:LabXObject):void
		{
			list.removeItemAt(obj);
		}
		
		public  function notify(event:LabXEvent):void {
			
		}

	}
}