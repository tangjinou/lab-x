package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.events.LabXEvent;
	import cn.edu.zju.labx.logicObject.RayLogic;
	
	import flexunit.framework.TestCase;
	
	import mx.collections.ArrayCollection;
	
	import org.flintparticles.threeD.geom.Vector3D;
	import org.papervision3d.core.math.Number3D;

	public class LensTest extends TestCase
	{
		public function LensTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public function testCreateLens():void
		{
			var lens:Lens = new Lens(null, 20);
			lens.x = 100;
			lens.y = 200;
			lens.z = 150;
			
			assertTrue(100, lens.x);
		}
		
		public function testProcessRay():void
		{
			var lens:Lens = new Lens(null, 20);
			lens.x = 100;
			lens.y = 200;
			lens.z = 150;
			
			var focusPoint:Number3D = new Number3D(lens.x + 20, 200, 150);
			
			var lineRays:ArrayCollection = new ArrayCollection();
			lineRays.addItem(new LineRay(new RayLogic(new Number3D(0, 100, 100), new Vector3D(1, 0, 0))));
			lineRays.addItem(new LineRay(new RayLogic(new Number3D(0, 120, 100), new Vector3D(1, 0, 0))));
			var oldRay:Ray = new Ray(null, lineRays, 20);
			
			var rayMaker:MockRayMaker = new MockRayMaker()
			rayMaker.setRay(oldRay);
			
			lens.handleLabXEvent(new LabXEvent(rayMaker));
			var resultRay:Ray = lens.getRay();
			
//			assertEquals(100, ray.startX);
			assertEquals(2, resultRay.getLineRays().length);
			
			for each (var lineRay:LineRay in resultRay.getLineRays())
			{
				assertTrue(lineRay.logic.isPointOnRay(focusPoint));
			} 
		}
		
	}
}