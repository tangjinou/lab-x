package cn.edu.zju.labx.objects
{
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.events.FileLoadEvent;
	import cn.edu.zju.labx.utils.ResourceManager;
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.StageObjectsManager;
	
	public class Desk
	{
		private var desk:DAE; 
		public function Desk()
		{
			desk = new DAE();  
			desk.addEventListener(FileLoadEvent.LOAD_COMPLETE, deskOnLoaded);
			DAE(desk).addFileSearchPath(ResourceManager.DESK_TEXTURE_DIR);
            DAE(desk).load(ResourceManager.DESK_DAE_URL);
            desk.scale = 3;
            desk.scaleX = 6;
            desk.scaleZ = 5;
		}
		
		private function deskOnLoaded(evt:FileLoadEvent):void{
            desk.moveDown(LabXConstant.STAGE_HEIGHT/2-40);
            desk.moveRight(LabXConstant.STAGE_WIDTH/2);
            StageObjectsManager.getDefault.originPivot.addChild(desk);
            StageObjectsManager.getDefault.layerManager.deskLayer.addDisplayObject3D(desk, true);
        } 
          

	}
}