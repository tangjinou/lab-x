package cn.edu.zju.labx.objects
{   
    import cn.edu.zju.labx.core.StageObjectsManager;
    import cn.edu.zju.labx.events.ILabXListener;
    import cn.edu.zju.labx.events.LabXEvent;
    
    import org.papervision3d.events.InteractiveScene3DEvent;
	public class Board extends LabXObject implements ILabXListener
	{   
		public function Board()
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