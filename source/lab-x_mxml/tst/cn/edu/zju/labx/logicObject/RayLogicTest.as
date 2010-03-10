package cn.edu.zju.labx.logicObject
{
	import cn.edu.zju.labx.core.LabXConstant;
	
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
			assertTrue(Math.abs(ray.vector.x-0.5773502691896258) < LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(ray.vector.y-0.5773502691896258) < LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(ray.vector.z-0.5773502691896258) < LabXConstant.NUMBER_PRECISION);
			
			ray.vector = new Vector3D(100, 200, 300);
			assertTrue(Math.abs(ray.vector.x-0.2672612419124244) < LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(ray.vector.y-0.5345224838248488) < LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(ray.vector.z-0.8017837257372732) < LabXConstant.NUMBER_PRECISION);
		}
		
		public function testPointOnRay():void
		{
			var ray:RayLogic = new RayLogic(new Number3D(), new Vector3D(1, 2, 3));
			
			assertTrue(ray.isPointOnRay(new Number3D(0, 0, 0)));
			assertFalse(ray.isPointOnRay(new Number3D(1, 1, 1)));
			assertTrue(ray.isPointOnRay(new Number3D(100, 200, 300)));
			
//			assertEquals(1, ray.vector.x);
//			assertEquals(1, ray.vector.y);
//			assertEquals(1, ray.vector.z);
//			
//			ray.vector = new Vector3D(100, 200, 300);
//			assertEquals(100, ray.vector.x);
//			assertEquals(200, ray.vector.y);
//			assertEquals(300, ray.vector.z);
		}
		
	}
}