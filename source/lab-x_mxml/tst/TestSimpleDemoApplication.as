package
{
	import cn.edu.zju.labx.objects.Board;
	import cn.edu.zju.labx.objects.Lens;
	import cn.edu.zju.labx.objects.LightSource;
	import cn.edu.zju.labx.objects.Ray;
	
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.view.BasicView;

	public class TestSimpleDemoApplication extends BasicView
	{
		private var lightSource:LightSource;
		private var lens:Lens;
		private var board:Board;
		
		public function TestSimpleDemoApplication(viewportWidth:Number=640, viewportHeight:Number=480, scaleToStage:Boolean=true, interactive:Boolean=false, cameraType:String="Target")
		{
			super(800, 420, true, false, CameraType.FREE);
			viewport.interactive = true;
			camera.zoom = 90;
			createBasicObjects();
			startRendering();
		}
		
		private function createBasicObjects():void
		{
			addLightSource();
			addLens();
			addBoard();
			addRay();
			addRayAfterLens();
		}
		
		private function addLightSource():void 
		{
			var redMaterial:ColorMaterial = new ColorMaterial(0xFF0000);
			lightSource = new LightSource(redMaterial);
			lightSource.x = -300;
			lightSource.screenZ -=10;
			scene.addChild(lightSource);
			
//			trace("lightSource.sceneX:" + lightSource.sceneX);
//			trace("lightSource.sceneY:" + lightSource.sceneY);
//			trace("lightSource.sceneZ:" + lightSource.sceneZ);
			
		}
		
		private function addLens():void 
		{
			var greenMaterial:ColorMaterial = new ColorMaterial(0x00FF00);
			lens = new Lens(greenMaterial);
			lens.x = 0;
			scene.addChild(lens);
		}
		
		private function addBoard():void
		{
			var blueMaterial:ColorMaterial = new ColorMaterial(0x0000FF);
			board = new Board(blueMaterial);
			board.x = 300;
			scene.addChild(board);
		}
		
		private function addRay():void
		{
			var yellowMaterial:ColorMaterial = new ColorMaterial(0xFFFFFF);
			var startVertex:Vertex3D = new Vertex3D(lightSource.x, lightSource.y, lightSource.z);
			var endVertex:Vertex3D = new Vertex3D(lens.x, lightSource.y, lens.z);
			var ray:Ray = new Ray(yellowMaterial, startVertex, endVertex, 5);
			scene.addChild(ray);
		}
		
		private function addRayAfterLens():void
		{
			
		}
	}
}