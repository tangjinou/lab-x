package
{
	import cn.edu.zju.labx.objects.Board;
	import cn.edu.zju.labx.objects.Lens;
	import cn.edu.zju.labx.objects.Ray;

	import flash.events.Event;

	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.view.BasicView;

	public class TestLabxObjectApplication extends BasicView
	{

		public function TestLabxObjectApplication()
		{
			super(800, 420, true, false, CameraType.FREE);
			viewport.interactive=true;
			var material:FlatShadeMaterial=new FlatShadeMaterial(null, 0xcc0000);
			material.interactive=true;
			var lens:Lens=new Lens(material);
			var ray:Ray=new Ray(material);
			var board:Board=new Board(material);
//			scene.addChild(lens);
//            scene.addChild(ray);
			scene.addChild(board);
			startRendering();
		}

		override protected function onRenderTick(event:Event=null):void
		{
			super.onRenderTick(event);
		}

	}
}