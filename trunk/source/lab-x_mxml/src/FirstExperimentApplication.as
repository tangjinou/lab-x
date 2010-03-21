package
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.core.UserInputHandler;
	import cn.edu.zju.labx.objects.Desk;
	import cn.edu.zju.labx.objects.Grid;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.core.utils.virtualmouse.VirtualMouseMouseEvent;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.view.layer.ViewportLayer;
	import org.papervision3d.view.stats.StatsView;
	
	public class FirstExperimentApplication extends BasicView
	{
        private var camPitch:Number = LabXConstant.DEFAULT_CAMERA_PITCH;
        private var camYaw:Number = LabXConstant.DEFAULT_CAMERA_YAW;

        private var previousMouseX:Number;
        private var previousMouseY:Number;
        
        private var grid:Grid;
		private var light:PointLight3D;
		public  var originPivot:DisplayObject3D;
		private var desk:Desk; 
		
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
			equipmentLayer = StageObjectsManager.getDefault.layerManager.equipmentLayer;
			desk = new Desk();
			
			originPivot = new DisplayObject3D();
			originPivot.x = -LabXConstant.STAGE_WIDTH/2
			scene.addChild(originPivot);
			StageObjectsManager.getDefault.originPivot = originPivot;
			
			grid = new Grid();
			
			light = new PointLight3D(true);
			light.x = 200;
			light.y = 50;
			light.z = -50;
			originPivot.addChild(light);
			
			var stats:StatsView = new StatsView(renderer);
			addChild(stats);
			startRendering();
			
			experimentSelected(LabXConstant.EXPERIMENT_FIRST);
		}
		
		
		/**
		 * For select the experiment
		 */
		public function experimentSelected(experimentId:Number = LabXConstant.EXPERIMENT_FIRST):void
		{
			var equipmentList:ArrayCollection = StageObjectsManager.getDefault.experimentManager.createExperimentEquipments(experimentId);
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