package cn.edu.zju.labx.objects
{   
	import cn.edu.zju.labx.events.ILabXListener;
	import cn.edu.zju.labx.events.LabXEvent;
	import cn.edu.zju.labx.core.StageObjectsManager;
	public class Ray extends LabXObject implements ILabXListener
	{
		public function Ray()
		{
			super(this);
		}
	    
	    public function handleLabXEvent(event:LabXEvent):Boolean{
		   //TODO:
		   return true;
		}
		
	    override public  function eventTriger(event:String):void{
	    }
	}
}