package cn.edu.zju.labx.logicObject
{
	import org.flintparticles.threeD.geom.Vector3D;
	import org.papervision3d.core.math.Number3D;
	
	/**
	 * This is the logic part for a line of a ray, it construct from a point and an
	 * vector, the point means the line pass throgh the point, vector means the 
	 * direction of the line. 
	 * 
	 */
	public class RayLogic
	{
		/**
		 * An point in the ray.
		 */
		private var _point:Number3D;
		
		/**
		 * The vector of the ray.
		 */
		private var _vector:Vector3D;
		
		/**
		 * Construct an ray logic
		 */
		public function RayLogic(point:Number3D=null, vector:Vector3D=null)
		{
			this._point = point || new Number3D();
			this._vector = vector || new Vector3D(1,0,0);
		}
		
		/**
		 * Check whether the point is on Ray or not
		 */
		public function isPointOnRay(point:Number3D):Boolean
		{
			var bXY:Boolean = ((point.x - this._point.x) * this._vector.y == (point.y - this._point.y)*this._vector.x);
			var bXZ:Boolean = ((point.x - this._point.x) * this._vector.z == (point.z - this._point.z)*this._vector.x);
			return (bXY && bXZ);
		}
		
		/**
		 ****************************************************************************
		 ******     Get and Set Part for private variables     *********************
		 ****************************************************************************
		 */
		public function get point():Number3D
		{
			return this._point;
		}
		
		public function set point(point:Number3D):void {
			this._point = point;
		}

		public function get vector():Vector3D
		{
			return this._vector;
		}
		
		public function set vector(vector:Vector3D):void {
			this._vector = vector;
		}
		
	}
}