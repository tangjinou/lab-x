package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.events.ILabXListener;
	
	import org.papervision3d.core.geom.TriangleMesh3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	
	
	public class LabXObject extends TriangleMesh3D
	{   
		public var labXObject:ILabXListener;
		public var x_min_offset:int =0;
		public var y_min_offset:int =0;
        public var z_min_offset:int =0;
		
		public function LabXObject(labXObject:ILabXListener,material:MaterialObject3D=null){
		   super(material, new Array(), new Array(), null );
		   this.labXObject =labXObject;
		   x_min_offset = StageObjectsManager.getDefault.x_min_offset;
		   y_min_offset = StageObjectsManager.getDefault.y_min_offset;
		   z_min_offset = StageObjectsManager.getDefault.z_min_offset;
		}
		
		 protected function objectPressHandler(event:InteractiveScene3DEvent):void{
		     StageObjectsManager.getDefault.setNextObjectListener(this);
		 }
	    
	    /*
		*  if want to use it,should be override it
		*/
	    public  function eventTriger(event:String):void{
	    }
	    
	    
	}
}