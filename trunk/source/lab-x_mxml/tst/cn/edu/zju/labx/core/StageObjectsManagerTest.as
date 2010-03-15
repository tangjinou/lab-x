package cn.edu.zju.labx.core
{
	import cn.edu.zju.labx.objects.ConcaveLens;
	import cn.edu.zju.labx.objects.Lens;
	import cn.edu.zju.labx.objects.Ray;
	
	import flexunit.framework.TestCase;

	public class StageObjectsManagerTest extends TestCase
	{
		public function StageObjectsManagerTest(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function setUp():void
		{
		}
		public function testStageObjectsManager():void{
			var lens:Lens =new ConcaveLens();
			assertTrue(lens != null);
			var ray:Ray =new Ray();
			assertTrue(ray != null);
		}
		

	}
}