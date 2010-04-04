package cn.edu.zju.labx.logicObject
{
	import flexunit.framework.TestCase;

	import org.papervision3d.core.math.Number3D;

	public class LineRayLogicTest extends TestCase
	{
		public function LineRayLogicTest(methodName:String=null)
		{
			super(methodName);
		}

		override public function setUp():void
		{
			super.setUp();
		}

		public function testGetSetPoint():void
		{
			var ray:LineRayLogic=new LineRayLogic(new Number3D(1, 1, 1));
			assertEquals(1, ray.x);
			assertEquals(1, ray.y);
			assertEquals(1, ray.z);
		}

		public function testPointOnRay():void
		{
			var ray:LineRayLogic=new LineRayLogic(new Number3D(0, 0, 0), new Number3D(1, 2, 3));

			assertTrue(ray.isPointOnRay(new Number3D(0, 0, 0)));
			assertFalse(ray.isPointOnRay(new Number3D(1, 1, 1)));
			assertTrue(ray.isPointOnRay(new Number3D(100, 200, 300)));
		}

	}
}