package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.logicObject.RayLogic;
	
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.core.math.Number3D;
	
	public class MockRayMaker extends LabXObject implements IRayMaker
	{
		var _ray:Ray;
		public function MockRayMaker()
		{
			super(null);
		}
		public function getRay():Ray
		{
			return this._ray;
		}
		public function setRay(ray:Ray):void
		{
			this._ray = ray;
		}
	}
}