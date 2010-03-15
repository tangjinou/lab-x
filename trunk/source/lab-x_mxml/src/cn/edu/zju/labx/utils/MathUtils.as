package cn.edu.zju.labx.utils
{
	import cn.edu.zju.labx.core.LabXError;
	
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number2D;
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
		   This computes an in-place complex-to-complex FFT 
		   x and y are the real and imaginary arrays of 2^m points.
		   dir =  1 gives forward transform
		   dir = -1 gives reverse transform 
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
    	 
    	 private static function log2(input:Number):Number{
		    if(input<=0){
		        return NaN;
		    }else if((input&(input-1))==0){
		        var a:int=0;
		        while(input>1){input>>=1; ++a;}
		        return a;
		    }else{
		        return Math.log(input)*Math.LOG2E;
		    }
		}
		
    	 /**
	     * @method  fft2D
	     * @description  Performs a 2D fft in place given a complex 2D array.
	     * @usage  <pre>FFT2D(comp_arr, nx, ny, dir);</pre>
	     * @param  comp_arr  (Array)  -- a 2d array, each element contains a {re:val, im:val} Complex object.
	     * @param  nx  (Number)  -- an integer, the size of the array rows.
	     * @param  ny  (Number)  -- an integer, the size of the array columns.
	     * @param  dir  (Number)  -- the direction dir, 1 for forward, -1 for reverse.
	     * @return  (Boolean)  -- returns false if there are memory problems or the dimensions are not powers of 2
	     **/
    	 
    	public static function FFT2D(comp_arr:Array, nx:Number = NaN, ny:Number = NaN, dir:Number = 1):Boolean {
        var i:Number, j:Number, m:Number;
        var real:Number, imag:Number;
        var real_arr:Array = [];
        var imag_arr:Array = [];

        // Transform the rows
        real = nx;
        imag = nx;
        if (isNaN(real) || isNaN(imag)) return false;
        if (!((nx-1)&nx)==0) return false;
        m = log2(nx);
        for (j=0;j<ny;j++) {
            for (i=0;i<nx;i++) {
                real_arr[i] = comp_arr[i][j].real;
                imag_arr[i] = comp_arr[i][j].imag;
            }
            FFT(dir, m, real_arr, imag_arr);
            for (i=0;i<nx;i++) {
                comp_arr[i][j].real = real_arr[i];
                comp_arr[i][j].imag = imag_arr[i];
            }
        }
        real_arr = [];
        imag_arr = [];

        // Transform the columns
        real = ny;
        imag = ny;
        if (isNaN(real) || isNaN(imag)) return false;
        if (!((ny-1)&ny)==0) return false;
        m = log2(ny);
        for (i=0;i<nx;i++) {
            for (j=0;j<ny;j++) {
                real_arr[j] = comp_arr[i][j].real;
                imag_arr[j] = comp_arr[i][j].imag;
            }
            FFT(dir, m, real_arr, imag_arr);
            for (j=0;j<ny;j++) {
                comp_arr[i][j].real = real_arr[j];
                comp_arr[i][j].imag = imag_arr[j];
            }
        }
        real_arr = [];
        imag_arr = [];

        return true;
    	}
	 
		 /**
		  * Calculate the intersaction of two lines.
		  * @usage: MathUtil.calculateIntersaction(a, b, c, d); 
		  * 
		  * @param a (Number2D) first point in first line
		  * @param b (Number2D) second point in first line
		  * @param m (Number2D) first point in first line
		  * @param n (Number2D) second point in second line
		  * 
		  */
		 public static function calculateIntersaction(a:Number2D, b:Number2D, m:Number2D, n:Number2D):Number2D
		 {
			var result:Number2D = new Number2D();
			
			var x1:Number = a.x;
			var y1:Number = a.y;
			
			var x2:Number = m.x;
			var y2:Number = m.y;
			
			var x1v:Number = b.x - a.x;
			var y1v:Number = b.y - a.y;
			
			var x2v:Number = n.x - m.x;
			var y2v:Number = n.y - m.y;
			
			if (x1v*y2v == x2v*y1v)
			{
				return null;
			}
			if (y1v == 0) 
			{
				result.y = a.y;
				result.x = x2v/y2v * (result.y-y2) + x2;
				return result;
			}
			
			result.y = ((x2 - x1)*y1v*y2v + x1v*y2v*y1-x2v*y1v*y2)/(x1v*y2v-x2v*y1v);
			result.x = x1v*(result.y-y1)/y1v + x1;
			
			return result;
		}
		
		
		/***
		 *  calculate the point'position in Flat based on the line
		 * 
		 *  @param  transform is the Flat's normals
		 *  @param  vetor is line's vetor
		 *  @Exception The two vectors are not in the same dirction
		 *  @return the point's  position
		 *   
		 **/
		public static function calculatePointInFlat(transform:Matrix3D,vetor:Number3D,startPoint:Number3D):Number3D{
//		   var x0:Number = transform.n14;
//		   var y0:Number = transform.n24;
//		   var z0:Number = transform.n34;

		   var D:Number = 0 - transform.n14*transform.n11 - transform.n24*transform.n12-transform.n34*transform.n13;
		   var m:Number = transform.n11*vetor.x + transform.n12*vetor.y + transform.n13*vetor.z;
		   if(!isZero(m)){
		      var k:Number = (0 - D - startPoint.x*transform.n11 -startPoint.y*transform.n12 -startPoint.z*transform.n13)/m
		      
		      var resultPoint:Number3D = new Number3D(vetor.x*k+startPoint.x,vetor.y*k+startPoint.y,vetor.z*k+startPoint.z);
		      
		      if(isVetorTheSameDirection(vetor,Number3D.sub(resultPoint,startPoint))){
		         return resultPoint;
		      }
		      throw new LabXError("The two vectors are not in the same dirction");
		      
		   }
           throw new LabXError("");
		}
		
		public static function isZero(number:Number):Boolean{
		   if(Math.abs(number)<0.000001){
		      return true;
		   }
		   return false;
		}
		
		
		/***
		 *   @return  if the two vector is the same direction, return true
		 */ 
		public static function isVetorTheSameDirection(v1:Number3D,v2:Number3D):Boolean{
           if(Number3D.dot(v1,v2)>0){
              return true;
           }
           return false;		   
		}
		
		
		/**
		  * Calculate the intersaction of two lines. we assume the 2 lines are the same plane
		  * @usage: MathUtil.calculateIntersaction(a, b, c, d); 
		  * 
		  * @param a (Number3D) first point in first line
		  * @param b (Number3D) second point in first line
		  * @param m (Number3D) first point in first line
		  * @param n (Number3D) second point in second line
		  * 
		  */
		public static function calculate3DIntersection(a:Number3D, b:Number3D, c:Number3D, d:Number3D):Number3D
		{
			var v0:Number3D = Number3D.sub(b, a);
			v0.normalize();
			
			var p0:Number = Number3D.dot(Number3D.sub(c, a), v0);
			
			//point is p = a + v*p0;
			var tmp:Number3D = v0.clone();
			tmp.multiplyEq(p0);
			var conj:Number3D = Number3D.add(tmp, a);
			
			//normal is p - c
			var normal:Number3D = Number3D.sub(conj, c);
			normal.normalize();
			
			
			var d0:Number = Number3D.dot(Number3D.sub(c, a), normal);
			var d1:Number = Number3D.dot(Number3D.sub(d, a), normal);
			
			var m:Number = d1 / (d1 - d0);
			
			return new Number3D(
					d.x + (c.x-d.x)*m,
					d.y + (c.y-d.y)*m,
					d.z + (c.z-d.z)*m
			);
		}
	}
}