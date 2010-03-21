package
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.core.UserInputHandler;
	import cn.edu.zju.labx.objects.Board;
	import cn.edu.zju.labx.objects.ConvexLens;
	import cn.edu.zju.labx.objects.Desk;
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
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.shadematerials.PhongMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.view.layer.ViewportLayer;
	import org.papervision3d.view.stats.StatsView;
	
	public class FirstExperimentApplication extends BasicView
	{
		private var rotX:Number= 0.1; //higher is more rotation over x axis in simple orbit example
        private var rotY:Number= 0.1; //higher is more rotation over y axis in simple orbit example
        private var camPitch:Number = LabXConstant.DEFAULT_CAMERA_PITCH;
        private var camYaw:Number = LabXConstant.DEFAULT_CAMERA_YAW;

        private var previousMouseX:Number;
        private var previousMouseY:Number;
        private var easePitch:Number = 90;
        private var easeYaw:Number = 270;
        private var easeOut:Number = 0.1;
        
		private var light:PointLight3D;
		public  var originPivot:DisplayObject3D;
		private var desk:Desk; 
		private var lightSource:LightSource;
		private var beam1:SplitterBeam;
	    public var convexLens1:Lens;
	    public var convexLens2:Lens;
	    public var convexLens3:Lens;
	    public var convexLens4:Lens;
	    
	    public var mirror1:Mirror;
	    public var mirror2:Mirror;
	    public var mirror3:Mirror;
	    
	    private var board:Board;
	
		private var deskLayer:ViewportLayer;
		private var equipmentLayer:ViewportLayer;
		
		public function FirstExperimentApplication(viewportWidth:Number=LabXConstant.STAGE_WIDTH, viewportHeight:Number=LabXConstant.STAGE_HEIGHT, scaleToStage:Boolean=true, interactive:Boolean=false, cameraType:String="Target")
		{
			super(viewportWidth, viewportHeight, true, false, CameraType.FREE);
			viewport.interactive = true;
			camera.zoom = LabXConstant.DEFAULT_CAMERA_ZOOM;
			camera.useCulling = true;
			/**
			 *  set the mainView here ,if not it will make some problems
			 */ 
			StageObjectsManager.getDefault.mainView = this;
			deskLayer = StageObjectsManager.getDefault.layerManager.deskLayer;
			equipmentLayer = StageObjectsManager.getDefault.layerManager.equipmentLayer;
			desk = new Desk();
			createObjects();
			var stats:StatsView = new StatsView(renderer);
			addChild(stats);
			startRendering();
		}

        private function loadLightSourceTextureComplete(evt:Event):void
        {
        	var bitmap:Bitmap = evt.target.content as Bitmap;
			var bitmapMaterial:BitmapMaterial = new BitmapMaterial(bitmap.bitmapData);
			bitmapMaterial.interactive = true;
			lightSource = new LightSource("激光光源",bitmapMaterial);
			StageObjectsManager.getDefault.rayManager.setLightSource(lightSource);
			lightSource.moveUp(lightSource.height/2-10);	
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
			light.x = 200;
			light.y = 50;
			light.z = -50;
			originPivot.addChild(light);
			
			var BASIC_X:Number = 100;
			var BASIC_SCALE:Number = 0.8;

			
			/*Create lightSource*/
			var imgLoader:Loader = new Loader();
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadLightSourceTextureComplete);
			imgLoader.load(new URLRequest(ResourceManager.LIGHTSOURCE_TEXTURE));
			
			
			/*Create SplitterBeam1*/
			var shadeMaterialBeam:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0xFF0000,100);
			shadeMaterialBeam.interactive = true;
			beam1 =new SplitterBeam("分光镜",shadeMaterialBeam);
			StageObjectsManager.getDefault.addObject(beam1);
			beam1.scale = BASIC_SCALE;
		    beam1.moveRight(BASIC_X + 100);
			beam1.moveUp(beam1.height/2);
			beam1.rotationY+=45;
			
			
