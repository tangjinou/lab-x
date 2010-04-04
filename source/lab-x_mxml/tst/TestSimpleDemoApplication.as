package
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.logicObject.RayLogic;
	import cn.edu.zju.labx.objects.Board;
	import cn.edu.zju.labx.objects.Lens;
	import cn.edu.zju.labx.objects.LightSource;
	import cn.edu.zju.labx.objects.LineRay;
	import cn.edu.zju.labx.objects.Ray;

	import mx.collections.ArrayCollection;

	import org.flintparticles.threeD.geom.Vector3D;
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.view.BasicView;

	public class TestSimpleDemoApplication extends BasicView
	{
		private var lightSource:LightSource;
		private var lens:Lens;
		private var board:Board;

		public var originPivot:DisplayObject3D;

		public function TestSimpleDemoApplication(viewportWidth:Number=LabXConstant.STAGE_WIDTH, viewportHeight:Number=LabXConstant.STAGE_HEIGHT, scaleToStage:Boolean=true, interactive:Boolean=false, cameraType:String="Target")
		{
			super(viewportWidth, viewportHeight, false, false, CameraType.FREE);
			viewport.interactive=true;
			StageObjectsManager.getDefault.mainView=this;
			camera.zoom=90;
			createBasicObjects();
			startRendering();
		}

		private function createBasicObjects():void
		{
			originPivot=new DisplayObject3D();
			originPivot.x=-LabXConstant.STAGE_WIDTH / 4;
			originPivot.y=-LabXConstant.STAGE_HEIGHT / 4;
			scene.addChild(originPivot);
			StageObjectsManager.getDefault.originPivot=originPivot;

			addLightSource();
			addLens();
			addBoard();
//			addRay();
//			addRayAfterLens();
		}

		private function addLightSource():void
		{
			var redMaterial:ColorMaterial=new ColorMaterial(0xFF0000);
			redMaterial.interactive=true;

			lightSource=new LightSource(redMaterial);
			lightSource.x=50;
			StageObjectsManager.getDefault.addLabXObject(lightSource);
			StageObjectsManager.getDefault.originPivot.addChild(lightSource);
//			trace("lightSource.sceneX:" + lightSource.sceneX);
//			trace("lightSource.sceneY:" + lightSource.sceneY);
//			trace("lightSource.sceneZ:" + lightSource.sceneZ);

		}

		private function addLens():void
		{
			var greenMaterial:ColorMaterial=new ColorMaterial(0x00FF00);
			greenMaterial.interactive=true;

			lens=new Lens(greenMaterial);
			lens.x=LabXConstant.STAGE_WIDTH / 4;
			StageObjectsManager.getDefault.addLabXObject(lens);
			StageObjectsManager.getDefault.originPivot.addChild(lens);
		}

		private function addBoard():void
		{
			var blueMaterial:ColorMaterial=new ColorMaterial(0x0000FF);
			board=new Board(blueMaterial);
			board.x=LabXConstant.STAGE_WIDTH / 2;
			StageObjectsManager.getDefault.addLabXObject(board);
			StageObjectsManager.getDefault.originPivot.addChild(board);
		}

		private function addRay():void
		{
			var yellowMaterial:ColorMaterial=new ColorMaterial(0xFFFFFF);
			var lineRay1:LineRay=new LineRay(new RayLogic(new Number3D(0, 0, 0), new Vector3D(1, 0, 0)));
			var lineRay2:LineRay=new LineRay(new RayLogic(new Number3D(0, 20, 0), new Vector3D(1, 0, 0)));
			var lineRays:ArrayCollection=new ArrayCollection();
			lineRays.addItem(lineRay1);
			lineRays.addItem(lineRay2);
			var ray:Ray=new Ray(); //TODO: need to be fixed by TJO
			StageObjectsManager.getDefault.addLabXObject(ray);
			StageObjectsManager.getDefault.originPivot.addChild(board);
		}

		private function addRayAfterLens():void
		{

		}
	}
}