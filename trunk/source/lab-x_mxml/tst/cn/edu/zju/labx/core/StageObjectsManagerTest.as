package cn.edu.zju.labx.core
{
	import cn.edu.zju.labx.events.LabXEvent;
	import cn.edu.zju.labx.objects.Board;
	import cn.edu.zju.labx.objects.Lens;
	import cn.edu.zju.labx.objects.Ray;
	
	import flexunit.framework.TestCase;
	
	import mx.collections.ArrayCollection;

	public class StageObjectsManagerTest extends TestCase
	{
		public function StageObjectsManagerTest(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function setUp():void
		{
			StageObjectsManager.getDefault.getLabXListeners().removeAll();
			StageObjectsManager.getDefault.getLabXObjects().removeAll();
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
			assertEquals(2,StageObjectsManager.getDefault.notify_count);
		}
		
		public function testSortListener():void{
			var lens1:Lens =new Lens();
			var lens2:Lens =new Lens();
			var lens3:Lens =new Lens();
			var lens4:Lens =new Lens();
			
			lens1.x = 50;
			lens2.x = 40;
			lens3.x = 100;
			lens4.x = 45;
			
			StageObjectsManager.getDefault.addLabXObject(lens1);
			StageObjectsManager.getDefault.addLabXObject(lens2);
			var listeners:ArrayCollection = StageObjectsManager.getDefault.getLabXListeners();
			assertEquals(lens2, listeners.getItemAt(0));
			assertEquals(lens1, listeners.getItemAt(1));
			
			StageObjectsManager.getDefault.addLabXObject(lens3);
			StageObjectsManager.getDefault.addLabXObject(lens4);
			assertEquals(lens2, listeners.getItemAt(0));
			assertEquals(lens4, listeners.getItemAt(1));
			assertEquals(lens1, listeners.getItemAt(2));
			assertEquals(lens3, listeners.getItemAt(3));
			
		}
	}
}