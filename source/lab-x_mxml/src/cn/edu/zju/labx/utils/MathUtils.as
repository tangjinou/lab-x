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
	        
	        return Math.sqrt(x*x+y*y+z*z);
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
		
		/**
		 *   This should be checked~
		 ***/
		public static function FFT(dir:Number, m:Number, x:Array, y:Array):void
   		{
    		 //trace('Getting FFT');
     		 var n:Number; var i:Number;  var i1:Number;
     		 var j:Number; var k:Number; var i2:Number; 
     		 var l:Number; var  l1:Number; var  l2:Number;
     
             var c1:Number; var c2:Number; var tx:Number; var ty:Number; var t1:Number; 
             var t2:Number; var u1:Number; var u2:Number; var z:Number; 
     
             n = 1;
             for (i=0;i<m;i++) 
    			n *= 2;
   			// n = m;
    
    		/* Do the bit reversal */
    		//trace("Bit Reversal");
     		i2 = n >> 1;
     		j = 0;
     		for (i=0;i<n-1;i++) {
     		if (i < j) {
     			tx = x[i];
    			ty = y[i];
     			x[i] = x[j];
     			y[i] = y[j];
     			x[j] = tx;
     			y[j] = ty;
    	    }
     		k = i2;
     		while (k <= j) {
     				j -= k;
    				k >>= 1;
     		}
     			j += k;
     		}
     
            /* Compute the FFT */
     		c1 = -1.0; 
     		c2 = 0.0;
     		l2 = 1;
     		for (l = 0; l < m; l++) {
    		//  trace('FFTing at ' + l + ' of ' + m);
     		l1 = l2;
     		l2 <<= 1;
     		u1 = 1.0; 
     		u2 = 0.0;
     		for (j=0;j<l1;j++) {
     		for (i=j;i<n;i+=l2) {
     				i1 = i + l1;
     				t1 = u1 * x[i1] - u2 * y[i1];
     				t2 = u1 * y[i1] + u2 * x[i1];
     				x[i1] = x[i] - t1; 
     				y[i1] = y[i] - t2;
     				x[i] += t1;
     				y[i] += t2;
     		}
     			z =  u1 * c1 - u2 * c2;
     			u2 = u1 * c2 + u2 * c1;
     			u1 = z;
     		}
     			c2 = Math.sqrt((1.0 - c1) * 0.5);
    			 if (dir == 1) 
     				c2 = -c2;
     			 c1 = Math.sqrt((1.0 + c1) * 0.5);
    		}

     		/* Scaling for forward transform */
    		 if (dir == 1) {
    			 for (i=0;i<n;i++) {
     				x[i] /= n;
     				y[i] /= n;
     			 }
    		 }
    	 }

	   }
	   
}