package cn.edu.zju.labx.utils
{
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number3D;
	
	public final class MathUtils
	{
		public static function matrix3DPosition( matrix:Matrix3D ) : Number3D
		{
			return new Number3D(matrix.n14, matrix.n24, matrix.n34)
		}
		
		public static function distanceToNumber3D( obj1:Number3D, obj2:Number3D ):Number
		{
			var x :Number = obj1.x - obj2.x;
			var y :Number = obj1.y - obj2.y;
			var z :Number = obj1.z - obj2.z;
	
			return Math.sqrt( x*x + y*y + z*z );
		}
		
		public static function distanceToMatrix3D( obj1:Matrix3D, obj2:Matrix3D ):Number
		{
			return distanceToNumber3D(matrix3DPosition(obj1), matrix3DPosition(obj2));
		}
		
		public static function translate( transform:Matrix3D, distance:Number, axis:Number3D ):Number3D
		{
			var vector:Number3D = axis.clone();
	
			Matrix3D.rotateAxis( transform, vector );
	
			return new Number3D(
				transform.n14 + distance * vector.x,
				transform.n24 + distance * vector.y,
				transform.n34 + distance * vector.z);
		}
		
		public static function randomInt(min:int, max:int):int
		{
			return int(Math.round(Math.random() * (max - min) + min));
		}
		
		public static function randomNumber(min:Number, max:Number):Number
		{
			return Math.random() * (max - min) + min;
		}

	}
}