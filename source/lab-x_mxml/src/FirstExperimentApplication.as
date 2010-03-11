package
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.core.UserInputHandler;
	import cn.edu.zju.labx.objects.Board;
	import cn.edu.zju.labx.objects.Lens;
	import cn.edu.zju.labx.objects.LightSource;
	import cn.edu.zju.labx.utils.ResourceManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.shadematerials.PhongMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.view.layer.ViewportLayer;
	import org.papervision3d.view.layer.util.ViewportLayerSortMode;
	
	public class FirstExperimentApplication extends BasicView
	{
		private var rotX:Number= 0.1; //higher is more rotation over x axis in simple orbit example
        private var rotY:Number= 0.1; //higher is more rotation over y axis in simple orbit example
        private var camPitch:Number = 90;
        private var camYaw:Number = 270;

        public static  var isOrbiting:Boolean;
        private var previousMouseX:Number;
        private var previousMouseY:Number;
        private var easePitch:Number = 90;
        private var easeYaw:Number = 270;
        private var easeOut:Number = 0.1;
        
		private var light:PointLight3D;
		public  var originPivot:DisplayObject3D;
		private var desk:DAE; 
	    public var lens:Lens;
	    private var board:Board;
	
		private var deskLayer:ViewportLayer;
		private var equipmentLayer:ViewportLayer;
		private var lensLayer:ViewportLayer;
		private var lightSourceLayer:ViewportLayer;
		private var boardLayer:ViewportLayer;
		private var rayLayer:ViewportLayer;
		
		public function FirstExperimentApplication(viewportWidth:Number=LabXConstant.STAGE_WIDTH, viewportHeight:Number=LabXConstant.STAGE_HEIGHT, scaleToStage:Boolean=true, interactive:Boolean=false, cameraType:String="Target")
		{
			super(viewportWidth, viewportHeight, true, false, CameraType.FREE);
			viewport.interactive = true;
			camera.zoom = 90;
			
			createTopLevelViewportLayers();
			createSecondLevelViewportLayers();
			createSpecialEffectsOnLayers();
			
			createDesk();
			createObjects();
			startRendering();
		}
		
		public function createTopLevelViewportLayers():void
		{
			equipmentLayer = new ViewportLayer(viewport,null);
			deskLayer = new ViewportLayer(viewport,null);
			StageObjectsManager.getDefault.equipmentLayer = equipmentLayer;
			StageObjectsManager.getDefault.deskLayer = deskLayer;
			viewport.containerSprite.addLayer(equipmentLayer);
			viewport.containerSprite.addLayer(deskLayer);
			viewport.containerSprite.sortMode = ViewportLayerSortMode.INDEX_SORT;
			equipmentLayer.layerIndex = 1;
			deskLayer.layerIndex = 2;
		}
		
		public function createSecondLevelViewportLayers():void
		{
			lensLayer = new ViewportLayer(viewport,null);
			lightSourceLayer = new ViewportLayer(viewport,null);
			boardLayer = new ViewportLayer(viewport,null);
			rayLayer = new ViewportLayer(viewport, null);
			StageObjectsManager.getDefault.lensLayer = lensLayer;
			StageObjectsManager.getDefault.lightSourceLayer = lightSourceLayer;
			StageObjectsManager.getDefault.boardLayer = boardLayer;
			StageObjectsManager.getDefault.rayLayer = rayLayer;
			equipmentLayer.addLayer(lensLayer);
			equipmentLayer.addLayer(lightSourceLayer);
			equipmentLayer.addLayer(boardLayer);
			equipmentLayer.addLayer(rayLayer);
			equipmentLayer.sortMode = ViewportLayerSortMode.Z_SORT;
		}
		
		public function createSpecialEffectsOnLayers():void
		{
			lensLayer.alpha = 0.5;
		}
		
		public function createDesk():void
		{
			desk = new DAE();  
			desk.addEventListener(FileLoadEvent.LOAD_COMPLETE, deskOnLoaded);
			DAE(desk).addFileSearchPath(ResourceManager.DESK_TEXTURE_DIR);
            DAE(desk).load(ResourceManager.DESK_DAE_URL);
            desk.scale = 3;
            desk.scaleX = 6;
		}
		
		private function deskOnLoaded(evt:FileLoadEvent):void{
            desk.moveDown(LabXConstant.STAGE_HEIGHT/2-40);
            desk.moveRight(LabXConstant.STAGE_WIDTH/2);
            originPivot.addChild(desk);
            deskLayer.addDisplayObject3D(desk, true);
             //camera.lookAt(desk);  
        } 
          
		public function createObjects():void
		{
			originPivot = new DisplayObject3D();
			originPivot.x = -LabXConstant.STAGE_WIDTH/2
			scene.addChild(originPivot);
			StageObjectsManager.getDefault.originPivot = originPivot;
			
			light = new PointLight3D(true);
			light.y = 100;
			light.z = -100;
			originPivot.addChild(light);

			
			/*Create lightSource*/
			var shadeMaterial:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0x6ccff8,100);
			shadeMaterial.interactive = true;
			var lightSource:LightSource = new LightSource(shadeMaterial);
			lightSource.moveUp(lightSource.height/2);	
			lightSource.moveRight(50);
			originPivot.addChild(lightSource);
			lightSourceLayer.addDisplayObject3D(lightSource, true);
			
			StageObjectsManager.getDefault.addLabXObject(lightSource);
			
			/*Create Lens*/	
			var shadeMaterialLens:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0x6ccff8,100);
			shadeMaterialLens.interactive = true;
			lens = new Lens(shadeMaterialLens, -100);
			lens.moveRight(LabXConstant.DESK_WIDTH/3);
			lens.moveUp(lens.height/2);
			originPivot.addChild(lens);
			lensLayer.addDisplayObject3D(lens, true);
			
			StageObjectsManager.getDefault.addLabXObject(lens);
			
			/*Create second Lens*/	
			var shadeMaterialLens2:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0x6ccff8,100);
			shadeMaterialLens2.interactive = true;
			lens = new Lens(shadeMaterialLens2, 100);
			lens.moveRight(LabXConstant.DESK_WIDTH/3 + 200);
			lens.moveUp(lens.height/2);
			originPivot.addChild(lens);
			lensLayer.addDisplayObject3D(lens, true);
			
			StageObjectsManager.getDefault.addLabXObject(lens);
			
			/*create Board*/
			var shadeMaterialBoard:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0xe1e1e1,100);
			shadeMaterialBoard.interactive = true;
			board = new  Board(shadeMaterialBoard);
			board.moveRight(LabXConstant.DESK_WIDTH);
			board.moveUp(board.height/2);
            originPivot.addChild(board);
            boardLayer.addDisplayObject3D(board, true);
            StageObjectsManager.getDefault.addLabXObject(board);
            
			
		}
		
		override protected function onRenderTick(e:Event=null):void
		{
			easePitch += (camPitch - easePitch) * easeOut;
           	easeYaw+= (camYaw - easeYaw) * easeOut;
            camera.orbit(easePitch, easeYaw);   
            if (camera.y < originPivot.y)
            {
            	equipmentLayer.layerIndex = 1;
				deskLayer.layerIndex = 2;
            }else
            {
            	equipmentLayer.layerIndex = 2;
				deskLayer.layerIndex = 1;
            }
			super.onRenderTick();
		}
		
		public function onMouseDown(e:MouseEvent):void
        {
            isOrbiting = true;
            previousMouseX = e.stageX;
            previousMouseY = e.stageY;
            if(StageObjectsManager.getDefault.rotate_stage==false){
                UserInputHandler.getDefault.mouseDownHandler(e);
            }
        }
        public function onMouseUp(e:MouseEvent):void
        {
             isOrbiting = false;
        }
        
		public function onMouseMove(e:MouseEvent):void
        {
             var differenceX:Number = e.stageX - previousMouseX;
             var differenceY:Number = e.stageY - previousMouseY;
             if(isOrbiting==true && StageObjectsManager.getDefault.rotate_stage==true){
                camPitch += differenceY;
                camYaw += differenceX;
  				//clamp pitch
  				if(camPitch < 5) camPitch = 5;
  				if(camPitch > 175) camPitch = 175;
             	//clamp yaw
             	//if(camYaw > 355) camYaw = 355;
  				//if(camYaw < 185) camYaw = 185;
                previousMouseX = e.stageX;
                previousMouseY = e.stageY;
             }
            if(StageObjectsManager.getDefault.rotate_stage==false){
                UserInputHandler.getDefault.mouseMoveHandler(e);
            }
        }
		
	}
}