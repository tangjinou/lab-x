package cn.edu.zju.labx.utils
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.logicObject.RayLogic;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.asserts.assertTrue;
	import org.flintparticles.threeD.geom.Vector3D;
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
		
	}
}