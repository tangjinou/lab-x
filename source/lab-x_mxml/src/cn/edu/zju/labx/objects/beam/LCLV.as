package cn.edu.zju.labx.objects.beam
{
	import cn.edu.zju.labx.objects.ray.LineRay;
	import cn.edu.zju.labx.objects.ray.Ray;
	
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;

	public class LCLV extends Beam
	{
		public function LCLV(name:String, material:MaterialObject3D, vertices:Array=null, faces:Array=null)
		{
			super(material, name, vertices, faces);
		}
		
		
		override protected function handleRay(oldRay:Ray):void
		{
			if (oldRay.getLineRays() == null || oldRay.getLineRays().length == 0) return;
			var lineRay:LineRay = oldRay.getLineRays().getItemAt(0) as LineRay;
			var lineRayNormal:Number3D = new Number3D(lineRay.logic.dx, lineRay.logic.dy, lineRay.logic.dz);
			var normal:Number3D = getNormal();
			if (Number3D.dot(lineRayNormal, normal) < 0)
			{
				displayNewRay(makeReflectionRay(oldRay, true));
			} else
			{
				//do nothing
			}
		}
	}
}