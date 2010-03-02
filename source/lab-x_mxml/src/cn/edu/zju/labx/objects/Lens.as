package cn.edu.zju.labx.objects
{   
	import cn.edu.zju.labx.events.ILabXListener;
	import cn.edu.zju.labx.events.LabXEvent;
	import cn.edu.zju.labx.objects.LabXObject;
	import cn.edu.zju.labx.core.StageObjectsManager;
	
	public class Lens extends LabXObject implements ILabXListener
	{
		public function Lens()
		{
			super();
		}
		
		public function handleLabXEvent(event:LabXEvent):Boolean{
		   //TODO:
		   
		   
		   return true;
		}
		
	}
}