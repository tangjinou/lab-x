package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.utils.ResourceManager;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import org.papervision3d.core.geom.TriangleMesh3D;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.view.layer.ViewportLayer;
		
	public class Desk
	{
		private var desk:DAE; 
		
		public function Desk()
		{
			var imgLoader:Loader = new Loader();
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,textureLoaded);
			imgLoader.load(new URLRequest(ResourceManager.DESK_TEXTURE));
			
		}
		private function textureLoaded(evt:Event):void
		{
			var bitmap:Bitmap = evt.target.content as Bitmap;
			var bitmapMaterial:BitmapMaterial = new BitmapMaterial(bitmap.bitmapData);
			bitmapMaterial.interactive = true;
			bitmapMaterial.smooth = true;
			bitmapMaterial.tiled = true;
			desk = new DAE();  
			desk.addEventListener(FileLoadEvent.LOAD_COMPLETE, deskOnLoaded);
            DAE(desk).load(ResourceManager.DESK_DAE_URL, new MaterialsList({all:bitmapMaterial}));
            desk.scale = 3;
            desk.scaleX = 6;
            desk.scaleZ = 5;
		}
		
		private function deskOnLoaded(evt:FileLoadEvent):void{

			desk.moveDown(LabXConstant.STAGE_HEIGHT/2-40);
            desk.moveRight(LabXConstant.STAGE_WIDTH/2);
            StageObjectsManager.getDefault.originPivot.addChild(desk);
            StageObjectsManager.getDefault.layerManager.deskLayer.addDisplayObject3D(desk.getChildByName("COLLADA_Scene").getChildByName("ChamferBox01"), true);
            StageObjectsManager.getDefault.layerManager.deskLegLayer.addDisplayObject3D(desk.getChildByName("COLLADA_Scene").getChildByName("Cylinder05"), true);
            StageObjectsManager.getDefault.layerManager.deskLegLayer.addDisplayObject3D(desk.getChildByName("COLLADA_Scene").getChildByName("Cylinder10"), true);
            StageObjectsManager.getDefault.layerManager.deskLegLayer.addDisplayObject3D(desk.getChildByName("COLLADA_Scene").getChildByName("Cylinder15"), true);
            StageObjectsManager.getDefault.layerManager.deskLegLayer.addDisplayObject3D(desk.getChildByName("COLLADA_Scene").getChildByName("Cylinder16"), true);
        } 
          

	}
}