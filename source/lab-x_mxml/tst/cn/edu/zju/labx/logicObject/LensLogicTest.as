package cn.edu.zju.labx.logicObject
{
	import cn.edu.zju.labx.core.LabXConstant;
	
	import flexunit.framework.TestCase;
	
	import org.flintparticles.threeD.geom.Vector3D;
	import org.papervision3d.core.math.Number3D;
	
	public class LensLogicTest extends TestCase
	{
		public function LensLogicTest()
		{
		}

		public function testGetSetPosition():void
		{
			var lens:LensLogic = new LensLogic(new Number3D(1, 1, 1));
			assertEquals(1, lens.position.x);
			assertEquals(1, lens.position.y);
			assertEquals(1, lens.position.z);
			lens.position = new Number3D(100, 200, 300);
			assertEquals(100, lens.position.x);
			assertEquals(200, lens.position.y);
			assertEquals(300, lens.position.z);
		}
		
		public function testGetSetFocalLengt():void
		{
			var lens:LensLogic = new LensLogic();
			assertEquals(LabXConstant.LENS_DEFAULT_FOCAL_LENGTH, lens.f);
			
			lens.f = 1100;
			assertEquals(1100, lens.f);
		}
		
		public function testCalculateRayAfterLens():void
		{
			var rayResult:RayLogic;
			var resultVector:Vector3D;
			
			var lens:LensLogic = new LensLogic(new Number3D(50, 100, 200), 10);
			var ray:RayLogic = new RayLogic(new Number3D(0, 100, 200), new Vector3D(1, 0, 0));
			
			var focusPoint:Number3D = new Number3D(50 + 10, 100, 200)
			
			rayResult = lens.calculateRayAfterLens(ray);
			//first check
			assertEquals(50, rayResult.point.x);
			assertEquals(100, rayResult.point.y);
			assertEquals(200, rayResult.point.z);
			
			resultVector = rayResult.vector.normalize();
			assertEquals(1, resultVector.x);
			assertEquals(0, resultVector.y);
			assertEquals(0, resultVector.z);
			
			assertTrue(rayResult.isPointOnRay(focusPoint));
			
			//second check
			ray = new RayLogic(new Number3D(0, 0, 0), new Vector3D(1, 0, 0));
			rayResult = lens.calculateRayAfterLens(ray);
			assertEquals(50, rayResult.point.x);
			assertEquals(0, rayResult.point.y);
			assertEquals(0, rayResult.point.z);
			
			resultVector = rayResult.vector;
			assertEquals(10, resultVector.y/resultVector.x);
			assertEquals(20, resultVector.z/resultVector.x);
			
			//parallal should across focus point
			assertTrue(rayResult.isPointOnRay(focusPoint));
			
			
			//third check
			ray = new RayLogic(new Number3D(0, 0, 0), new Vector3D(1, 1, 1));
			rayResult = lens.calculateRayAfterLens(ray);
			assertEquals(50, rayResult.point.x);
			assertEquals(50, rayResult.point.y);
			assertEquals(50, rayResult.point.z);
			
			resultVector = rayResult.vector;
			assertEquals(6, resultVector.y/resultVector.x);
			assertEquals(16, resultVector.z/resultVector.x);
			
		}
		
		public function testCalculateRayAfterLensWithMinusFocus():void
		{
			var rayResult:RayLogic;
			var resultVector:Vector3D;
			
			var lens:LensLogic = new LensLogic(new Number3D(50, 100, 200), -10);
			var ray:RayLogic = new RayLogic(new Number3D(0, 100, 200), new Vector3D(1, 0, 0));
			
			var focusPoint:Number3D = new Number3D(50 - 10, 100, 200)
			
			rayResult = lens.calculateRayAfterLens(ray);
			assertTrue(rayResult.isPointOnRay(focusPoint));
			
			ray = new RayLogic(new Number3D(0, 0, 0), new Vector3D(1, 0, 0));
			rayResult = lens.calculateRayAfterLens(ray);
			
			assertTrue(rayResult.isPointOnRay(focusPoint));
			
			
			ray = new RayLogic(focusPoint, new Vector3D(2, 3, 1));
			rayResult = lens.calculateRayAfterLens(ray);
			
			assertEquals(1, rayResult.vector.x);
			
			ray = new RayLogic(focusPoint, new Vector3D(3, 5, 6));
			rayResult = lens.calculateRayAfterLens(ray);
			
			assertEquals(1, rayResult.vector.x);
			
		}
		
	}
}