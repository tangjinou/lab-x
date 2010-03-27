package cn.edu.zju.labx.objects.beam
{
	import org.papervision3d.core.proto.MaterialObject3D;
	public class PolarizationBeamSplitter extends BeamSplitter
	{
		public function PolarizationBeamSplitter(name:String,material:MaterialObject3D, vertices:Array=null, faces:Array=null)
		{
			super(name, material, vertices, faces);
		}

	}
}