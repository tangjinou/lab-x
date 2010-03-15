package cn.edu.zju.labx.objects
{   
    import cn.edu.zju.labx.core.LabXConstant;
    import cn.edu.zju.labx.core.StageObjectsManager;
    import cn.edu.zju.labx.events.IUserInputListener;
    import cn.edu.zju.labx.events.LabXEvent;
    import cn.edu.zju.labx.logicObject.InterferenceLogic;
    
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.geom.Rectangle;
    
    import org.papervision3d.core.proto.MaterialObject3D;
    import org.papervision3d.events.InteractiveScene3DEvent;
    import org.papervision3d.materials.BitmapMaterial;
    import org.papervision3d.materials.utils.MaterialsList;
    import org.papervision3d.objects.primitives.Cube;
    
    /**
     * Board is an LabX Object used to display the light result
     * 
     */
	public class Board extends LabXObject implements IUserInputListener
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
            height=LabXConstant.LABX_OBJECT_HEIGHT;
	        width=LabXConstant.LABX_OBJECT_WIDTH/10;
	        depth=LabXConstant.LABX_OBJECT_DEPTH;
		   	cube = new Cube(materialsList,width,depth,height);
		   	this.addChild(cube);
		}

		
		
		public function hanleUserInputEvent(event:Event):void
		{
			//TODO:
		}
		
        override public function addEventListener(type:String, listener:Function,useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{   
			cube.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function displayImage():void
		{
			var theta:Number = Math.PI/4;
			var interf:InterferenceLogic = new InterferenceLogic(theta, LabXConstant.WAVE_LENGTH);
			var distance:Number = interf.getDistance();
			
			var bmp:BitmapData = new BitmapData(depth, height, false, 0x0);
			for (var i:Number = 0; i < 10; i++)
			{
				bmp.fillRect(new Rectangle(depth*i/5, 0, depth/10, height), 0x0000FF);
			}
			var material:BitmapMaterial = new BitmapMaterial(bmp);
			material.smooth = true;
			cube.replaceMaterialByName(material, "front");
			
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