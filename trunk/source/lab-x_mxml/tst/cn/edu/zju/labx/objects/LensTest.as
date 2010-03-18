package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.logicObject.LineRayLogic;
	
	import flexunit.framework.TestCase;
	
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.view.BasicView;

	public class LensTest extends TestCase
	{
		public function LensTest(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function setUp():void
		{
			StageObjectsManager.getDefault.originPivot = new DisplayObject3D();
			StageObjectsManager.getDefault.mainView = new BasicView();
		}
		override public function tearDown():void
		{
			StageObjectsManager.getDefault.originPivot = null;
			StageObjectsManager.getDefault.mainView = null;
		}
		
		public function testCreateLens():void
		{
			var lens:Lens = new Lens(null, 20);
			lens.x = 100;
			lens.y = 200;
			lens.z = 150;
			
			assertTrue(100, lens.x);
		}
		
	}
}