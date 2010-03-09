package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.logicObject.RayLogic;
	
	import flexunit.framework.TestCase;
	
	import org.flintparticles.threeD.geom.Vector3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.Number3D;
	
	public class LineRaysTest extends TestCase
	{
       public function testLineRays():void{
          
          var rayLogic:RayLogic = new RayLogic(new Number3D(0, 100, 200), new Vector3D(0, 0.1, 0.3));
          assertEquals(0, rayLogic.point.x);
		  assertEquals(100, rayLogic.point.y);
		  assertEquals(200, rayLogic.point.z);
		  var lineRays:LineRay = new LineRay(rayLogic,10);
		  assertEquals(0, lineRays.end_point.x);
		  assertEquals(101, lineRays.end_point.y);
		  assertEquals(203, lineRays.end_point.z);
       }
       
       public function testLineRays2():void{
       	   var startPonit:Vertex3D = new Vertex3D(0,0,0);
       	   var endPoint:Vertex3D = new Vertex3D(1,1,1);
           var lineRays:LineRay = new LineRay();
           lineRays.newLineRay(startPonit,endPoint);
           
           
       }
	}
}