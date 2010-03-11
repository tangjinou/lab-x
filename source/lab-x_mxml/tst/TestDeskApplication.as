package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.shadematerials.PhongMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cylinder;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.events.FileLoadEvent;
	
	public class TestDeskApplication extends BasicView
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
		private var originPivot:DisplayObject3D;
		
		private var desk:DAE; 
		import org.papervision3d.materials.ColorMaterial;
		import org.papervision3d.materials.utils.MaterialsList;
	
		public function TestDeskApplication(viewportWidth:Number=640, viewportHeight:Number=480, scaleToStage:Boolean=true, interactive:Boolean=false, cameraType:String="Target")
		{
			super(800, 420, true, false, CameraType.FREE);
			viewport.interactive = true;
			camera.zoom = 90;
			
			createObjects();
			createDesk();
			startRendering();
		}
		
		public function createDesk():void
		{
			desk = new DAE();  
			desk.addEventListener(FileLoadEvent.LOAD_COMPLETE, deskOnLoaded);
			DAE(desk).addFileSearchPath("../assets/textures/desk");
            DAE(desk).load("../assets/models/desk.DAE");
            desk.scale = 3;
		}
		
		private function deskOnLoaded(evt:FileLoadEvent):void{    
                desk.moveDown(280);
                desk.moveRight(200);
                originPivot.addChild(desk);  
                //camera.lookAt(desk);  
        } 
          
		public function createObjects():void
		{
			originPivot = new DisplayObject3D();
			originPivot.x = -300;
			originPivot.z = -100;
			scene.addChild(originPivot);
			
			light = new PointLight3D(true);
			light.y = 100;
			light.z = -100;
			originPivot.addChild(light);
			
			var shadeMaterialX:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0xFF0000,100);
			var shadeMaterialY:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0xFF00,100);
			var shadeMaterialZ:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0xFF,100);
			
			xAxis = new Cylinder(shadeMaterialX, 5, 200);
			xAxis.moveRight(100);
			xAxis.roll(90);

			originPivot.addChild(xAxis);
	
			yAxis = new Cylinder(shadeMaterialY, 5, 200);
			yAxis.moveUp(100);
			originPivot.addChild(yAxis);
			
			zAxis = new Cylinder(shadeMaterialZ, 5, 200);
			zAxis.moveForward(100);
			zAxis.pitch(90);
			originPivot.addChild(zAxis);		
			
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