package cn.edu.zju.labx.objects.lightSource
{
	import cn.edu.zju.labx.core.StageObjectsManager;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.objects.primitives.Cylinder;
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.view.layer.ViewportLayer;

	public class Lamps extends LightSource
	{
		protected var sphere:Sphere;
		protected var cylinder:Cylinder;
		
		public function Lamps(name:String, material:MaterialObject3D=null)
		{
			super(name, material);
			createDisplayObject();
		}
		
		private function createDisplayObject():void{
		   
		   sphere = new Sphere(material,50);
		   cylinder = new Cylinder(material,10,30);
		   cylinder.moveRight(50);
		   cylinder.rotationZ +=90;
		   sphere.addChild(cylinder);
		  
		   this.addChild(sphere);
		   
		   var effectLayer:ViewportLayer = new ViewportLayer(StageObjectsManager.getDefault.mainView.viewport, null);
		   effectLayer.addDisplayObject3D(this, true);
		   StageObjectsManager.getDefault.layerManager.equipmentLayer.addLayer(effectLayer);
		  
		   sphere.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
		   
		}
		
	}
}