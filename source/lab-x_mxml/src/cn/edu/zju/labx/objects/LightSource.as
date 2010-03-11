package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.events.IUserInputListener;
	import cn.edu.zju.labx.events.LabXEvent;
	import cn.edu.zju.labx.logicObject.RayLogic;
	import cn.edu.zju.labx.utils.ResourceManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.flintparticles.threeD.geom.Vector3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.parsers.DAE;

	public class LightSource extends LabXObject implements IUserInputListener, IRayMaker
	{
		
		private var isOn:Boolean = false;
		protected var light:DAE;
	    public var height:Number =100;
	    public var width:Number =60;
		public var ray:Ray; 
		
		public function LightSource(material:MaterialObject3D=null)
		{
			super(material);
			light=new DAE(true);  
			light.addEventListener(FileLoadEvent.LOAD_COMPLETE,daeFileOnloaded);  
			light.load(ResourceManager.RAY_DAE_URL,new MaterialsList( {all:this.material} ) );		
			addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
			createDisplayObject();
		}
		private function createDisplayObject():void
		{   
			
		}
		
		public function createRay():void{
		   	ray = new Ray();
//			addChild(ray);
			
			var royLogic1:RayLogic = new RayLogic(new Number3D(this.x,this.y+20+5,this.z),new Vector3D(1,0,0));
			var lineRay1:LineRay = new LineRay(royLogic1);
			
			var royLogic2:RayLogic = new RayLogic(new Number3D(this.x,this.y+20-5,this.z),new Vector3D(1,0,0));
			var lineRay2:LineRay = new LineRay(royLogic2);
//			
			var royLogic3:RayLogic = new RayLogic(new Number3D(this.x,this.y+20,this.z+5),new Vector3D(1,0,0));
			var lineRay3:LineRay = new LineRay(royLogic3);
			
			var royLogic4:RayLogic = new RayLogic(new Number3D(this.x,this.y+20,this.z-5),new Vector3D(1,0,0));
			var lineRay4:LineRay = new LineRay(royLogic4);
			
			var lineRays:ArrayCollection =new ArrayCollection();
			lineRays.addItem(lineRay1);
			lineRays.addItem(lineRay2);
			lineRays.addItem(lineRay3);
			lineRays.addItem(lineRay4);
			ray.setLineRays(lineRays);

		}
		
		public function getRay():Ray
		{
//       	 	var ray:RayLogic = new RayLogic(new Number3D(this.x, this.y, this.z), new Vector3D(1, 0, 0));
//       	 	var rayArray:ArrayCollection = new ArrayCollection();
//       	 	rayArray.addItem(ray);
//			return new Ray(null, rayArray, this.x);
			return ray;
		}
		
		public function setRay(ray:Ray):void
		{
			
		}
		
		public  function hanleUserInputEvent(event:Event):void
		{
			if (userInputHandle != null)
			{
				userInputHandle.call(this, event);
				return;
			}
			
			if (event is MouseEvent)
			{
				 var mouseEvent:MouseEvent = event as MouseEvent;
	   	    	 if (mouseEvent.type == MouseEvent.MOUSE_UP)
	   	    	 {
	   	    	 	isOn = !isOn;
		   	    	 if (isOn)
		   	    	 {  
		   	    	 	createRay();
		   	    	 	StageObjectsManager.getDefault.originPivot.addChild(getRay());
		   	    	 	StageObjectsManager.getDefault.notify(new LabXEvent(this, LabXEvent.LIGHT_ON));
		   	    	 	ray.EndX=1000;
		   	    	 } else {
		   	    	 	StageObjectsManager.getDefault.originPivot.removeChild(getRay());
		   	    	 	this.ray = null;
		   	    	 	StageObjectsManager.getDefault.notify(new LabXEvent(this, LabXEvent.LIGHT_OFF));
		   	    	 }
	   	    	 }
			}
		}
		
		// should destribute the listener 
        override public function addEventListener(type:String, listener:Function,useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{   
//			light.getChildByName("COLLADA_Scene").getChildByName("Cylinder01").addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
//		    light.getChildByName("COLLADA_Scene").getChildByName("Cylinder02").addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
		}
		
		
	    private function daeFileOnloaded(evt:FileLoadEvent):void{  
	    	addChild(light);  
//			trace(light.childrenList());
			this.useOwnContainer = true;
			light.getChildByName("COLLADA_Scene").getChildByName("Cylinder01").addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
            light.getChildByName("COLLADA_Scene").getChildByName("Cylinder02").addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
        } 
	}
}