package cn.edu.zju.labx.logicObject
{
	import flexunit.framework.TestCase;
	
	import org.flintparticles.threeD.geom.Vector3D;
	import org.papervision3d.core.math.Number3D;

	public class RayLogicTest extends TestCase
	{
		public function RayLogicTest(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function setUp():void {
			super.setUp();
		}
		
		public function testGetSetPoint():void
		{
			var ray:RayLogic = new RayLogic(new Number3D(1, 1, 1));
			assertEquals(1, ray.point.x);
			assertEquals(1, ray.point.y);
			assertEquals(1, ray.point.z);
			
			ray.point = new Number3D(100, 200, 300);
			assertEquals(100, ray.point.x);
			assertEquals(200, ray.point.y);
			assertEquals(300, ray.point.z);
		}
		
		public function testGetSetVector():void
		{
			var ray:RayLogic = new RayLogic(new Number3D(), new Vector3D(1, 1, 1));
			assertEquals(1, ray.vector.x);
			assertEquals(1, ray.vector.y);
			assertEquals(1, ray.vector.z);
			
			ray.vector = new Vector3D(100, 200, 300);
			assertEquals(100, ray.vector.x);
			assertEquals(200, ray.vector.y);
			assertEquals(300, ray.vector.z);
		}
		
	}
}