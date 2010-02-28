package cn.edu.zju.labx.core
{
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
			
			assertTrue(lens ==null);
//			var ray:Ray =new Ray();
//			StageObjectsManager.getDefault().addLabXObject(lens);
//			StageObjectsManager.getDefault().addLabXObject(ray);
//			assertEquals(2,StageObjectsManager.getdefault().list.length);
			
		}
	}
}