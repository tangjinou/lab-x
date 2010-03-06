package cn.edu.zju.labx.objects
{   
    import cn.edu.zju.labx.events.ILabXListener;
    import cn.edu.zju.labx.events.IUserInputListener;
    import cn.edu.zju.labx.events.LabXEvent;
    
    import flash.events.Event;
    
    import org.papervision3d.core.proto.MaterialObject3D;
    import org.papervision3d.events.InteractiveScene3DEvent;
    import org.papervision3d.materials.utils.MaterialsList;
    import org.papervision3d.objects.primitives.Cube;
    
    /**
     * Board is an LabX Object used to display the light result
     * 
     */
	public class Board extends LabXObject implements ILabXListener, IUserInputListener
	{   
		protected var cube:Cube;
		
		/**
		 * Create a board
		 * 
		 * @param material the material to create object in it
		 * 
		 */
		public function Board(material:MaterialObject3D=null)
		{
			super(material);
			createDisplayObject();
		    addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
		}
		
		public function createDisplayObject():void{
			var materialsList:MaterialsList = new MaterialsList();
			materialsList.addMaterial(material,"front");
			materialsList.addMaterial(material,"back");
			materialsList.addMaterial(material,"left");
			materialsList.addMaterial(material,"right");
			materialsList.addMaterial(material,"top");
			materialsList.addMaterial(material,"bottom");
		   	cube = new Cube(materialsList,20,100,100);
		   	this.addChild(cube);
		}

		
	    public function handleLabXEvent(event:LabXEvent):Boolean{
		   //TODO:
		   return true;
		}
		
		public function hanleUserInputEvent(event:Event):void
		{
			//TODO:
		}
		
        override public function addEventListener(type:String, listener:Function,useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{   
			cube.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		
//	    override public  function eventTriger(event:String):void{
//	    	if(event == MouseEvent.MOUSE_UP){
//	    		 if(this.getMouse_x()>this.getScreen_x()){
//                    this.moveRight(this.x_min_offset);
//                 }
//                 else{
//                    this.moveLeft(this.x_min_offset);
//                 }
//      		}
//	    }
	    
	    // should destribute the listener 
		
	}
}