package cn.edu.zju.labx.logicObject
{
	import cn.edu.zju.labx.core.LabXConstant;
	
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Ray3D;
	
	/**
	 * Line Ray Logic used for calculate a line ray. By default, we assume that the point
	 * is the start point of the ray, and the vector is the direction of the the ray.
	 */
	public class LineRayLogic extends Ray3D
	{
		/**
		 * @param  point:Number3D start point of the ray
		 * @param  vector:Number3D direction of the ray  
		 */
		public function LineRayLogic(point:Number3D=null, vector:Number3D=null)
		{
			point = point || new Number3D();
			vector = vector || new Number3D(1, 0, 0);
			vector = vector.clone();
			vector.normalize();
			super(point.x, point.y, point.z, vector.x, vector.y, vector.z);
		}
		
		/**
		 * Check whether the point is on Ray or not
		 */
		public function isPointOnRay(point:Number3D):Boolean
		{
			var precisionXY:Number = ((point.x - x) * dy - (point.y - y) * dx);
			var precisionXZ:Number = ((point.x - x) * dz - (point.z - z) * dx);
			return ((Math.abs(precisionXY) < LabXConstant.NUMBER_PRECISION) && (Math.abs(precisionXZ) < LabXConstant.NUMBER_PRECISION));
		}

	}
}