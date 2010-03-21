package cn.edu.zju.labx.logicObject
{
	import cn.edu.zju.labx.core.LabXConstant;
	
	import flexunit.framework.TestCase;
	
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Plane3D;
	
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
			var rayResult:LineRayLogic;
			
			var lens:LensLogic = new LensLogic(new Number3D(50, 100, 200), new Number3D(1, 0, 0), 10);
			var ray:LineRayLogic = new LineRayLogic(new Number3D(0, 100, 200), new Number3D(1, 0, 0));
			
			var focusPoint:Number3D = new Number3D(50 + 10, 100, 200)
			
			rayResult = lens.processRay(ray);
			//first check
			assertEquals(50, rayResult.x);
			assertEquals(100, rayResult.y);
			assertEquals(200, rayResult.z);
			
			assertEquals(1, rayResult.dx);
			assertEquals(0, rayResult.dy);
			assertEquals(0, rayResult.dz);
			
			assertTrue(rayResult.isPointOnRay(focusPoint));
			
			//second check
			ray = new LineRayLogic(new Number3D(0, 0, 0), new Number3D(1, 0, 0));
			rayResult = lens.processRay(ray);
			assertEquals(50, rayResult.x);
			assertEquals(0, rayResult.y);
			assertEquals(0, rayResult.z);
			
			assertEquals(10, rayResult.dy/rayResult.dx);
			assertEquals(20, rayResult.dz/rayResult.dx);
			
			//parallal should across focus point
			assertTrue(rayResult.isPointOnRay(focusPoint));
			
			
			//third check
			ray = new LineRayLogic(new Number3D(0, 0, 0), new Number3D(1, 1, 1));
			rayResult = lens.processRay(ray);
			assertTrue(Math.abs(50 - rayResult.x)<LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(50 - rayResult.y)<LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(50 - rayResult.z)<LabXConstant.NUMBER_PRECISION);
//			assertEquals(0.05842062, rayResult.dx);
			assertTrue(Math.abs(0.05842062-rayResult.dx)<LabXConstant.NUMBER_PRECISION);//0.058420623783698599874242158001465
			assertTrue(Math.abs(0.35052374-rayResult.dy)<LabXConstant.NUMBER_PRECISION);//0.35052374270219159924545294800879
			assertTrue(Math.abs(0.93472998-rayResult.dz)<LabXConstant.NUMBER_PRECISION);//0.93472998053917759798787452802344
			
			
			//ray pass focus point will parallel after concave lens
			var anotherFocus:Number3D = new Number3D(50 - 10, 100, 200);
			ray = new LineRayLogic(anotherFocus, new Number3D(2, 3, 1));
			rayResult = lens.processRay(ray);
			assertEquals(1, rayResult.dx);
			
			ray = new LineRayLogic(anotherFocus, new Number3D(3, 5, 6));
			rayResult = lens.processRay(ray);
			assertEquals(1, rayResult.dx); 
		}
		
		public function testprocessRayWithMinusFocus():void
		{
			var rayResult:LineRayLogic;
			var lens:LensLogic = new LensLogic(new Number3D(50, 100, 200),new Number3D(1, 0, 0), -10);
			var ray:LineRayLogic = new LineRayLogic(new Number3D(0, 100, 200), new Number3D(1, 0, 0));
			
			var focusPoint:Number3D = new Number3D(50 - 10, 100, 200)
			
			rayResult = lens.processRay(ray);
			assertTrue(rayResult.isPointOnRay(focusPoint));
			
			ray = new LineRayLogic(new Number3D(0, 0, 0), new Number3D(1, 0, 0));
			rayResult = lens.processRay(ray);
			
			assertTrue(rayResult.isPointOnRay(focusPoint));
			
			//ray pass another side focus point will parallel after concave lens
			var anotherFocus:Number3D = new Number3D(50 + 10, 100, 200);
			
			var v:Number3D = new Number3D(2, 3, 1);
//			ray = new LineRayLogic(anotherFocus, v);
//			rayResult = lens.processRay(ray);
//			assertNull(rayResult);//the ray is not pass through the lens.
			
			//we should make the ray start point from another side.
			v.normalize();
			ray = new LineRayLogic(new Number3D(anotherFocus.x-100*v.x, anotherFocus.y-100*v.y, anotherFocus.z-100*v.z), v);
			rayResult = lens.processRay(ray);
			assertEquals(1, rayResult.dx);
			
			v = new Number3D(3, 5, 6);
			v.normalize();
			ray = new LineRayLogic(new Number3D(anotherFocus.x-100*v.x, anotherFocus.y-100*v.y, anotherFocus.z-100*v.z), v);
			rayResult = lens.processRay(ray);
			assertEquals(1, rayResult.dx); 
		}
		
		
		public function testRoundLensCalculateRay():void
		{
			var rayResult:LineRayLogic;
			var lens:LensLogic = new LensLogic(new Number3D(50, 150, 200),new Number3D(5, 2, 17), -40);
			var ray:LineRayLogic = new LineRayLogic(new Number3D(0, 100, 200), new Number3D(1, 0, 0));
			
			rayResult = lens.processRay(ray);
			
			assertTrue(Math.abs(rayResult.x-70) < LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(rayResult.y-100) < LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(rayResult.z-200) < LabXConstant.NUMBER_PRECISION);
			
			//NEED More check
			trace("Dx:" + rayResult.dx); //0.4886033689318434
			trace("Dy:" + rayResult.dy); //-0.8725060159497201
			trace("Dz:" + rayResult.dz); //0
//			assertEquals(0.95586051, rayResult.dx);
//			assertTrue(Math.abs(rayResult.dx-(0.95586051)) < LabXConstant.NUMBER_PRECISION);
//			assertTrue(Math.abs(rayResult.dy+0.29382083) < LabXConstant.NUMBER_PRECISION);
//			assertTrue(Math.abs(rayResult.dz-0) < LabXConstant.NUMBER_PRECISION);
		}
		
		
		
		public function testFocusLengthBUG():void
		{
			var lineRayLogic:LineRayLogic = new LineRayLogic(new Number3D(300, 62, -166.7), new Number3D(0.9488760116444964, 0, 0.31564903694710283));
			
			var position1:Number3D = new Number3D(380, 60, -140);
			var normal1:Number3D = new Number3D(-0.9483236552061993, 0, -0.31730465640509214);
			var lensLogic1:LensLogic = new LensLogic(position1, normal1, 30);
			var result1:LineRayLogic = lensLogic1.processRay(lineRayLogic);
			
			trace(result1.dx);
			trace(result1.dy);
			trace(result1.dz);
			
//0.9173178294405009
//-0.2425271093324738
//0.31576668764992094


			
			
			var position2:Number3D = new Number3D(500, 60, -100);
			var normal2:Number3D = new Number3D(-0.9483236552061993, 0, -0.31730465640509214);
			var plane2:Plane3D = new Plane3D(normal2,position2);
			
			trace(plane2.distance(position1)); //126.49102488094758
			trace(Number3D.sub(position1, position2).modulo);
			
			var lensLogic2:LensLogic = new LensLogic(position2, normal2, 96);
			var result2:LineRayLogic = lensLogic2.processRay(result1);
			
			trace(result2.dx);
			trace(result2.dy);
			trace(result2.dz);
//0.9472891563977228
//0.06836346298527674
//0.3130011039915857
			
		}
		
	}
}