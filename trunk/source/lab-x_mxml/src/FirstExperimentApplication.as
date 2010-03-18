package
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.core.UserInputHandler;
	import cn.edu.zju.labx.objects.Board;
	import cn.edu.zju.labx.objects.ConcaveLens;
	import cn.edu.zju.labx.objects.ConvexLens;
	import cn.edu.zju.labx.objects.Lens;
	import cn.edu.zju.labx.objects.LightSource;
	import cn.edu.zju.labx.objects.Mirror;
	import cn.edu.zju.labx.objects.SplitterBeam;
	import cn.edu.zju.labx.utils.ResourceManager;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.core.utils.virtualmouse.VirtualMouseMouseEvent;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.shadematerials.PhongMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.view.layer.ViewportLayer;
	import org.papervision3d.view.stats.StatsView;
	
	public class FirstExperimentApplication extends BasicView
	{
		private var rotX:Number= 0.1; //higher is more rotation over x axis in simple orbit example
        private var rotY:Number= 0.1; //higher is more rotation over y axis in simple orbit example
        private var camPitch:Number = 60;
        private var camYaw:Number = 270;

        private var previousMouseX:Number;
        private var previousMouseY:Number;
        private var easePitch:Number = 90;
        private var easeYaw:Number = 270;
        private var easeOut:Number = 0.1;
        
		private var light:PointLight3D;
		public  var originPivot:DisplayObject3D;
		private var desk:DAE; 
		private var beam1:SplitterBeam;
		private var beam2:SplitterBeam;
	    public var convexLens1:Lens;
	    public var convexLens2:Lens;
	    private var board:Board;
	
		private var deskLayer:ViewportLayer;
		private var equipmentLayer:ViewportLayer;
		
		public function FirstExperimentApplication(viewportWidth:Number=LabXConstant.STAGE_WIDTH, viewportHeight:Number=LabXConstant.STAGE_HEIGHT, scaleToStage:Boolean=true, interactive:Boolean=false, cameraType:String="Target")
		{
			super(viewportWidth, viewportHeight, true, false, CameraType.FREE);
			viewport.interactive = true;
			camera.zoom = 90;
			camera.useCulling = true;
			/**
			 *  set the mainView here ,if not it will make some problems
			 */ 
			StageObjectsManager.getDefault.mainView = this;
//			StageObjectsManager.getDefault.layerManager.initViewportLayers(); //init move to the getdefault in LayerManager
			deskLayer = StageObjectsManager.getDefault.layerManager.deskLayer;
			equipmentLayer = StageObjectsManager.getDefault.layerManager.equipmentLayer;
			createDesk();
			createObjects();
			var stats:StatsView = new StatsView(renderer);
			addChild(stats);
			startRendering();
		}

		
		public function createDesk():void
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
            originPivot.addChild(desk);
            deskLayer.addDisplayObject3D(desk, true);
        } 
          
        private function loadLightSourceTextureComplete(evt:Event):void
        {
        	var bitmap:Bitmap = evt.target.content as Bitmap;
			var bitmapMaterial:BitmapMaterial = new BitmapMaterial(bitmap.bitmapData);
//			var shader:PhongShader = new PhongShader(light,0xFFFFFF,0x464646,100);
//			var shadedMaterial:ShadedMaterial = new ShadedMaterial(bitmapMaterial, shader);
			bitmapMaterial.interactive = true;
			var lightSource:LightSource = new LightSource(bitmapMaterial);
			StageObjectsManager.getDefault.rayManager.setLightSource(lightSource);
			lightSource.moveUp(lightSource.height/2);	
			lightSource.moveRight(50);
			originPivot.addChild(lightSource);
			equipmentLayer.addDisplayObject3D(lightSource, true);
        	
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
			var imgLoader:Loader = new Loader();
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadLightSourceTextureComplete);
			imgLoader.load(new URLRequest("../assets/textures/metal.jpg"));
			
			
			/*Create SplitterBeam1*/
			var shadeMaterialBeam:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0x6ccff8,100);
			shadeMaterialBeam.interactive = true;
			beam1 =new SplitterBeam(shadeMaterialBeam);
			beam1.moveRight(LabXConstant.DESK_WIDTH/5);
			beam1.moveUp(beam1.height/2);
			originPivot.addChild(beam1);
			equipmentLayer.addDisplayObject3D(beam1, true);
			StageObjectsManager.getDefault.addObject(beam1);
			
			
			/*Create SplitterBeam2*/
			var shadeMaterialBeam:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0x6ccff8,100);
			shadeMaterialBeam.interactive = true;
			beam2 =new SplitterBeam(shadeMaterialBeam);
			originPivot.addChild(beam2);
			equipmentLayer.addDisplayObject3D(beam2, true);
			StageObjectsManager.getDefault.addObject(beam2);
			beam2.moveRight(LabXConstant.DESK_WIDTH/5*2);
			beam2.moveUp(beam1.height/2);
			beam2.moveForward(200);
			beam2.rotationY -=225;  // -135
			trace(beam2.transform.toString());
			
			
			
			/*Create Lens*/	
			var shadeMaterialLens:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0x6ccff8,100);
			shadeMaterialLens.interactive = true;
			convexLens1 = new ConvexLens(shadeMaterialLens, 100);
			convexLens1.moveRight(LabXConstant.DESK_WIDTH/3);
			convexLens1.moveUp(convexLens1.height/2);
			originPivot.addChild(convexLens1);
			StageObjectsManager.getDefault.addObject(convexLens1);
			
			/*Create second Lens*/	
			var shadeMaterialLens2:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0x6ccff8,100);
			shadeMaterialLens2.interactive = true;
			convexLens2 = new ConvexLens(shadeMaterialLens2, 100);
			convexLens2.moveRight(LabXConstant.DESK_WIDTH/3 + 200);
			convexLens2.moveUp(convexLens2.height/2);
			originPivot.addChild(convexLens2);
			StageObjectsManager.getDefault.addObject(convexLens2);
