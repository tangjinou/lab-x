package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.core.UserInputHandler;
	import cn.edu.zju.labx.events.IRayMaker;
	import cn.edu.zju.labx.events.IUserInputListener;
	import cn.edu.zju.labx.logicObject.LineRayLogic;
	import cn.edu.zju.labx.utils.MathUtils;
	
	import org.hamcrest.object.instanceOf;
	import org.papervision3d.core.geom.TriangleMesh3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Plane3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	
	/**
	 * LabX Object is the basic object in LabX model, any object that want 
	 * put in LabX environment should extends from this class
	 * 
	 */
	public class LabXObject extends TriangleMesh3D implements IRayMaker
	{
		/**
		 * This  Function is for add userInputHandle
		 */ 
		public var userInputHandle:Function;
        
		/**
		 * Create an LabX Object
		 */
		public function LabXObject( material:MaterialObject3D,name:String,vertices:Array=null, faces:Array=null)
		{
		   super(material, vertices, faces, name);
		}
		
		/**
		 * Register this object to 
		 */
		protected function objectPressHandler(event:InteractiveScene3DEvent):void {
			if (instanceOf(IUserInputListener)) {
				UserInputHandler.getDefault.currentSelectedObject = this as IUserInputListener;
                UserInputHandler.getDefault.objectPressHandlerHook(event,this);
                StageObjectsManager.getDefault.addMessage("已经选中"+this.name);
                StageObjectsManager.getDefault.addMessage("键盘 up:物体上移动,down:物体下移动");
                StageObjectsManager.getDefault.addMessage("left:物体左移动,right:物体右移动");
			}
		}
		
	    /*********************************************************/
	    
	    protected var _ray:Ray  = null;

	    public function getRay():Ray
		{
//       	var ray:RayLogic = new RayLogic(new Number3D(this.x, this.y, this.z), new Vector3D(1, 0, 0)); 
			return this._ray;
		}
		
		public function setRay(ray:Ray):void
		{
			this._ray = ray;
		}
		
		/********************************************************************/
		/* This for find the ray if is on this object                       */
		/*******************************************************************/
		public var height:Number = LabXConstant.LABX_OBJECT_HEIGHT;
		public var width:Number  = LabXConstant.LABX_OBJECT_WIDTH;
		public var depth:Number  = LabXConstant.LABX_OBJECT_DEPTH;
		
		public var circle:Number = height/2;
		
		override public function set scale( scale:Number ):void
		{
			this.circle = circle * scale;
			super.scale = scale;
		}
		
		public function isLineRayOnObject(lineRayLogic:LineRayLogic):Boolean
		{
			var point:Number3D = new Number3D(lineRayLogic.x, lineRayLogic.y, lineRayLogic.z);
			var vector:Number3D = new Number3D(lineRayLogic.dx, lineRayLogic.dy, lineRayLogic.dz);
			var plane:Plane3D = getObjectPlane();
			if(Math.abs(plane.distance(point)) < LabXConstant.NUMBER_PRECISION)
			{
				return false;
			}
			
			var anPoint:Number3D = Number3D.sub(point, vector);
			var intersection:Number3D = plane.getIntersectionLineNumbers(point, anPoint);
			if (!MathUtils.isVetorTheSameDirection(Number3D.sub(intersection, point), vector))return false; //check if on the same direction on ray
			
			if(Number3D.sub(intersection, new Number3D(this.x,this.y,this.z)).modulo < circle)
			{
				return true;
			}
			return false;
			
		}
		/**
		 * Get the Plane of this object
		 */
		public function getObjectPlane():Plane3D
		{
			return new Plane3D(getNormal(), getPosition())
		}
		
		/**
		 * Get the Plane of this object
		 */
		public function getNormal():Number3D
		{
			return new Number3D(-this.transform.n11, -this.transform.n21, -this.transform.n31);
		}
		
		/**
		 * Get the Plane of this object
		 */
		public function getPosition():Number3D
		{
			return new Number3D(this.x, this.y, this.z);
		}
		
			/**
		 *  To find the ray if is on this object  
		 */
		public function isTheRayOnThisObject(rayVector:Number3D,rayStartPoint:Number3D):Boolean{
		   try{
		    var pointInPlat:Number3D = MathUtils.calculatePointInPlane(this.transform,rayVector,rayStartPoint);
		    if(pointInPlat ==null){
		       return false;
		    }
		     if(MathUtils.distanceToNumber3D(new Number3D(this.x,this.y,this.z),pointInPlat)<circle){
		        return true;  
		     }
		   }catch(err:Error){
		     return false;
		   }
		    return false;
		}
		
		/**
		 *   This is for get object with the material on it, it should be overrite 
		 * 
		 *   when the this materials not on the basic object,
		 * 
		 *   for example: lens may not have the materials on 
		 * 
		 *   root,but on the sphere
		 * 
		 */ 
		public function getObjectWithMaterial():TriangleMesh3D{
		
		    return this;
		}
		
	}
}