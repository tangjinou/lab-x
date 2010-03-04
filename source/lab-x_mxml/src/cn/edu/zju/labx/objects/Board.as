package cn.edu.zju.labx.objects
{   
    import cn.edu.zju.labx.events.ILabXListener;
    import cn.edu.zju.labx.events.LabXEvent;
    
    import flash.events.MouseEvent;
    
    import org.papervision3d.core.proto.MaterialObject3D;
    import org.papervision3d.events.InteractiveScene3DEvent;
    import org.papervision3d.materials.utils.MaterialsList;
    import org.papervision3d.objects.primitives.Cube;
	public class Board extends LabXObject implements ILabXListener
	{   
		protected var cube:Cube;
		
		public function Board(material:MaterialObject3D=null)
		{
			super(this,material);
			createChildren();
		    addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
		}
		
		public function createChildren():void{
			var materialsList:MaterialsList = new MaterialsList();
			materialsList.addMaterial(material,"front");
			materialsList.addMaterial(material,"back");
			materialsList.addMaterial(material,"left");
			materialsList.addMaterial(material,"right");
			materialsList.addMaterial(material,"top");
			materialsList.addMaterial(material,"bottom");
		   	cube = new Cube(materialsList,50,100,100);
		   	this.addChild(cube);
		}

		
	    public function handleLabXEvent(event:LabXEvent):Boolean{
		   //TODO:
		   return true;
		}
		
		
	    override public  function eventTriger(event:String):void{
	    	if(event == MouseEvent.MOUSE_UP){
//	    		 if(this.getMouse_x()>this.getScreen_x()){
//                    this.moveRight(this.x_min_offset);
//                 }
//                 else{
//                    this.moveLeft(this.x_min_offset);
//                 }
      		}
	    }
	    
	    // should destribute the listener 
        override public function addEventListener(type:String, listener:Function,useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{   
			cube.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
	}
}