//			
//			
//			/*Create mirror*/
//			var shadeMaterialBeam:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0xFF0000,100);
//			shadeMaterialBeam.interactive = true;
//			var mirror:Mirror =new Mirror(shadeMaterialBeam);
//			mirror.moveRight(LabXConstant.DESK_WIDTH -100);
//			mirror.moveUp(mirror.height/2);
//			originPivot.addChild(mirror);
//			equipmentLayer.addDisplayObject3D(mirror, true);
//			StageObjectsManager.getDefault.addObject(mirror);
			
			/*create Board*/
			var shadeMaterialBoard:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0xe1e1e1,100);
			shadeMaterialBoard.interactive = true;
			board = new  Board(shadeMaterialBoard);
			board.moveRight(LabXConstant.DESK_WIDTH);
			board.moveUp(board.height/2);
            originPivot.addChild(board);
            equipmentLayer.addDisplayObject3D(board, true);
            StageObjectsManager.getDefault.addObject(board);
            board.displayInterferenceImage();
			
		}
		
		override protected function onRenderTick(e:Event=null):void
		{
//			easePitch += (camPitch - easePitch) * easeOut;
//          easeYaw+= (camYaw - easeYaw) * easeOut;
//          camera.orbit(easePitch, easeYaw);
			camera.orbit(camPitch, camYaw);
            StageObjectsManager.getDefault.layerManager.viewLayerChange();
			super.onRenderTick();
		}
		
		public function onMouseDown(e:MouseEvent):void
        {
        	if (e is VirtualMouseMouseEvent)return;
            StageObjectsManager.getDefault.isOrbiting = true;
            previousMouseX = e.stageX;
            previousMouseY = e.stageY;
            UserInputHandler.getDefault.mouseDownHandler(e);
        }
        public function onMouseUp(e:MouseEvent):void
        {
        	if (e is VirtualMouseMouseEvent)return;
             StageObjectsManager.getDefault.isOrbiting = false;
        }
        
		public function onMouseMove(e:MouseEvent):void
        {
        	if (e is VirtualMouseMouseEvent || (!e.buttonDown))return;
             var differenceX:Number = e.stageX - previousMouseX;
             var differenceY:Number = e.stageY - previousMouseY;
             if(StageObjectsManager.getDefault.isOrbiting==true && StageObjectsManager.getDefault.rotate_stage==true){
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