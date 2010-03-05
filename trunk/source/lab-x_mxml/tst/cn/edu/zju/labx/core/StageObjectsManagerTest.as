package cn.edu.zju.labx.core
{
	import cn.edu.zju.labx.events.LabXEvent;
	import cn.edu.zju.labx.objects.Board;
	import cn.edu.zju.labx.objects.Lens;
	import cn.edu.zju.labx.objects.Ray;
	
	import flexunit.framework.TestCase;

	public class StageObjectsManagerTest extends TestCase
	{
		public function StageObjectsManagerTest(methodName:String=null)
		{
			super(methodName);
		}
		public function testStageObjectsManager():void{
			var lens:Lens =new Lens();
			assertTrue(lens != null);
			var ray:Ray =new Ray();
			assertTrue(ray != null);
			StageObjectsManager.getDefault.addLabXObject(lens);
			StageObjectsManager.getDefault.addLabXObject(ray);
			assertEquals(2,StageObjectsManager.getDefault.getLabXObjects().length);
			assertEquals(1,StageObjectsManager.getDefault.getLabXListeners().length);
			StageObjectsManager.getDefault.removeLabXObject(lens);
			assertEquals(1,StageObjectsManager.getDefault.getLabXObjects().length);
			assertEquals(0,StageObjectsManager.getDefault.getLabXListeners().length);
			StageObjectsManager.getDefault.addLabXObject(lens);
			StageObjectsManager.getDefault.addLabXObject(new Board());
			StageObjectsManager.getDefault.notify(new LabXEvent(ray, "this is event~"));
//			assertEquals(3,StageObjectsManager.getDefault.notify_count);
		}
	}
}