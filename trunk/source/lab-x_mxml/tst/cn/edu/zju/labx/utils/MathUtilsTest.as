package cn.edu.zju.labx.utils
{
	import flexunit.framework.Assert;
	
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
		
		//TODO: add test for FFT2D
		
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
		
	}
}