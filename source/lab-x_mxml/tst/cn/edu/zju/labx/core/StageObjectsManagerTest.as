package cn.edu.zju.labx.core
{
	import cn.edu.zju.labx.objects.Lens;
	import cn.edu.zju.labx.objects.Ray;

	import flexunit.framework.TestCase;

	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.view.BasicView;

	public class StageObjectsManagerTest extends TestCase
	{
		public function StageObjectsManagerTest(methodName:String=null)
		{
			super(methodName);
		}

		override public function setUp():void
		{
			StageObjectsManager.getDefault.originPivot=new DisplayObject3D();
			StageObjectsManager.getDefault.mainView=new BasicView();
		}

		override public function tearDown():void
		{
			StageObjectsManager.getDefault.originPivot=null;
			StageObjectsManager.getDefault.mainView=null;
		}

		public function testStageObjectsManager():void
		{
			var lens:Lens=new Lens();
			assertTrue(lens != null);
			var ray:Ray=new Ray();
			assertTrue(ray != null);
		}


	}
}