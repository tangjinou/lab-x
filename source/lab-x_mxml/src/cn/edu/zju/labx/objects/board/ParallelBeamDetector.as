package cn.edu.zju.labx.objects.board
{
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.core.math.Number3D;
	
	import cn.edu.zju.labx.objects.ray.Ray;
	import cn.edu.zju.labx.objects.ray.LineRay;
	import cn.edu.zju.labx.objects.beam.ParallelCrystal;
	import cn.edu.zju.labx.utils.MathUtils;
	
	public class ParallelBeamDetector extends DoubleSlitInterfBoard
	{
		public function ParallelBeamDetector(name:String, material:MaterialObject3D=null)
		{
			super(name, material);
		}
		
		override protected function handleRay(oldRay:Ray):void
		{
			if (isParellel(oldRay))
			{
				if (oldRay.getSender() is ParallelCrystal)
				{
					var lineRay:LineRay=oldRay.getLineRays().getItemAt(0) as LineRay;
					if (lineRay != null)
					{
						var angle:Number=MathUtils.calculateAngleOfTwoVector(Number3D.sub(lineRay.end_point, lineRay.start_point), this.getNormal());
						if (angle > Math.PI/6*5)
						{
							displayDoubleSlitInterferenceImage(Math.PI / 180 * 30);
						}
					}
				}
			}

		}
	}
}