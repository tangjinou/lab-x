package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.core.StageObjectsManager;
	
	import org.papervision3d.core.proto.MaterialObject3D;

	public class Mirror extends SplitterBeam
	{
		public function Mirror(material:MaterialObject3D, vertices:Array=null, faces:Array=null, name:String=null)
		{
			super(material, vertices, faces, name);
		}
		
		 /**
		 *  deal with when the ray on the object
		 **/ 
   		override public function onRayHanle(oldRay:Ray):void{
   		    this._ray = makeNewRay2(oldRay);
			if(_ray!=null){
			    StageObjectsManager.getDefault.originPivot.addChild(_ray);
				_ray.displayRays();
				StageObjectsManager.getDefault.rayManager.notify(_ray);
			}
   		}
		
	}
}