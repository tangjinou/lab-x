package cn.edu.zju.labx.objects.board
{
	import org.papervision3d.core.proto.MaterialObject3D;
	import cn.edu.zju.labx.objects.ray.Ray;
	
	public class ParallelBeamDetector extends DoubleSlitInterfBoard
	{
		public function ParallelBeamDetector(name:String, material:MaterialObject3D=null)
		{
			super(name, material);
		}
		
		override public function onRayHandle(oldRay:Ray):void
		{
			super.onRayHandle(oldRay);

			if (isParellel(oldRay))
			{
					displayDoubleSlitInterferenceImage(20);
			}

		}
	}
}