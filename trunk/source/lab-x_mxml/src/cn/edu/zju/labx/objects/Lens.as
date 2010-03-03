package cn.edu.zju.labx.objects
{   
	import cn.edu.zju.labx.core.StageObjectsManager;
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
	    		 if(this.getMouse_x()>this.getScreen_x()){
                    this.moveRight(this.x_min_offset);
                 }
                 else{
                    this.moveLeft(this.x_min_offset);
                 }
                 trace("camera.x"+this.getView().camera.x);
                 trace("camera.y"+this.getView().camera.y);
                 trace("camera.z"+this.getView().camera.z);
                 
                 trace("viewport.x"+this.getView().viewport.x);
                 trace("viewport.y"+this.getView().viewport.y);
                 trace("camera.zoom"+this.getView().camera.zoom);
                 
                 trace("this.getMouse_x()"+this.getMouse_x());
                 trace("this.getScreen_x()"+this.getScreen_x());
                 
//                  trace("mouse_X"+this.getView().);
//                  trace("mouse_X"+this.getMouse_x());
//                  this.x = this.getMouse_x()-this.getStageWidth()/2;
//                  trace(this.x);
//                  trace("sssssssss");
	    	}
	    }
	     // should destribute the listener 
        override public function addEventListener(type:String, listener:Function,useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{   
			len.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
	}
}