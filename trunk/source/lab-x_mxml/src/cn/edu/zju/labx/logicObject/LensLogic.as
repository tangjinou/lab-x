package cn.edu.zju.labx.logicObject
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.utils.MathUtils;
	
	import org.flintparticles.threeD.geom.Vector3D;
	import org.papervision3d.core.math.Number2D;
	import org.papervision3d.core.math.Number3D;
	
	/**
	 * geom logic for lens class
	 * We assume that the lens is parallel to Y and Z coordinary
	 */
	public class LensLogic
	{
		/**
		 * Position of the Lens
		 */
		private var _position:Number3D;
		/**
		 * Focus of the lens.
		 */
		private var _f:Number;
		
		/**
		 * Construct a Lens Logic object
		 */
		public function LensLogic(position:Number3D=null, f:Number=LabXConstant.LENS_DEFAULT_FOCAL_LENGTH)
		{
			this._position = position||new Number3D();
			this._f = f;
		}
		
		/**
		 * Calculate the ray after the lens
		 */
		public function calculateRayAfterLens(ray:RayLogic):RayLogic {
			var resultRay:RayLogic = new RayLogic();
			var vector:Vector3D = ray.vector;
			var point:Number3D = ray.point;
			
			if (point.x == _position.x) { //if the point is on the lens
				point.x = point.x - vector.x;
				point.y = point.y - vector.y;
				point.y = point.y - vector.y;
			}
			
			var intersection:Number3D = new Number3D();
			if (vector.x == 0)
			{
				return null;
			}
			intersection.x = _position.x;
			intersection.y = ((vector.y/vector.x) * (_position.x - point.x)) + point.y;
			intersection.z = ((vector.z/vector.x) * (_position.x - point.x)) + point.z;
			resultRay.point = intersection;
			
			var xyIntersaction:Number2D = MathUtils.calculateIntersaction(new Number2D(this._position.x,point.y), new Number2D(this.position.x+this.f, this.position.y), new Number2D(point.x, point.y), new Number2D(this.position.x, this.position.y));
			var xzIntersaction:Number2D = MathUtils.calculateIntersaction(new Number2D(this._position.x,point.z), new Number2D(this.position.x+this.f, this.position.z), new Number2D(point.x, point.z), new Number2D(this.position.x, this.position.z));
			
			if (xyIntersaction == null && xzIntersaction == null) {
				resultRay.vector.x = 1;
				resultRay.vector.y = 0;
				resultRay.vector.z = 0;
			}
			else if (xyIntersaction == null) {
				resultRay.vector.x = xzIntersaction.x-intersection.x;
				resultRay.vector.y = 0;
				resultRay.vector.z = xzIntersaction.y-intersection.z;
			} 
			else if (xzIntersaction == null)
			{
				resultRay.vector.x = xyIntersaction.x-intersection.x;
				resultRay.vector.y = xyIntersaction.y-intersection.y;
				resultRay.vector.z = 0;
			}
			else
			{
				resultRay.vector.x = xyIntersaction.x-intersection.x;
				resultRay.vector.y = xyIntersaction.y-intersection.y;
				resultRay.vector.z = xzIntersaction.y-intersection.z;
			}
			
			resultRay.vector  = resultRay.vector.normalize();
			return resultRay;
		}
		
		
		/**
		 ****************************************************************************
		 ******     Get and Set Part for private variables     *********************
		 ****************************************************************************
		 */
		public function get position():Number3D
		{
			return this._position;
		}
		
		public function set position(position:Number3D):void {
			this._position = position;
		}
		
		public function get f():Number
		{
			return this._f;
		}
		
		public function set f(f:Number):void {
			this._f = f;
		}

	}
}