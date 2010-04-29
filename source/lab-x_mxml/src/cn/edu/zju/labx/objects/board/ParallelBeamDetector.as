package cn.edu.zju.labx.objects.board
{
	import cn.edu.zju.labx.objects.beam.ParallelCrystal;
	import cn.edu.zju.labx.objects.ray.LineRay;
	import cn.edu.zju.labx.objects.ray.Ray;
	import cn.edu.zju.labx.utils.MathUtils;
	
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	
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
						var angleOfBoard:Number=MathUtils.calculateAngleOfTwoVector(Number3D.sub(lineRay.end_point, lineRay.start_point), this.getNormal());
						if (angleOfBoard > Math.PI/6*5)
						{
							var lineRay2:LineRay = oldRay.getLineRays().getItemAt(1) as LineRay;
							var angleOfLight:Number = MathUtils.calculateAngleOfTwoVector(
								Number3D.sub(lineRay.end_point, lineRay.start_point),
								Number3D.sub(lineRay2.end_point, lineRay2.start_point));
							displayDoubleSlitInterferenceImage(angleOfLight);
//							trace(angleOfLight);
						}
					}
				}
			}

		}
	}
}