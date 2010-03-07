package
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.objects.Lens;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.shadematerials.PhongMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.objects.primitives.Cylinder;
	import org.papervision3d.view.BasicView;
	
	public class FirstExperimentApplication extends BasicView
	{
		private var rotX:Number= 0.1; //higher is more rotation over x axis in simple orbit example
        private var rotY:Number= 0.1; //higher is more rotation over y axis in simple orbit example
        private var camPitch:Number = 90;
        private var camYaw:Number = 270;

        private var isOrbiting:Boolean;
        private var previousMouseX:Number;
        private var previousMouseY:Number;
        private var easePitch:Number = 90;
        private var easeYaw:Number = 270;
        private var easeOut:Number = 0.1;
        
		private var light:PointLight3D;
		private var xAxis:Cylinder;
		private var yAxis:Cylinder;
		private var zAxis:Cylinder;
		public  var originPivot:DisplayObject3D;
		
		private var desk:DAE; 

	    
	    
	    private var lens:Lens;
	    
		public function FirstExperimentApplication(viewportWidth:Number=LabXConstant.STAGE_WIDTH, viewportHeight:Number=LabXConstant.STAGE_HEIGHT, scaleToStage:Boolean=true, interactive:Boolean=false, cameraType:String="Target")
		{
			super(viewportWidth, viewportHeight, true, false, CameraType.FREE);
			viewport.interactive = true;
			camera.zoom = 90;
			createDesk();
			createObjects();
			startRendering();
		}
		
		public function createDesk():void
		{
			desk = new DAE();  
			desk.addEventListener(FileLoadEvent.LOAD_COMPLETE, deskOnLoaded);
			DAE(desk).addFileSearchPath("../assets/textures/desk");
            DAE(desk).load("../assets/models/desk.DAE");
            desk.scale = 3;
            desk.scaleX = 6;
		}
		
		private function deskOnLoaded(evt:FileLoadEvent):void{    
                desk.moveDown(LabXConstant.STAGE_HEIGHT/2);
                desk.moveRight(LabXConstant.STAGE_WIDTH/2);
                originPivot.addChild(desk);  
                StageObjectsManager.getDefault.originPivot = originPivot;
                //camera.lookAt(desk);  
        } 
          
		public function createObjects():void
		{
			originPivot = new DisplayObject3D();
			originPivot.x = -LabXConstant.STAGE_WIDTH/2
			scene.addChild(originPivot);
			
			light = new PointLight3D(true);
			light.y = 100;
			light.z = -100;
			originPivot.addChild(light);
			
			var shadeMaterialX:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0xFF0000,100);
			var shadeMaterialY:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0xFF00,100);
			var shadeMaterialZ:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0xFF,100);
			
			xAxis = new Cylinder(shadeMaterialX, 1, LabXConstant.STAGE_WIDTH/5);
			xAxis.moveRight(LabXConstant.STAGE_WIDTH/10);
			xAxis.roll(90);

			originPivot.addChild(xAxis);
	
			yAxis = new Cylinder(shadeMaterialY, 1, LabXConstant.STAGE_HEIGHT/5);
			yAxis.moveUp(LabXConstant.STAGE_HEIGHT/10);
			originPivot.addChild(yAxis);
			
			zAxis = new Cylinder(shadeMaterialZ, 1, LabXConstant.STAGE_DEPTH/5);
			zAxis.moveForward(LabXConstant.STAGE_DEPTH/10);
			zAxis.pitch(90);
			originPivot.addChild(zAxis);	
			
			/*Create Lens*/	
			var blue:ColorMaterial = new ColorMaterial(0x0000FF);
			blue.interactive = true;
			lens = new Lens(blue);
			lens.moveRight(LabXConstant.DESK_WIDTH/2);
			lens.moveUp(lens.height/2);
			
//            lens.y -=130;
            originPivot.addChild(lens);
			
		}
		
		override protected function onRenderTick(e:Event=null):void
		{
			easePitch += (camPitch - easePitch) * easeOut;
           	easeYaw+= (camYaw - easeYaw) * easeOut;
            camera.orbit(easePitch, easeYaw);   
            
			super.onRenderTick();
		}
		
		public function onMouseDown(e:MouseEvent):void
        {
            isOrbiting = true;
            previousMouseX = e.stageX;
            previousMouseY = e.stageY;
        }
  
        public function onMouseUp(e:MouseEvent):void
        {
             isOrbiting = false;
        }
        
		public function onMouseMove(e:MouseEvent):void
        {
             var differenceX:Number = e.stageX - previousMouseX;
             var differenceY:Number = e.stageY - previousMouseY;
  			
             if(isOrbiting){
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
        }
		
	}
}