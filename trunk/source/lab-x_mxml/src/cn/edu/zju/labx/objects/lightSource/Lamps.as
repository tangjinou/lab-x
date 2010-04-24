package cn.edu.zju.labx.objects.lightSource
{
	import cn.edu.zju.labx.core.manager.StageObjectsManager;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.objects.primitives.Cylinder;
	import org.papervision3d.view.layer.ViewportLayer;

	public class Lamps extends LightSource
	{
		protected var cube:Cube;
//		protected var sphere:Sphere;
		protected var cylinder:Cylinder;

		public function Lamps(name:String, material:MaterialObject3D=null)
		{
			super(name, material);
			createDisplayObject();
		}

		private function createDisplayObject():void
		{

			var materialsList:MaterialsList=new MaterialsList();
			materialsList.addMaterial(material, "front");
			materialsList.addMaterial(material, "back");
			materialsList.addMaterial(material, "left");
			materialsList.addMaterial(material, "right");
			materialsList.addMaterial(material, "top");
			materialsList.addMaterial(material, "bottom");
			cube=new Cube(materialsList, 50, 50, 120);

//		   sphere = new Sphere(material,50);
			cylinder=new Cylinder(material, 10, 30);
			cylinder.moveRight(20);
			cylinder.moveUp(20);
			cylinder.rotationZ+=90;
			cube.addChild(cylinder);

			addChild(cube);

			var effectLayer:ViewportLayer=new ViewportLayer(StageObjectsManager.getDefault.mainView.viewport, null);
			effectLayer.addDisplayObject3D(this, true);
			StageObjectsManager.getDefault.layerManager.equipmentLayer.addLayer(effectLayer);

			cube.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);

		}

	}
}