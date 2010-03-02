package {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.shadematerials.PhongMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cylinder;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.view.stats.StatsView;


	public class MainApplication extends BasicView
	{
		private var inRay:Cylinder;
		private var outRay:Cylinder;
		private var light:PointLight3D;
		private var refractiveIndex:Number = 2;
		private var pivotInRay:DisplayObject3D;
		private var pivotOutRay:DisplayObject3D;
		private var plane:Plane;
		private var tempAngle:Number;
		
		private var rotX:Number= 0.3; //higher is more rotation over x axis in simple orbit example
        private var rotY:Number= 0.3; //higher is more rotation over y axis in simple orbit example
        private var camPitch:Number = 90;
        private var camYaw:Number = 270;
        
        private var isOrbiting:Boolean;
        private var previousMouseX:Number;
        private var previousMouseY:Number;
        private var easePitch:Number = 90;
        private var easeYaw:Number = 270;
        private var easeOut:Number = 0.1;
        
		public function MainApplication()
		{   
			super(800, 420, true, false, CameraType.FREE);
			
			//stage can't be setted here, it may cause some problem, I don't know why   :clarke
//			stage.frameRate = 40;
//			stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
//          stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
//          stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
          	
			light = new PointLight3D(true);
			light.x = -300
			light.z = -300;
			light.y = 300;
			scene.addChild(light);
			
			plane = new Plane();
			plane.yaw(90);
			scene.addChild(plane);
			
			pivotInRay = new DisplayObject3D();
			pivotOutRay = new DisplayObject3D();
			scene.addChild(pivotInRay);
			scene.addChild(pivotOutRay);
			
			var shadeMaterial:PhongMaterial = new PhongMaterial(light,0xFFFFFF,0xFF0000,100);

			inRay = new Cylinder(shadeMaterial, 10, 800);
			inRay.moveLeft(400);
			inRay.roll(90);
			pivotInRay.addChild(inRay);

			outRay = new Cylinder(shadeMaterial, 10, 800);
			outRay.moveRight(400);
			outRay.roll(90);
			pivotOutRay.addChild(outRay);
			
			var userInput:UserInputHandler = new UserInputHandler(stage);
			
			var stats:StatsView = new StatsView(renderer);
			addChild(stats);

			startRendering();
		}
		
		override protected function onRenderTick(e:Event=null):void
		{
			if(UserInputHandler.keyForward)
			{
				pivotInRay.localRotationZ ++;
				tempAngle = Math.sin(pivotInRay.localRotationZ * Math.PI/180)/refractiveIndex;
				pivotOutRay.localRotationZ = Math.asin(tempAngle)* 180/Math.PI;
			}
			if(UserInputHandler.keyBackward)
			{
				pivotInRay.localRotationZ --;
				tempAngle = Math.sin(pivotInRay.localRotationZ * Math.PI/180)/refractiveIndex;
				pivotOutRay.localRotationZ = Math.asin(tempAngle)* 180/Math.PI;
			}			
			
//						//ORBIT ON MOUSE MOVE 
//			
//			//get distance from mouse to center of viewport
//			var xDist:Number= (mouseX - stage.stageWidth * 0.5) ;
//			var yDist:Number = (mouseY - stage.stageHeight * 0.5);
//			
//			//WITHOUT EASING
//	 		camPitch = yDist * rotX + 90;
//			camYaw = xDist * rotY + 270;         
//			
//			// WITH EASING
//			//camPitch += ((yDist  * rotX) - camPitch + 90) * easeOut ;
//			//camYaw += ((xDist  * rotY) - camYaw + 270) * easeOut ;  
//			
//			//orbit camera, should be uncommented to make above code work:
//			camera.orbit(camPitch, camYaw);


			//ORBIT ON MOUSE DRAG, comment out entire code above
			//WITHOUT EASING, only use:
			//camera.orbit(camPitch, camYaw);
			  
            //WITH EASING 
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