package
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.core.UserInputHandler;
	import cn.edu.zju.labx.objects.ConvexLens;
	import cn.edu.zju.labx.objects.Lens;
	import cn.edu.zju.labx.objects.LightSource;
	import cn.edu.zju.labx.objects.Desk;
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
	import org.papervision3d.view.BasicView;
	import org.papervision3d.view.layer.ViewportLayer;
	import org.papervision3d.view.stats.StatsView;
	
	public class SecondExperimentApplication extends BasicView
	{
		/**
		 * Stage Variables
		 */
		private var rotX:Number= 0.1; //higher is more rotation over x axis in simple orbit example
        private var rotY:Number= 0.1; //higher is more rotation over y axis in simple orbit example
        private var camPitch:Number = 60;
        private var camYaw:Number = 270;
        
        private var previousMouseX:Number;
        private var previousMouseY:Number;
        
		/**
		 * Stage Other objects
		 */
		public  var originPivot:DisplayObject3D;
		private var light:PointLight3D;
		
		
		/**
		 * Layers for equipment
		 */
		private var deskLayer:ViewportLayer;
		private var equipmentLayer:ViewportLayer;
		
		/**
		 * Equipments
		 */
		private var desk:Desk;
		private var lightSource:LightSource;
		public var convexLens1:Lens;
	    public var convexLens2:Lens;
		
		
		public function SecondExperimentApplication(viewportWidth:Number=LabXConstant.STAGE_WIDTH, viewportHeight:Number=LabXConstant.STAGE_HEIGHT, scaleToStage:Boolean=true, interactive:Boolean=false, cameraType:String="Target")
		{
			super(viewportWidth, viewportHeight, true, false, CameraType.FREE);
			viewport.interactive = true;
			camera.zoom = 90;
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
		
		
		/******************************************************************************
		 * Create Equipment and other object in the stage
		 ****************************************************************************
		 */
		
		private function createObjects():void
		{
			/**
			 * Create pivot as the basic axis of all equipment
			 */
			originPivot = new DisplayObject3D();
			originPivot.x = -LabXConstant.STAGE_WIDTH/2
			scene.addChild(originPivot);
			StageObjectsManager.getDefault.originPivot = originPivot;
			
			/**
			 * create light effect for Equipments 
			 */
			light = new PointLight3D(true);
			light.x = 200;
			light.y = 50;
			light.z = -50;
			originPivot.addChild(light);
			
			/**
			 * Create a light source
			 */
			var imgLoader:Loader = new Loader();
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadLightSourceTextureComplete);
			imgLoader.load(new URLRequest("../assets/textures/metal.jpg"));
			
			
			
			var BASIC_X:Number = 100;
			var BASIC_SCALE:Number = 0.8;


			/*Create Lens1*/	
			var shadeMaterialLens:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0x6ccff8,100);
			shadeMaterialLens.interactive = true;
			convexLens1 = new ConvexLens("扩束镜",shadeMaterialLens, 50);
			StageObjectsManager.getDefault.addObject(convexLens1);
			convexLens1.scale = BASIC_SCALE;
			convexLens1.moveRight(BASIC_X + 100);
			convexLens1.moveUp(convexLens1.height/2);
			
			/*Create Lens2*/	
			var shadeMaterialLens2:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0x6ccff8,100);
			shadeMaterialLens2.interactive = true;
			convexLens2 = new ConvexLens("准直透镜",shadeMaterialLens2, 100);
			StageObjectsManager.getDefault.addObject(convexLens2);
			convexLens2.scale = BASIC_SCALE;
			convexLens2.moveRight(BASIC_X + 250);
			convexLens2.moveUp(convexLens2.height/2);
			
		}
		
		 private function loadLightSourceTextureComplete(evt:Event):void
        {
        	var bitmap:Bitmap = evt.target.content as Bitmap;
			var bitmapMaterial:BitmapMaterial = new BitmapMaterial(bitmap.bitmapData);
			bitmapMaterial.interactive = true;
			lightSource = new LightSource("lightSource",bitmapMaterial);
			StageObjectsManager.getDefault.rayManager.setLightSource(lightSource);
			lightSource.moveUp(lightSource.height/2);	
			lightSource.moveRight(50);
			originPivot.addChild(lightSource);
			equipmentLayer.addDisplayObject3D(lightSource, true);
        	
        }
		
		/***************************************************************
		 *  Mouse Event Handler part for the Experiment
		 * *************************************************************
		 */
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
        
        
		/***************************************************************
		 *  Called automatically in every frame
		 * *************************************************************
		 */
        override protected function onRenderTick(e:Event=null):void
		{
			camera.orbit(camPitch, camYaw);
            StageObjectsManager.getDefault.layerManager.viewLayerChange();
			super.onRenderTick();
		}

	}
}