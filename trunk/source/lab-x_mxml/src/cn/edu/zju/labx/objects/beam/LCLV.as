package cn.edu.zju.labx.objects.beam
{
	import cn.edu.zju.labx.objects.ray.LineRay;
	import cn.edu.zju.labx.objects.ray.Ray;
	
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;

	public class LCLV extends Beam
	{
		private var imageInfo:ArrayCollection;
		public function LCLV(name:String, material:MaterialObject3D, vertices:Array=null, faces:Array=null)
		{
			super(material, name, vertices, faces);
		}


		override protected function handleRay(oldRay:Ray):void
		{
			if (oldRay.getLineRays() == null || oldRay.getLineRays().length == 0)
				return;
			if (!(oldRay.getOtherInfo() is ArrayCollection))return;
			var lineRay:LineRay=oldRay.getLineRays().getItemAt(0) as LineRay;
			var lineRayNormal:Number3D=new Number3D(lineRay.logic.dx, lineRay.logic.dy, lineRay.logic.dz);
			var normal:Number3D=getNormal();
			if (Number3D.dot(lineRayNormal, normal) < 0)
			{
				var ray:Ray = makeReflectionRay(oldRay, true);
				var newInfo:ArrayCollection = (oldRay.getOtherInfo() as ArrayCollection) || (new ArrayCollection());
				if(this.imageInfo != null)
				{
					//should sort the shapes 
					for each (var item:Shape in this.imageInfo)
					{
						//TODO:should scale from the center of the shape.
						var tmpscale:Number = 0.5;
						item.transform.matrix = new Matrix(tmpscale, 0, 0, tmpscale, -depth/2*(tmpscale-1), -height/2*(tmpscale-1));
						newInfo.addItem(item);
					}
				}
				displayNewRay(ray);
			}
			else
			{
				//do nothing
				if(oldRay != null)this.imageInfo = oldRay.getOtherInfo() as ArrayCollection;
			}
		}
	}
}