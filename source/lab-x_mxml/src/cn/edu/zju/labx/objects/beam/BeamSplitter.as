package cn.edu.zju.labx.objects.beam
{
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.events.LabXObjectUserInputHandleTool;
	import cn.edu.zju.labx.objects.ray.Ray;
	
	import flash.display.BlendMode;
	
	import org.papervision3d.core.geom.TriangleMesh3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.view.layer.ViewportLayer;
	
	public class BeamSplitter extends Beam
	{   
		
		
		public function BeamSplitter(name:String,material:MaterialObject3D,vertices:Array=null, faces:Array=null)
		{
			super(material,name, vertices, faces);
		}
		
		
	     /************************************************************
		 * 
		 *  This is implement of IRayHandle
		 * 
		 ************************************************************/ 
		 
		 /**
		 *  deal with when the ray on the object
		 **/ 
   		override protected function handleRay(oldRay:Ray):void{
   		    this._ray = makeReflectionRay(oldRay);
   		    var ray2:Ray = makePassThroughRay(oldRay);
			displayNewRay(this._ray);
			displayNewRay(ray2);
   		}
   		
    	
    	 /**
		 *   This is for get object with the material on it, it should be overrite 
		 * 
		 *   when the this materials not on the basic object,
		 * 
		 *   for example: lens may not have the materials on 
		 * 
		 *   root,but on the sphere
		 * 
		 */ 
		override public function getObjectWithMaterial():TriangleMesh3D{
		    return displayObject;
		}
	}
}