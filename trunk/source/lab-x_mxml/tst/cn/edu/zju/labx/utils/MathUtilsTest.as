package cn.edu.zju.labx.utils
{
	import cn.edu.zju.labx.core.LabXConstant;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.asserts.assertTrue;
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number2D;
	import org.papervision3d.core.math.Number3D;
	
	

	public class MathUtilsTest
	{
		/* FFT test source from http://www.sccon.ca/sccon/fft/fft3.htm */
        [Test] 
		public function testFFT_single_impulse():void{
			var i:Number;
			var real:Array = new Array(1, 0, 0, 0, 0, 0, 0, 0);
			var imaginary:Array = new Array(0, 0, 0, 0, 0, 0, 0, 0);
			MathUtils.FFT(1, 3, real, imaginary);
			for (i = 0; i < 8; i++)
			{
				Assert.assertEquals(real[i], 0.125);
				Assert.assertEquals(imaginary[i], 0);
			}
		}
		
		[Test] 
		public function testFFT_single_impulse_with_phase():void{
			var i:Number;
			var res:Number;
			var real:Array = new Array(0, 1, 0, 0, 0, 0, 0, 0);
			var imaginary:Array = new Array(0, 0, 0, 0, 0, 0, 0, 0);
			MathUtils.FFT(1, 3, real, imaginary);
			for (i = 0; i < 8; i++)
			{
				res = Math.sqrt(real[i] * real[i] + imaginary[i] * imaginary[i]);
				Assert.assertTrue(Math.abs( res - 0.125) < 0.000001);
			}
		}
		
		[Test] 
		public function testFFT2D_single_square():void{
			var i:Number;
			var j:Number;
			var res:Boolean;
			var rowIndex:Number = 8;
			var colIndex:Number = 8;
			var comp_arr:Array = new Array(rowIndex);

			for (i = 0; i < rowIndex; i++)
			{
				comp_arr[i]=new Array(colIndex);
				for (j = 0; j < colIndex; j++)
				{
					//if (i < rowIndex/2 && j < colIndex/2)
						comp_arr[i][j] = new Complex(1, 0);
					//else
						//comp_arr[i][j] = new Complex(0, 0);
				}
			}

			res = MathUtils.FFT2D(comp_arr, rowIndex, colIndex, 1);
			Assert.assertEquals(true, res);
			MathUtils.FFT2D(comp_arr, rowIndex, colIndex, -1);
			
		}
		
		[Test] 
		public function testDistanceToNumber3D():void{
		   var number1:Number3D =new Number3D(0,0,0);
		   var number2:Number3D =new Number3D(1,2,2);
           var result:Number=MathUtils.distanceToNumber3D(number1,number2);
		   Assert.assertEquals(Number(3),result);
		}
		
		[Test]
		public function testDistanceToMatrix3D():void{
		   
		}
		
		[Test]
		public function testCalculateIntersaction():void {
			var result:Number2D;
			
			//parallel
			var a:Number2D = new Number2D(0, 0);
			var b:Number2D = new Number2D(1, 1);
			var m:Number2D = new Number2D(1, 2);
			var n:Number2D = new Number2D(2, 3);
			
			result = MathUtils.calculateIntersaction(a, b, m, n);
			Assert.assertEquals(null, result);
			
			a = new Number2D(0, 0);
			b = new Number2D(1, 0);
			m = new Number2D(1, 2);
			n = new Number2D(2, 1);
			
			result = MathUtils.calculateIntersaction(a, b, m, n);
			Assert.assertEquals(3, result.x);
			Assert.assertEquals(0, result.y);
			
			a = new Number2D(0, 0);
			b = new Number2D(0, 1);
			m = new Number2D(1, 2);
			n = new Number2D(2, 1);
			result = MathUtils.calculateIntersaction(a, b, m, n);
			Assert.assertEquals(0, result.x);
			Assert.assertEquals(3, result.y);
			
			a = new Number2D(0, 0);
			b = new Number2D(-1, -1);
			m = new Number2D(1, 2);
			n = new Number2D(1, 5);
			result = MathUtils.calculateIntersaction(a, b, m, n);
			Assert.assertEquals(1, result.x);
			Assert.assertEquals(1, result.y);
			
			a = new Number2D(10, 15);
			b = new Number2D(20, 5);
			m = new Number2D(-10, -20);
			n = new Number2D(-20, -5);
			result = MathUtils.calculateIntersaction(a, b, m, n);
			Assert.assertEquals(-120, result.x);
			Assert.assertEquals(145, result.y);
			
			a = new Number2D(100, 155);
			b = new Number2D(256, 523);
			m = new Number2D(-10, -20);
			n = new Number2D(-20, -5);
			result = MathUtils.calculateIntersaction(a, b, m, n);
			assertTrue(Math.abs(result.x-11.893687707641192 ) < LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(result.y+52.840531561461795) < LabXConstant.NUMBER_PRECISION);
			
//			var r1:RayLogic = new RayLogic(new Number3D(100, 155, 0), new Vector3D(156, 368, 0));
//			assertTrue(r1.isPointOnRay(new Number3D(result.x, result.y, 0)));
//			
//			var r2:RayLogic = new RayLogic(new Number3D(-20, -5, 0), new Vector3D(10, -15, 0));
//			assertTrue(r2.isPointOnRay(new Number3D(result.x, result.y, 0)));
		}
		
		[Test]
		public function testCalculatePointInPlane():void {
			var transform:Matrix3D = new Matrix3D();
			transform.n14 = 1;
			/*
			* 1		0		0		1
            * 0		1		0		0
			* 0		0		1		0
			* 0		0		0		1
            */
		    
		    var line:Number3D;
		    var startPoint:Number3D;
		    var result:Number3D;
		    
		    line = new Number3D(-2,2,0);
		    startPoint = new Number3D(2,0,0);
		    result = MathUtils.calculatePointInPlane(transform,line,startPoint);
		    Assert.assertNotNull(result);
		    Assert.assertEquals(result.x,1);
		    Assert.assertEquals(result.y,1);
		    Assert.assertEquals(result.z,0);
		    
		    line = new Number3D(-3,3,0);
		    startPoint = new Number3D(3,0,0);
		    result = MathUtils.calculatePointInPlane(transform,line,startPoint);
		    Assert.assertNotNull(result);
		    Assert.assertEquals(result.x,1);
		    Assert.assertEquals(result.y,2);
		    Assert.assertEquals(result.z,0);
		    
		    try{
		      line = new Number3D(1,0,0);
		      startPoint = new Number3D(2,0,0);
		      result = MathUtils.calculatePointInPlane(transform,line,startPoint);
            } catch (err:Error){
               Assert.assertTrue(err is Error);            
            }
		    
		    
		    line = new Number3D(2,2,0);
		    startPoint = new Number3D(-1,0,0);
		    result = MathUtils.calculatePointInPlane(transform,line,startPoint);
		    Assert.assertNotNull(result);
		    Assert.assertEquals(result.x,1);
		    Assert.assertEquals(result.y,2);
		    Assert.assertEquals(result.z,0);
		    
		    
		    
		    
		    
		    transform.n11 = 0;
		    transform.n12 = 1;
		    transform.n14 = 0;
		    transform.n24 = 1;
		    /*
			* 0		1		0		0
            * 0		1		0		1
			* 0		0		1		0
			* 0		0		0		1
            */
		    line = new Number3D(0,3,0);
		    startPoint = new Number3D(1,0,0);
		    result = MathUtils.calculatePointInPlane(transform,line,startPoint);
		    Assert.assertNotNull(result);
		    Assert.assertEquals(result.x,1);
		    Assert.assertEquals(result.y,1);
		    Assert.assertEquals(result.z,0);
		    
		    transform.n11 = 0.771;
		    transform.n12 = 0.771;
		    transform.n13 = 0;
		    transform.n14 = 1;
		    transform.n24 = 0;
		    transform.n34 = 0;
		    /*
			* 0.771	0.771	0		1
            * 0		1		0		0
			* 0		0		1		0
			* 0		0		0		1
            */
            line = new Number3D(2,2,0);
		    startPoint = new Number3D(0,-1,0);
		    result = MathUtils.calculatePointInPlane(transform,line,startPoint);
		    Assert.assertNotNull(result);
		    Assert.assertEquals(result.x,1);
		    Assert.assertEquals(result.y,0);
		    Assert.assertEquals(result.z,0);
            
		    
		    
		    
		    
		}
		
		[Test]
		public function testCalculatePointInPlane2():void {
		   
		    var flat_position:Number3D =new Number3D(1,0,0);
		    var flat_norma:Number3D =new Number3D(1,0,0);
		    var line:Number3D;
		    var startPoint:Number3D;
		    var result:Number3D;
		    line = new Number3D(-2,2,0);
		    startPoint = new Number3D(2,0,0);
		    result = MathUtils.calculatePointInPlane2(flat_position,flat_norma,line,startPoint);
		    Assert.assertNotNull(result);
		    Assert.assertEquals(result.x,1);
		    Assert.assertEquals(result.y,1);
		    Assert.assertEquals(result.z,0);
		    
		    
		    flat_position = new Number3D(1,0,0);
		    flat_norma = new Number3D(1.71,0.71,0);
		    line = new Number3D(2,2,0);
		    startPoint = new Number3D(0,-1,0);
            result = MathUtils.calculatePointInPlane2(flat_position,flat_norma,line,startPoint);
		    Assert.assertNotNull(result);
		    Assert.assertEquals(result.x,1);
		    Assert.assertEquals(result.y,0);
		    Assert.assertEquals(result.z,0);
		
		}

		[Test] 
		public function testCalculate3DIntersaction():void
		{
			var a:Number3D;
			var b:Number3D;
			var m:Number3D;
			var n:Number3D;
			
			var result:Number3D;
			
			a = new Number3D(0, 0, 0);
			b = new Number3D(-1, -1, 0);
			m = new Number3D(1, 2, 0);
			n = new Number3D(1, 5, 0);
			result = MathUtils.calculate3DIntersection(a, b, m, n);
			assertTrue(Math.abs(1 - result.x) < LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(1 - result.y) < LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(0 - result.z) < LabXConstant.NUMBER_PRECISION);
			
			a = new Number3D(10, 15, 0);
			b = new Number3D(20, 5, 0);
			m = new Number3D(-10, -20, 0);
			n = new Number3D(-20, -5, 0);
			result = MathUtils.calculate3DIntersection(a, b, m, n);
			assertTrue(Math.abs(result.x+120) < LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(result.y-145) < LabXConstant.NUMBER_PRECISION);
			
			a = new Number3D(100, 155, 0);
			b = new Number3D(256, 523, 0);
			m = new Number3D(-10, -20, 0);
			n = new Number3D(-20, -5, 0);
			result = MathUtils.calculate3DIntersection(a, b, m, n);
			assertTrue(Math.abs(result.x-11.893687707641192 ) < LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(result.y+52.840531561461795) < LabXConstant.NUMBER_PRECISION);
			
			a = new Number3D(0, 100, 155);
			b = new Number3D(0, 256, 523);
			m = new Number3D(0, -10, -20);
			n = new Number3D(0, -20, -5);
			result = MathUtils.calculate3DIntersection(a, b, m, n);
			assertTrue(Math.abs(result.y-11.893687707641192 ) < LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(result.z+52.840531561461795) < LabXConstant.NUMBER_PRECISION);
			
		}
		
		[Test] 
		public function testCalculate3DIntersaction2():void
		{
			var orig:Number3D = new  Number3D(34, 12, 100);
			var v1:Number3D = new Number3D(3, 1, -4);
			var v2:Number3D = new Number3D(-2, -15, 189);
			
			var a:Number3D = v1;
			var b:Number3D = v1;
			var m:Number3D = v2;
			var n:Number3D = v2;
			
			a.multiplyEq(34);
			a = Number3D.add(orig, a);
			
			b.multiplyEq(-23);
			b = Number3D.add(orig, b);
			
			m.multiplyEq(6);
			m = Number3D.add(orig, m);
			
			n.multiplyEq(98);
			n = Number3D.add(orig, n);
			
			var result1:Number3D = MathUtils.calculate3DIntersection(a, b, m, n);
			var result2:Number3D = MathUtils.calculate3DIntersection(b, a, n, m);
			var result3:Number3D = MathUtils.calculate3DIntersection(n, m, a, b);
			var result4:Number3D = MathUtils.calculate3DIntersection(m, n, b, a);
			
			assertTrue(Math.abs(result1.x-result2.x)<LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(result2.x-result3.x)<LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(result3.x-result4.x)<LabXConstant.NUMBER_PRECISION);
			
			assertTrue(Math.abs(result1.y-result2.y)<LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(result2.y-result3.y)<LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(result3.y-result4.y)<LabXConstant.NUMBER_PRECISION);
			
			assertTrue(Math.abs(result1.z-result2.z)<LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(result2.z-result3.z)<LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(result3.z-result4.z)<LabXConstant.NUMBER_PRECISION);
		}
		
		[Test] 
		public function calculate3DreflectionVector():void{
		   var v:Number3D = new Number3D(1,1,0);
		   var m:Number3D = new Number3D(1,0,0);
		   var v2:Number3D;
		   v2= MathUtils.calculate3DreflectionVector(v,m);
		   assertTrue(Math.abs(v2.x+0.70710678)<LabXConstant.NUMBER_PRECISION);
		   assertTrue(Math.abs(v2.y-0.70710678)<LabXConstant.NUMBER_PRECISION);
		   assertTrue(Math.abs(v2.z-0)<LabXConstant.NUMBER_PRECISION);


	   
		   v = new Number3D(-1,1,0);
		   v2 = MathUtils.calculate3DreflectionVector(v,m);
		   assertTrue(Math.abs(v2.x-0.70710678)<LabXConstant.NUMBER_PRECISION);
		   assertTrue(Math.abs(v2.y-0.70710678)<LabXConstant.NUMBER_PRECISION);
		   assertTrue(Math.abs(v2.z-0)<LabXConstant.NUMBER_PRECISION);

		   
		   
		   v = new Number3D(0,1,0);
		   m = new Number3D(1,-1,0);
		   v2 = MathUtils.calculate3DreflectionVector(v,m);
		   assertTrue(Math.abs(v2.x-1)<LabXConstant.NUMBER_PRECISION);
		   assertTrue(Math.abs(v2.y-0)<LabXConstant.NUMBER_PRECISION);
		   assertTrue(Math.abs(v2.z-0)<LabXConstant.NUMBER_PRECISION);

		   
		}
		
		[Test]
		public function calculateAngleOfTwoVector():void{
		   var v1:Number3D = new Number3D(3,0,0);
		   var v2:Number3D = new Number3D(0,2,0);
		   
		   var r:Number = MathUtils.calculateAngleOfTwoVector(v1,v2);
		   assertTrue(Math.abs(r - Math.PI/2)<LabXConstant.NUMBER_PRECISION);
           
           
           v1 = new Number3D(1,0,0);
           v2 = new Number3D(-1,0,0);
           r = MathUtils.calculateAngleOfTwoVector(v1,v2);
           assertTrue(Math.abs(r - Math.PI)<LabXConstant.NUMBER_PRECISION);		   
		
		   
		   v1 = new Number3D(1,1,0);
           v2 = new Number3D(1,0,0);
           r = MathUtils.calculateAngleOfTwoVector(v1,v2);
           assertTrue(Math.abs(r - Math.PI/4)<LabXConstant.NUMBER_PRECISION);	
		 
		}
		
	}
}