package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.logicObject.RayLogic;
	
	import flexunit.framework.TestCase;
	
	import org.flintparticles.threeD.geom.Vector3D;
	import org.papervision3d.core.math.Number3D;
	
	public class LineRaysTest extends TestCase
	{
       public function testLineRays():void{
          
          var rayLogic:RayLogic = new RayLogic(new Number3D(0, 100, 200), new Vector3D(1, 0, 0));
          
          assertEquals(0, rayLogic.point.x);
		  assertEquals(100, rayLogic.point.y);
		  assertEquals(200, rayLogic.point.z);
          
       }
	}
}