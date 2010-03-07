package cn.edu.zju.labx.objects
{   
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
	    
	    public var width:Number =120;
	    public var height:Number=120;
   
	    
	    
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
            lens.addEventListener(FileLoadEvent.LOAD_COMPLETE,daeFileOnloaded);  

		}

	    public function handleLabXEvent(event:LabXEvent):Boolean{
		   //TODO:
		   return true;
		}
		
	    public function hanleUserInputEvent(event:Event):void{
	   	    if(userInputHandle!=null){
	   	       userInputHandle.call(this,event);
	   	       return;
	   	    }
	   	    if(event is MouseEvent){
//	   	    	 var mouseEvent:MouseEvent = event as MouseEvent;
//	   	   	     TweenLite.to(lens, 0, {x:StageObjectsManager.getDefault.getMouse_x()-LabXConstant.STAGE_WIDTH/2, z:this.z});
	   	   	     this.x = StageObjectsManager.getDefault.getMouse_originPivot_relative_x(); 
//	   	   	     trace("this.x"+this.x);
//               trace("x:"+mouseEvent.localX);
//	   	   	     trace("Mouse_x:"+StageObjectsManager.getDefault.getMouse_x());
//	   	   	     trace(StageObjectsManager.getDefault.getMouse_originPivot_relative_x());
//                 trace(StageObjectsManager.getDefault.getMouse_x());
//                 trace(StageObjectsManager.getDefault.getMouse_originPivot_relative_x());
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