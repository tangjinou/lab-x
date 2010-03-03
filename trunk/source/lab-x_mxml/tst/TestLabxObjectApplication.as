package
{
	import cn.edu.zju.labx.objects.Lens;
	
	import flash.events.Event;
	
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.view.BasicView;
	
	public class TestLabxObjectApplication extends BasicView
	{   
		
		public function TestLabxObjectApplication()
		{
			super(800, 420, true, false, CameraType.FREE);
			viewport.interactive = true;
			var material:FlatShadeMaterial = new FlatShadeMaterial(null, 0xcc0000);
			material.interactive = true;
			scene.addChild(new Lens(material));
			startRendering();
		}
		
		override protected function onRenderTick(event:Event = null):void
        {
            super.onRenderTick(event);
        }

	}
}