package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.core.UserInputHandler;
	import cn.edu.zju.labx.events.IUserInputListener;
	
	import org.hamcrest.object.instanceOf;
	import org.papervision3d.core.geom.TriangleMesh3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	
	/**
	 * LabX Object is the basic object in LabX model, any object that want 
	 * put in LabX environment should extends from this class
	 * 
	 */
	public class LabXObject extends TriangleMesh3D
	{
		
		public function LabXObject( material:MaterialObject3D, vertices:Array=null, faces:Array=null, name:String=null )
		{
		   super(material, vertices, faces, null );
		}
		
		/**
		 * Register this object to 
		 */
		protected function objectPressHandler(event:InteractiveScene3DEvent):void {
			if (instanceOf(IUserInputListener)) {
				UserInputHandler.getDefault.currentSelectedObject = this as IUserInputListener;
			}
		}
		
		/**
		 * Get the object X axis in screen coordiate
		 */
	    public function getScreen_x():int{
	       return this.x + StageObjectsManager.getDefault.stage_width/2;
	    }
	    
	    /**
		 * Get the object Y axis in screen coordiate
		 */
	    public function getScreen_y():int{
	       return this.y + StageObjectsManager.getDefault.stage_height/2;
	    }
	    
	    /*********************************************************/
	    
	    public function setX_Platform(_x:Number):void{
	       
	    }
	    
	    public function get x_in_platform():Number{
	       return 0;
	    }
	    
	}
}