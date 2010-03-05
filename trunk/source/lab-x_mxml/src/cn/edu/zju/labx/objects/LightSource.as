package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.events.ILabXListener;
	import cn.edu.zju.labx.events.IUserInputListener;
	import cn.edu.zju.labx.events.LabXEvent;
	
	import flash.events.Event;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;

	public class LightSource extends LabXObject implements ILabXListener, IUserInputListener
	{
		public function LightSource(material:MaterialObject3D=null)
		{
			super(material);
			createDisplayObject();
		}
		
		private function createDisplayObject():void
		{
			var materialsList:MaterialsList = new MaterialsList();
			materialsList.addMaterial(material,"front");
			materialsList.addMaterial(material,"back");
			materialsList.addMaterial(material,"left");
			materialsList.addMaterial(material,"right");
			materialsList.addMaterial(material,"top");
			materialsList.addMaterial(material,"bottom");
			
			var cube:Cube =new Cube(materialsList,5,100,100);
		   	this.addChild(cube);
		}
		
		public function handleLabXEvent(event:LabXEvent):Boolean
		{
			//TODO:
			return true;
		}
		
		public  function hanleUserInputEvent(event:Event):void
		{
			//TODO:
		}
	}
}