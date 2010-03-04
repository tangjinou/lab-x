package
{
	import cn.edu.zju.labx.objects.Board;
	import cn.edu.zju.labx.objects.Lens;
	
	import flash.events.Event;
	
	import mx.skins.Border;
	
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.view.BasicView;

	public class TestMainViewApplication extends BasicView
	{   
		
		private var cube:Cube;
		private var lens:Lens;
		private var board:Board;
		public function TestMainViewApplication(viewportWidth:Number=640, viewportHeight:Number=480, scaleToStage:Boolean=true, interactive:Boolean=false, cameraType:String="Target")
		{
			super(800, 420, true, false, CameraType.FREE);
			viewport.interactive = true;
			var blue:ColorMaterial = new ColorMaterial(0x0000FF);
			var red:ColorMaterial = new ColorMaterial(0xFF0000);
			red.interactive = true;
			var materialsList:MaterialsList = new MaterialsList();
			materialsList.addMaterial(blue,"front");
			materialsList.addMaterial(blue,"back");
			materialsList.addMaterial(blue,"left");
			materialsList.addMaterial(blue,"right");
			materialsList.addMaterial(blue,"top");
			materialsList.addMaterial(blue,"bottom");
			cube =new Cube(materialsList,800,200,20);
			
			cube.y -=200;
			scene.addChild(cube);
            lens = new Lens(red);
            lens.y -=130;
            scene.addChild(lens);
            
            var white:ColorMaterial = new ColorMaterial(0xfffafa);
			white.interactive = true;
            board = new  Board(white);
            board.x +=300
            board.y -=120
            scene.addChild(board);
			startRendering();
		}
		
		
		override protected function onRenderTick(event:Event = null):void
        {
            super.onRenderTick(event);
        }
		
	}
}