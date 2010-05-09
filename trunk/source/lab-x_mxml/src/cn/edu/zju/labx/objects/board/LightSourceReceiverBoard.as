package cn.edu.zju.labx.objects.board
{
	import org.papervision3d.core.proto.MaterialObject3D;
	import cn.edu.zju.labx.objects.ray.Ray;
	import cn.edu.zju.labx.core.manager.StageObjectsManager;

	public class LightSourceReceiverBoard extends Board
	{
		public function LightSourceReceiverBoard(name:String, material:MaterialObject3D=null)
		{
			super(name, material);
		}
		
		override protected function handleRay(oldRay:Ray):void
		{
			StageObjectsManager.getDefault.addMessage("get ray");
			return;
		}
	}
}