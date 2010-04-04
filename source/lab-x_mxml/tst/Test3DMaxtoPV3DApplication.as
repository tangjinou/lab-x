package
{
	import flash.events.Event;

	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.view.BasicView;

	public class Test3DMaxtoPV3DApplication extends BasicView
	{
		private var box:DAE;
		private var plane:Plane;

//        private var cube:Cube;
		public function Test3DMaxtoPV3DApplication(viewportWidth:Number=640, viewportHeight:Number=480, scaleToStage:Boolean=true, interactive:Boolean=false, cameraType:String="Target")
		{
			super(800, 600, true, false, CameraType.DEBUG);
			viewport.interactive=true;
//			viewport.x =500;
//			viewport.y =400;
			plane=new Plane(null, 100, 100, 10, 10);
			scene.addChild(plane);

			box=new DAE(true);
			box.load("../resource/dae/lens.DAE", new MaterialsList({all: new ColorMaterial(0xFF0000)}));

			box.addEventListener(FileLoadEvent.LOAD_COMPLETE, boxonloaded);
//                                   
//           camera.x=20;  
//           camera.y=00;  
//           camera.z=-20;  
			camera.rotationY+=90;


			startRendering();

		}

		private function boxonloaded(evt:FileLoadEvent):void
		{
			scene.addChild(plane);
			scene.addChild(box);
			camera.lookAt(box);
			trace("load ok~~");
		}

		override protected function onRenderTick(event:Event=null):void
		{
			super.onRenderTick(event);
		}


	}
}