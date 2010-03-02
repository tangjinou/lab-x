package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.events.ILabXListener;
	
	import org.papervision3d.core.geom.TriangleMesh3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	
	
	public class LabXObject extends TriangleMesh3D
	{   
		public function LabXObject(){
		   super(null, new Array(), new Array(), null );
		}
	}
}