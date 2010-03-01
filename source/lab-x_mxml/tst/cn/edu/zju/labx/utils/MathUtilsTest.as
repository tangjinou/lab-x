package cn.edu.zju.labx.utils
{
	import flexunit.framework.Assert;
	
	import org.papervision3d.core.math.Number3D;
	
	

	public class MathUtilsTest
	{
        [Test] 
		public function testFFT():void{
		   
		}
		
		
		[Test] 
		public function testDistanceToNumber3D():void{
		   
		   var number1:Number3D =new Number3D(0,0,0);
		   var number2:Number3D =new Number3D(1,2,2);
           var result:Number=MathUtils.distanceToNumber3D(number1,number2);
		   Assert.assertEquals(Number(3),result);

		}
		
	}
}