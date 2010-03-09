package
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.objects.Board;
	import cn.edu.zju.labx.objects.Lens;
	import cn.edu.zju.labx.objects.LightSource;
	import cn.edu.zju.labx.objects.Ray;
	
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.view.BasicView;

	public class TestSimpleDemoApplication extends BasicView
	{
		private var lightSource:LightSource;
		private var lens:Lens;
		private var board:Board;
		
		public  var originPivot:DisplayObject3D;
		
		public function TestSimpleDemoApplication(viewportWidth:Number=LabXConstant.STAGE_WIDTH, viewportHeight:Number=LabXConstant.STAGE_HEIGHT, scaleToStage:Boolean=true, interactive:Boolean=false, cameraType:String="Target")
		{
			super(viewportWidth, viewportHeight, false, false, CameraType.FREE);
			viewport.interactive = true;
			StageObjectsManager.getDefault.mainView = this;
			camera.zoom = 90;
			createBasicObjects();
			startRendering();
		}
		
		private function createBasicObjects():void
		{
			originPivot = new DisplayObject3D();
			originPivot.x = -LabXConstant.STAGE_WIDTH / 4;
			originPivot.y = -LabXConstant.STAGE_HEIGHT/4;
			scene.addChild(originPivot);
			StageObjectsManager.getDefault.originPivot = originPivot;
			
			addLightSource();
			addLens();
			addBoard();
//			addRay(originPivot);
//			addRayAfterLens();
		}
		
		private function addLightSource():void 
		{
			var redMaterial:ColorMaterial = new ColorMaterial(0xFF0000);
			lightSource = new LightSource(redMaterial);
			lightSource.x = 50;
			StageObjectsManager.getDefault.addLabXObject(lightSource);
			
//			trace("lightSource.sceneX:" + lightSource.sceneX);
//			trace("lightSource.sceneY:" + lightSource.sceneY);
//			trace("lightSource.sceneZ:" + lightSource.sceneZ);
			
		}
		
		private function addLens():void 
		{
			var greenMaterial:ColorMaterial = new ColorMaterial(0x00FF00);
			greenMaterial.interactive = true;
			
			lens = new Lens(greenMaterial);
			lens.x = LabXConstant.STAGE_WIDTH/4;
			StageObjectsManager.getDefault.addLabXObject(lens);
		}
		
		private function addBoard():void
		{
			var blueMaterial:ColorMaterial = new ColorMaterial(0x0000FF);
			board = new Board(blueMaterial);
			board.x = LabXConstant.STAGE_WIDTH/2;
			StageObjectsManager.getDefault.addLabXObject(board);
		}
		
		private function addRay():void
		{
			var yellowMaterial:ColorMaterial = new ColorMaterial(0xFFFFFF);
			var startVertex:Vertex3D = new Vertex3D(lightSource.x, lightSource.y, lightSource.z);
			var endVertex:Vertex3D = new Vertex3D(lens.x, lightSource.y, lens.z);
			var ray:Ray = new Ray();  //TODO: need to be fixed by TJO
			StageObjectsManager.getDefault.addLabXObject(ray);
		}
		
		private function addRayAfterLens():void
		{
			
		}
	}
}