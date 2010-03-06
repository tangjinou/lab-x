package cn.edu.zju.labx.objects
{   
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.events.ILabXListener;
	import cn.edu.zju.labx.events.IUserInputListener;
	import cn.edu.zju.labx.events.LabXEvent;
	
	import com.greensock.*;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.parsers.DAE;
	
	public class Lens extends LabXObject implements ILabXListener ,IUserInputListener
	{   
//		protected var lens:Cylinder;
	    protected var lens:DAE;  
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
            lens.load("../resource/dae/lens.DAE",new MaterialsList( {all:this.material} ) );		
            lens.addEventListener(FileLoadEvent.LOAD_COMPLETE,boxonloaded);  

		}

	    public function handleLabXEvent(event:LabXEvent):Boolean{
		   //TODO:
		   return true;
		}
	   public function hanleUserInputEvent(event:Event):void{
	    	if(event.type == MouseEvent.MOUSE_UP){
	    		 if(StageObjectsManager.getDefault.getMouse_x()>this.getScreen_x()){
//                    this.moveRight(LabXConstant.X_MOVE_MIN);
                    TweenLite.to(lens,2,{x:lens.x+LabXConstant.X_MOVE_MIN,z:this.z});
                    lens.x += LabXConstant.X_MOVE_MIN;
                 }
                 else{
//                    this.moveLeft(LabXConstant.X_MOVE_MIN);
                    TweenLite.to(lens,2,{x:lens.x-LabXConstant.X_MOVE_MIN,z:this.z});
                    lens.x -= LabXConstant.X_MOVE_MIN;
                 }
//                 trace("camera.x"+this.getView().camera.x);
//                 trace("camera.y"+this.getView().camera.y);
//                 trace("camera.z"+this.getView().camera.z);
//                 
//                 trace("viewport.x"+this.getView().viewport.x);
//                 trace("viewport.y"+this.getView().viewport.y);
//                 trace("camera.zoom"+this.getView().camera.zoom);
//                 
//                 trace("this.getMouse_x()"+this.getMouse_x());
//                 trace("this.getScreen_x()"+this.getScreen_x());
                 
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
			lens.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
	    private function boxonloaded(evt:FileLoadEvent):void{  
	    	addChild(lens);  
	    	trace("assssssssssssssss");
	    	trace(lens.childrenList());
            lens.getChildByName("COLLADA_Scene").getChildByName("Box01").addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
        } 
		
	}
}