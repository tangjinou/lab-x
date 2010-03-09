package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.events.IUserInputListener;
	import cn.edu.zju.labx.events.LabXEvent;
	import cn.edu.zju.labx.logicObject.RayLogic;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.flintparticles.threeD.geom.Vector3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;

	public class LightSource extends LabXObject implements IUserInputListener, IRayMaker
	{
		
		var isOn:Boolean = false;
		
		protected var light:DAE; 
		
		public function LightSource(material:MaterialObject3D=null)
		{
			super(material);
			light=new DAE(true);  
            light.load(ResourceManager.RAY_DAE_URL,new MaterialsList( {all:this.material} ) );		
			light.addEventListener(FileLoadEvent.LOAD_COMPLETE,daeFileOnloaded);  
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
		
		public function getRay():Ray
		{
       	 	var ray:RayLogic = new RayLogic(new Number3D(this.x, this.y, this.z), new Vector3D(1, 0, 0)); 
			return new Ray();
		}
		
		public function setRay(ray:Ray):void
		{
			
		}
		
		public  function hanleUserInputEvent(event:Event):void
		{
			if (userInputHandle != null)
			{
				userInputHandle.call(this, event);
			}
			
			if (event is MouseEvent)
			{
				 var mouseEvent:MouseEvent = event as MouseEvent;
	   	    	 if (mouseEvent.type == MouseEvent.MOUSE_UP)
	   	    	 {
	   	    	 	isOn = !isOn;
	   	    	 }
	   	    	 
	   	    	 if (isOn)
	   	    	 {
	   	    	 	StageObjectsManager.getDefault.notify(new LabXEvent(this));
	   	    	 }
			}
			
		}
		
	    private function daeFileOnloaded(evt:FileLoadEvent):void{  
	    	addChild(ray);  
        } 
	}
}