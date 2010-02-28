package cn.edu.zju.labx.core
{
	import cn.edu.zju.labx.events.LabXEvent;
	import cn.edu.zju.labx.objects.LabXObject;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	public static class StageObjectsManager
	{   
		public var list:ArrayCollection =new ArrayCollection();
		
		public function StageObjectsManager()
		{
		}
		
		public function addLabXObject(obj:LabXObject):void
		{
			list.addItem(obj);
		}
		
		public function removeLabXObject(obj:LabXObject):void
		{
			list.removeItemAt(obj);
		}
		
		public function notify(event:LabXEvent):void {
			
		}

	}
}