//			/*Create Mirrcor1*/
		    var shadeMaterialMiror:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0x6ccff8,100);
			shadeMaterialMiror.interactive = true;
			mirror1 =new Mirror("反射镜1",shadeMaterialMiror);
			StageObjectsManager.getDefault.addObject(mirror1);
			mirror1.scale = BASIC_SCALE;
			mirror1.moveRight(BASIC_X+100);
			mirror1.moveUp(mirror1.height/2);
			mirror1.moveForward(200);
			mirror1.rotationY+=54.217;

			/*Create Mirrcor2*/
			var shadeMaterialMiror2:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0x6ccff8,100);
			shadeMaterialMiror2.interactive = true;
			mirror2 =new Mirror("反射镜2",shadeMaterialMiror2);
			StageObjectsManager.getDefault.addObject(mirror2);
			mirror2.scale = BASIC_SCALE;
			mirror2.moveRight(BASIC_X + 200);
			mirror2.moveUp(mirror2.height/2);
			mirror2.rotationY -=45;
			
			/*Create Mirrcor3*/
			var shadeMaterialMiror3:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0x6ccff8,100);
			shadeMaterialMiror3.interactive = true;
			mirror3 =new Mirror("反射镜3",shadeMaterialMiror3);
			StageObjectsManager.getDefault.addObject(mirror3);
			mirror3.scale = BASIC_SCALE;
			mirror3.moveRight(BASIC_X + 200);
			mirror3.moveUp(mirror3.height/2);
			mirror3.moveBackward(166.7);
			mirror3.rotationY -=54.2;
			
			/*Create Lens1*/	
			var shadeMaterialLens:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0x6ccff8,100);
			shadeMaterialLens.interactive = true;
			convexLens1 = new ConvexLens("扩束镜1",shadeMaterialLens, 18);
			StageObjectsManager.getDefault.addObject(convexLens1);
			convexLens1.moveUp(convexLens1.height/2);
			convexLens1.scale = BASIC_SCALE*0.5;
			convexLens1.moveRight(BASIC_X + 280);
			convexLens1.moveForward(140);
			convexLens1.rotationY +=18.5;
			
			/*Create Lens2*/
			//distance between len1 and lens2 is about 126	
			var shadeMaterialLens2:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0x6ccff8,100);
			shadeMaterialLens2.interactive = true;
			convexLens2 = new ConvexLens("准直物镜1",shadeMaterialLens2, 108);
			StageObjectsManager.getDefault.addObject(convexLens2);
			convexLens2.moveUp(convexLens2.height/2);
			convexLens2.scale = BASIC_SCALE;
			convexLens2.moveRight(BASIC_X + 400);
			convexLens2.moveForward(100);
			convexLens2.rotationY +=18.5;
			
            /*Create Lens3*/	
			var shadeMaterialLens3:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0x6ccff8,100);
			shadeMaterialLens3.interactive = true;
			convexLens3 = new ConvexLens("扩束镜2",shadeMaterialLens3, 18);
			StageObjectsManager.getDefault.addObject(convexLens3);
			convexLens3.moveUp(convexLens3.height/2);
			convexLens3.scale = BASIC_SCALE*0.5;
			convexLens3.moveRight(BASIC_X + 280);
			convexLens3.moveBackward(140);
			convexLens3.rotationY -=18.5;
			
			/*Create Lens4*/	
			//distance between len1 and lens2 is about 126	
			var shadeMaterialLens4:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0x6ccff8,100);
			shadeMaterialLens4.interactive = true;
			convexLens4 = new ConvexLens("准直物镜2",shadeMaterialLens4, 108);
			StageObjectsManager.getDefault.addObject(convexLens4);
			convexLens4.moveUp(convexLens4.height/2);
            convexLens4.scale = BASIC_SCALE;
			convexLens4.moveRight(BASIC_X + 400);
			convexLens4.moveBackward(100);
			convexLens4.rotationY -=18.5;
			
			/*create Board*/
			var ColorMaterialBoard:ColorMaterial = new ColorMaterial(0x262626, 1, true);
			board = new  Board("接收屏",ColorMaterialBoard);
			board.moveRight(LabXConstant.DESK_WIDTH);
			board.moveUp(board.height/2);
            StageObjectsManager.getDefault.addObject(board);
			
		}
		
		override protected function onRenderTick(e:Event=null):void
		{
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
        
        
		public function reset_camera():void
		{
			this.camera.zoom = LabXConstant.DEFAULT_CAMERA_ZOOM;
			this.camera.useCulling = true;
			this.camPitch = LabXConstant.DEFAULT_CAMERA_PITCH;
			this.camYaw = LabXConstant.DEFAULT_CAMERA_YAW;
			StageObjectsManager.getDefault.addMessage("恢复默认视角");
		}
		
	}
}