package
{

	
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.view.BasicView;
		
	public class TestDeskApplication extends BasicView
	{

		private var light:PointLight3D;
		private var sphere:Sphere;
		private var originPivot:DisplayObject3D;
		
		public function TestDeskApplication(viewportWidth:Number=640, viewportHeight:Number=480, scaleToStage:Boolean=true, interactive:Boolean=false, cameraType:String="Target")
		{
			super(800, 420, true, false, CameraType.FREE);
			viewport.interactive = true;
			camera.zoom = 90;
			createObjects();
			startRendering();
		}
		
		public function createObjects():void
		{
			originPivot = new DisplayObject3D();
			originPivot.x = -300;
			originPivot.y = -200;
			originPivot.z = -100;
			scene.addChild(originPivot);
			
			light = new PointLight3D(true);
			light.y = 200;
			originPivot.addChild(light);
			
			sphere = new Sphere();
			sphere.x = 100;
			originPivot.addChild(sphere);
			
			
		}
		
	}
}