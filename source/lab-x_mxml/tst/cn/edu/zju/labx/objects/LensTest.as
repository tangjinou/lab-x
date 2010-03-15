package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.events.LabXEvent;
	import cn.edu.zju.labx.logicObject.LineRayLogic;
	
	import flexunit.framework.TestCase;
	
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.objects.DisplayObject3D;

	public class LensTest extends TestCase
	{
		public function LensTest(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function setUp():void
		{
			StageObjectsManager.getDefault.originPivot = new DisplayObject3D();
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
			lineRays.addItem(new LineRay(new LineRayLogic(new Number3D(0, 10, 250), new Number3D(1, 0, 0))));
			lineRays.addItem(new LineRay(new LineRayLogic(new Number3D(0, 50, 250), new Number3D(1, 0, 0))));
			var oldRay:Ray = new Ray(null, lineRays, 20);
			
			var rayMaker:MockRayMaker = new MockRayMaker()
			rayMaker.x = 0;
			rayMaker.setRay(oldRay);
			
			
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