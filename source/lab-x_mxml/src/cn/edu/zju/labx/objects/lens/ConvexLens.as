package cn.edu.zju.labx.objects.lens
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.utils.ResourceManager;

	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.events.InteractiveScene3DEvent;

	public class ConvexLens extends Lens
	{
		public function ConvexLens(name:String, material:MaterialObject3D=null, focus:Number=LabXConstant.LENS_DEFAULT_FOCAL_LENGTH)
		{
//			lens_dae_url = ResourceManager.CONVEX_LENS_DAE_URL;
			super(name, material, focus);
		}

		override protected function daeFileOnloaded(evt:FileLoadEvent):void
		{
			super.daeFileOnloaded(evt);
			lens.getChildByName("COLLADA_Scene").getChildByName("Sphere02").addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
			lens.getChildByName("COLLADA_Scene").getChildByName("Sphere01").addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
		}

	}
}