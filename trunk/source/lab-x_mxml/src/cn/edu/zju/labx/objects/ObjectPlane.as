package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.core.StageObjectsManager;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.Rectangle;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.view.layer.ViewportLayer;
	import org.papervision3d.materials.BitmapMaterial;
	
	public class ObjectPlane extends BeamSplitter
	{
		public function ObjectPlane(name:String,material:MaterialObject3D, vertices:Array=null, faces:Array=null)
		{
			super(name,material, vertices, faces);
		}
		
		 /**
		 *  deal with when the ray on the object
		 **/ 
   		override public function onRayHandle(oldRay:Ray):void{
   		    this._ray = makeNewRay2(oldRay);
			if(_ray!=null){
			    StageObjectsManager.getDefault.originPivot.addChild(_ray);
				_ray.displayRays();
				StageObjectsManager.getDefault.rayManager.notify(_ray);
			}
   		}

	}
}