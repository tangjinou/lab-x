package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.events.IUserInputListener;
	import cn.edu.zju.labx.logicObject.LineRayLogic;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.view.layer.ViewportLayer;

	public class LightSource extends LabXObject implements IUserInputListener
	{
		
		private var isOn:Boolean = false;
		protected var light:DAE;
	    
	    
		
		[Embed (source="../assets/models/lightSource.DAE",mimeType="application/octet-stream")]
		public var LightSource_DAE:Class;
		
		public function LightSource(name:String,material:MaterialObject3D=null)
		{
			super(material,name);
			light=new DAE(true);  
			light.addEventListener(FileLoadEvent.LOAD_COMPLETE,daeFileOnloaded);  
			light.load(new LightSource_DAE() as ByteArray,new MaterialsList( {all:this.material} ) );		
			addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
			createDisplayObject();
		}
		private function createDisplayObject():void
		{   
			
		}
		
		public function createRay():void{
		   	_ray = new Ray();
			
			var normal:Number3D = getNormal();
			var lineNormal:Number3D = new Number3D(-normal.x, -normal.y, -normal.z);
			
			
			var royLogic0:LineRayLogic = new LineRayLogic(new Number3D(this.x,this.y+10,this.z), lineNormal);
			var lineRay0:LineRay = new LineRay(royLogic0);
			
			var royLogic1:LineRayLogic = new LineRayLogic(new Number3D(this.x,this.y+10+5,this.z), lineNormal);
			var lineRay1:LineRay = new LineRay(royLogic1);
			
			var royLogic2:LineRayLogic = new LineRayLogic(new Number3D(this.x,this.y+10-5,this.z), lineNormal);
			var lineRay2:LineRay = new LineRay(royLogic2);
			
			var royLogic3:LineRayLogic = new LineRayLogic(new Number3D(this.x,this.y+10,this.z+5), lineNormal);
			var lineRay3:LineRay = new LineRay(royLogic3);
			
			var royLogic4:LineRayLogic = new LineRayLogic(new Number3D(this.x,this.y+10,this.z-5), lineNormal);
			var lineRay4:LineRay = new LineRay(royLogic4);
			
			var lineRays:ArrayCollection =new ArrayCollection();
			lineRays.addItem(lineRay0);
			lineRays.addItem(lineRay1);
			lineRays.addItem(lineRay2);
			lineRays.addItem(lineRay3);
			lineRays.addItem(lineRay4);
			_ray.setLineRays(lineRays);

		}
		
		public function get isLightOn():Boolean{
            return isOn;		
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
		   	    	   openRay();
                       StageObjectsManager.getDefault.addMessage("打开光源");
		   	    	 } else {
		   	    	 	StageObjectsManager.getDefault.rayManager.clearRays();
//		   	    	 	StageObjectsManager.getDefault.originPivot.removeChild(getRay());
		   	    	 	this._ray = null;
		   	    	 	StageObjectsManager.getDefault.addMessage("关闭光源");
		   	    	 }
	   	    	 }
			}
		}
		
		public function openRay():void{
			createRay();
		   	StageObjectsManager.getDefault.originPivot.addChild(getRay());
		   	_ray.displayRays();
		   	StageObjectsManager.getDefault.rayManager.notify(this._ray);
		   	
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
			var effectLayer:ViewportLayer = new ViewportLayer(StageObjectsManager.getDefault.mainView.viewport, null);
			effectLayer.addDisplayObject3D(this, true);
			StageObjectsManager.getDefault.layerManager.equipmentLayer.addLayer(effectLayer);
			light.getChildByName("COLLADA_Scene").getChildByName("Cylinder01").addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
            light.getChildByName("COLLADA_Scene").getChildByName("Cylinder02").addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
        } 
	}
}