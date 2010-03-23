package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.core.LabXConstant;
	
	import org.papervision3d.core.proto.MaterialObject3D;

	public class FourierLens extends Lens
	{
		public function FourierLens(name:String, material:MaterialObject3D=null, focus:Number=LabXConstant.LENS_DEFAULT_FOCAL_LENGTH)
		{
			super(name, material, focus);
		}
		
	}
}