package cn.edu.zju.labx.objects
{   
    import cn.edu.zju.labx.core.StageObjectsManager;
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
		
	    public var height:int;
	    public var width:int;
	    public var depth:int;

		
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
            height=100;
	        width=20;
	        depth=100;
		   	cube = new Cube(materialsList,width,depth,height);
		   	this.addChild(cube);
		}

		
	    public function handleLabXEvent(event:LabXEvent):Boolean{
		   //TODO:
		   var obj:LabXObject = StageObjectsManager.getDefault.getPreviousXObject(this);
		   if (obj != null && obj is IRayMaker)
		   {  
		   	  var rayMaker:IRayMaker =obj as IRayMaker;
		   	  var oldRay:Ray = rayMaker.getRay();
		   	  oldRay.EndX = this.x;
		   }
		   
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