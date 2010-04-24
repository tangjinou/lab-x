package cn.edu.zju.labx.objects.beam
{
	import cn.edu.zju.labx.objects.ray.Ray;

	import org.papervision3d.core.proto.MaterialObject3D;

	public class Mirror extends Beam
	{
		public function Mirror(name:String, material:MaterialObject3D, vertices:Array=null, faces:Array=null)
		{
			super(material, name, vertices, faces);
		}

		/**
		 *  deal with when the ray on the object
		 **/
		override protected function handleRay(oldRay:Ray):void
		{
			this._ray=makeReflectionRay(oldRay);
			displayNewRay(this._ray);
		}
	}
}