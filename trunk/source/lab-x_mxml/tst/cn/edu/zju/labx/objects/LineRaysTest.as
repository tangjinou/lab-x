package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.core.LabXConstant;
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
		  assertTrue(Math.abs(lineRays.end_point.y-103.16227766016839) < LabXConstant.NUMBER_PRECISION);
		  assertTrue(Math.abs(lineRays.end_point.z-209.48683298050514) < LabXConstant.NUMBER_PRECISION);
       }
       
       public function testLineRays2():void{
       	   var startPonit:Vertex3D = new Vertex3D(0,0,0);
       	   var endPoint:Vertex3D = new Vertex3D(1,2,2);
           var lineRays:LineRay = new LineRay();
           lineRays.newLineRay(startPonit,endPoint);
           assertEquals(3,lineRays._length);
           assertEquals(0.3333333333333333,lineRays.vector.x);
           assertEquals(0.6666666666666666,lineRays.vector.y);
           assertEquals(0.6666666666666666,lineRays.vector.z);
       }
	}
}