package cn.edu.zju.labx.objects
{   
	import cn.edu.zju.labx.events.ILabXListener;
	import cn.edu.zju.labx.events.IUserInputListener;
	import cn.edu.zju.labx.events.LabXEvent;
	import cn.edu.zju.labx.utils.ResourceManager;
	
	import com.greensock.*;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.parsers.DAE;
	
	public class Lens extends LabXObject implements ILabXListener ,IUserInputListener, IRayMaker
	{   
//		protected var lens:Cylinder;
	    protected var lens:DAE;
	    
	    public var width:Number =120;
	    public var height:Number=120;
   
		/**
		 * To store the old Mouse X position;
		 */
	    public var oldMouseX:Number = -1;
	    
		public function Lens(material:MaterialObject3D=null)
		{
			super(material);
			createChildren();
			addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
			
			
		}
		public function createChildren():void{
//		   	lens = new Cylinder(this.material,100,100,30,10);
//		   	this.addChild(lens);
            lens=new DAE(true);  
            lens.load(ResourceManager.LENS_DAE_URL,new MaterialsList( {all:this.material} ) );		
            lens.addEventListener(FileLoadEvent.LOAD_COMPLETE,daeFileOnloaded);  

		}

	    public function handleLabXEvent(event:LabXEvent):Boolean{
		   //TODO:
//		   var ray:Ray = event.previousXObject.getRawRay();
		   
		   return true;
		}
		
		public function getRay():Ray
		{
//       	 	var ray:RayLogic = new RayLogic(new Number3D(this.x, this.y, this.z), new Vector3D(1, 0, 0)); 
			return null;
		}
		
		public function setRay(ray:Ray):void
		{
			
		}
		
	    public function hanleUserInputEvent(event:Event):void{
	   	    if(userInputHandle!=null){
	   	       userInputHandle.call(this,event);
	   	       return;
	   	    }
	   	    if(event is MouseEvent){
	   	   	     var mouseEvent:MouseEvent = event as MouseEvent;
	   	    	 if (mouseEvent.type == MouseEvent.MOUSE_DOWN) {
	   	    	 	oldMouseX = mouseEvent.stageX;
	   	    	 } else if (mouseEvent.type == MouseEvent.MOUSE_UP) {
	   	    	 	oldMouseX = -1;
	   	    	 } else if ((mouseEvent.type == MouseEvent.MOUSE_MOVE) && (oldMouseX != -1)) {
	   	    	 	var xMove:Number = mouseEvent.stageX - oldMouseX;
	   	    	 	this.x += xMove;
	   	    	 	oldMouseX = mouseEvent.stageX;
	   	    	 }
	    	}
	    	
	    }
	    
	    // should destribute the listener 
        override public function addEventListener(type:String, listener:Function,useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{   
			lens.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
	    private function daeFileOnloaded(evt:FileLoadEvent):void{  
	    	addChild(lens);  
//	    	trace(lens.childrenList());
            lens.getChildByName("COLLADA_Scene").getChildByName("Sphere02").addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
            lens.getChildByName("COLLADA_Scene").getChildByName("Sphere01").addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
        } 
		
	}
}