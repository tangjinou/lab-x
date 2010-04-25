package cn.edu.zju.labx.objects.lightSource
{
	import cn.edu.zju.labx.core.manager.StageObjectsManager;
	import cn.edu.zju.labx.core.LabXConstant;
	
	import flash.utils.ByteArray;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.view.layer.ViewportLayer;

	public class Laser extends LightSource
	{
		protected var light:DAE;
		[Embed(source="../assets/models/lightSource.DAE", mimeType="application/octet-stream")]
		public var LightSource_DAE:Class;

		public function Laser(name:String, material:MaterialObject3D=null)
		{
			super(name, material);
			createDisplayObject();
		}
		
		override public function createRay():void
		{
			super.createRay();
			_ray.setColor(LabXConstant.BLUE);
		}

		private function createDisplayObject():void
		{
			light=new DAE(true);
			light.addEventListener(FileLoadEvent.LOAD_COMPLETE, daeFileOnloaded);
			light.load(new LightSource_DAE() as ByteArray, new MaterialsList({all: this.material}));
			addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
		}

		private function daeFileOnloaded(evt:FileLoadEvent):void
		{
			addChild(light);
//			trace(light.childrenList());
			var effectLayer:ViewportLayer=new ViewportLayer(StageObjectsManager.getDefault.mainView.viewport, null);
			effectLayer.addDisplayObject3D(this, true);
			StageObjectsManager.getDefault.layerManager.equipmentLayer.addLayer(effectLayer);
			light.getChildByName("COLLADA_Scene").getChildByName("Cylinder01").addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
			light.getChildByName("COLLADA_Scene").getChildByName("Cylinder02").addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
		}

	}
}