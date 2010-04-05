package cn.edu.zju.labx.objects.beam
{
	import org.papervision3d.core.proto.MaterialObject3D;
	public class ParallelCrystal extends Mirror
	{
		public function ParallelCrystal(name:String, material:MaterialObject3D, vertices:Array=null, faces:Array=null)
		{
			super(name, material, vertices, faces);
		}
	}
}