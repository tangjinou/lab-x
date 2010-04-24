package cn.edu.zju.labx.objects.beam
{
	import cn.edu.zju.labx.core.manager.StageObjectsManager;
	import cn.edu.zju.labx.objects.ray.LineRay;
	import cn.edu.zju.labx.objects.ray.Ray;
	
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.shadematerials.PhongMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.view.layer.ViewportLayer;

	public class PolarizationBeamSplitter extends BeamSplitter
	{
		public function PolarizationBeamSplitter(name:String, material:MaterialObject3D, vertices:Array=null, faces:Array=null)
		{
			super(name, material, vertices, faces);
		}

		/**
		 *  deal with when the ray on the object
		 **/
		override protected function handleRay(oldRay:Ray):void
		{
			var lineRay:LineRay=oldRay.getLineRays().getItemAt(0) as LineRay;
			var lineRayNormal:Number3D=new Number3D(lineRay.logic.dx, lineRay.logic.dy, lineRay.logic.dz);
			var normal:Number3D=getNormal();
			if (Number3D.dot(lineRayNormal, normal) < 0)
			{
				displayNewRay(makePassThroughRay(oldRay));
			}
			else
			{
				displayNewRay(makeReflectionRay(oldRay, true));
			}
		}

		override public function createDisplayObject():void
		{

			width=3;
			depth=100;
			var materialsList:MaterialsList=new MaterialsList();
			materialsList.addMaterial(material, "front");
			materialsList.addMaterial(material, "back");
			materialsList.addMaterial(material, "left");
			materialsList.addMaterial(material, "right");
			materialsList.addMaterial(material, "top");
			materialsList.addMaterial(material, "bottom");
			var inner:Cube=new Cube(materialsList, width, depth * Math.sqrt(2), height);

			var light:PointLight3D=new PointLight3D(true);
			light.x=200;
			light.y=150;
			light.z=-400;
			var outMaterial:PhongMaterial=new PhongMaterial(light, 0xFFFFFF, 0xff0000, 100);
			outMaterial.interactive=true;
			var outMatList:MaterialsList=new MaterialsList();
			outMatList.addMaterial(outMaterial, "front");
			outMatList.addMaterial(outMaterial, "back");
			outMatList.addMaterial(outMaterial, "left");
			outMatList.addMaterial(outMaterial, "right");
			outMatList.addMaterial(outMaterial, "top");
			outMatList.addMaterial(outMaterial, "bottom");
			displayObject=new Cube(outMatList, 100, depth, height);
			displayObject.alpha=0.3;
			var effectLayer:ViewportLayer=new ViewportLayer(StageObjectsManager.getDefault.mainView.viewport, null);
			effectLayer.addDisplayObject3D(inner, true);
			effectLayer.addDisplayObject3D(displayObject, true);
			effectLayer.alpha=0.7;
			StageObjectsManager.getDefault.layerManager.equipmentLayer.addLayer(effectLayer);
			inner.localRotationY=45;
			displayObject.localRotationY=-45;
			displayObject.addChild(inner);
			this.addChild(displayObject);
		}

	}
}