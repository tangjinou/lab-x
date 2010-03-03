package cn.edu.zju.labx.objects
{   
	import cn.edu.zju.labx.events.ILabXListener;
	import cn.edu.zju.labx.events.LabXEvent;
	
	import flash.events.MouseEvent;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.objects.primitives.Cylinder;
	
	public class Lens extends LabXObject implements ILabXListener
	{   
		protected var len:Cylinder;
		public function Lens(material:MaterialObject3D=null)
		{
			super(this,material);
			createChildren();
		    addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
		}
		public function createChildren():void{
		   	len = new Cylinder(this.material,100,100,30,10);
		   	this.addChild(len);
		}
		public function labXObjectPressHandler():void{
		   
		}
	    public function handleLabXEvent(event:LabXEvent):Boolean{
		   //TODO:
		   return true;
		}
	    override public  function eventTriger(event:String):void{
	    	if(event == MouseEvent.MOUSE_UP){
                 this.moveRight(5);
	    	}
	    }
	    
	     // should destribute the listener 
        override public function addEventListener(type:String, listener:Function,useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{   
			len.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
	}
}